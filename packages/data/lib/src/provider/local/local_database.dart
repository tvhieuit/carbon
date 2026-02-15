import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class LocalDatabase {
  static const _dbName = 'carbon_local.db';
  static const _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE delivery_orders (
        id TEXT PRIMARY KEY,
        order_id TEXT,
        order_line_id TEXT,
        company_id TEXT,
        branch_id TEXT,
        construction_site_id TEXT,
        product_name TEXT,
        receipt_signature_id TEXT,
        receipt_file_id TEXT,
        machinery_items_json TEXT,
        non_oil_products_json TEXT,
        is_submitted INTEGER DEFAULT 0,
        error_message TEXT,
        needs_resubmission INTEGER DEFAULT 0,
        submission_attempts INTEGER DEFAULT 0,
        receipt_image_file_path TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE qrcode_orders (
        id TEXT PRIMARY KEY,
        order_id TEXT,
        machine_id TEXT,
        product_id TEXT,
        quantity TEXT,
        is_submitted INTEGER DEFAULT 0,
        needs_resubmission INTEGER DEFAULT 0,
        submission_attempts INTEGER DEFAULT 0,
        order_line_id TEXT,
        machine_name TEXT,
        machine_number TEXT,
        construction_site_id TEXT,
        construction_site_name TEXT,
        company_name TEXT,
        machine_product_name TEXT,
        order_no TEXT,
        product_name TEXT,
        product_type TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
  }

  // --- Delivery Order Operations ---

  Future<void> saveDeliveryOrder(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      'delivery_orders',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllDeliveryOrders() async {
    final db = await database;
    return await db.query('delivery_orders');
  }

  Future<List<Map<String, dynamic>>> getDeliveryOrdersForResubmission() async {
    final db = await database;
    return await db.query(
      'delivery_orders',
      where: 'needs_resubmission = ?',
      whereArgs: [1],
    );
  }

  Future<Map<String, dynamic>?> getDeliveryOrderByOrderId(String orderId) async {
    final db = await database;
    final results = await db.query(
      'delivery_orders',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> updateDeliverySubmissionStatus(
    String id, {
    required bool isSubmitted,
    String? errorMessage,
    String? receiptImageFilePath,
  }) async {
    final db = await database;
    await db.update(
      'delivery_orders',
      {
        'is_submitted': isSubmitted ? 1 : 0,
        'error_message': errorMessage,
        'needs_resubmission': isSubmitted ? 0 : 1,
        'submission_attempts': 1, // Simplified for now, can increment in repo
        'updated_at': DateTime.now().toIso8601String(),
        if (receiptImageFilePath != null) 'receipt_image_file_path': receiptImageFilePath,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteDeliveryOrder(String id) async {
    final db = await database;
    await db.delete(
      'delivery_orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllDeliveryOrders() async {
    final db = await database;
    await db.delete('delivery_orders');
  }

  // --- QR Code Order Operations ---

  Future<void> saveQrCodeOrder(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      'qrcode_orders',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUnsubmittedQrCodeOrders() async {
    final db = await database;
    return await db.query(
      'qrcode_orders',
      where: 'is_submitted = ?',
      whereArgs: [0],
    );
  }

  Future<void> deleteQrCodeOrdersByOrder(String orderId) async {
    final db = await database;
    await db.delete(
      'qrcode_orders',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
  }

  Future<void> deleteQrCodeOrderById(String id) async {
    final db = await database;
    await db.delete(
      'qrcode_orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllQrCodeOrders() async {
    final db = await database;
    await db.delete('qrcode_orders');
  }

  Future<Map<String, dynamic>?> getQrCodeOrderById(String id) async {
    final db = await database;
    final results = await db.query(
      'qrcode_orders',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getAllQrCodeOrders() async {
    final db = await database;
    return await db.query('qrcode_orders');
  }

  Future<List<Map<String, dynamic>>> getQrCodeOrderLatest() async {
    final db = await database;
    return await db.query(
      'qrcode_orders',
      where: 'is_submitted = ?',
      whereArgs: [0],
      orderBy: 'updated_at DESC',
      limit: 1,
    );
  }

  Future<Map<String, dynamic>?> findQrCodeOrder({
    required String orderId,
    required String machineId,
    required String productId,
    bool? isSubmitted,
  }) async {
    final db = await database;
    var where = 'order_id = ? AND machine_id = ? AND product_id = ?';
    final List<Object?> whereArgs = [orderId, machineId, productId];

    if (isSubmitted != null) {
      where += ' AND is_submitted = ?';
      whereArgs.add(isSubmitted ? 1 : 0);
    }

    final results = await db.query(
      'qrcode_orders',
      where: where,
      whereArgs: whereArgs,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> getQrCodeOrderByMachineAndSite({
    required String machineId,
    required String siteId,
  }) async {
    final db = await database;
    final results = await db.query(
      'qrcode_orders',
      where: 'machine_id = ? AND construction_site_id = ?',
      whereArgs: [machineId, siteId],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getQrCodeOrdersByOrderAndType({
    required String orderId,
    required String productType,
  }) async {
    final db = await database;
    return await db.query(
      'qrcode_orders',
      where: 'order_id = ? AND product_type = ?',
      whereArgs: [orderId, productType],
    );
  }

  Future<List<Map<String, dynamic>>> getUnsubmittedQrCodeOrdersByMachine(String machineId) async {
    final db = await database;
    return await db.query(
      'qrcode_orders',
      where: 'machine_id = ? AND is_submitted = ?',
      whereArgs: [machineId, 0],
    );
  }

  Future<void> updateQrCodeOrderQuantity(String id, String quantity) async {
    final db = await database;
    await db.update(
      'qrcode_orders',
      {
        'quantity': quantity,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
