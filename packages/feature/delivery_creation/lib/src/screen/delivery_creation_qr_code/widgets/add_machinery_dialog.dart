import 'package:domain/domain.dart';
import 'package:feature_delivery_creation/feature_delivery_creation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:use_cases/use_cases.dart';

import '../../../l10n/l10n.dart';

class AddMachineryDialog extends StatefulWidget {
  final String orderId;
  final String? productName;
  final Function(MachineryItemEntity) onAdd;

  const AddMachineryDialog({
    super.key,
    required this.orderId,
    this.productName,
    required this.onAdd,
  });

  @override
  State<AddMachineryDialog> createState() => _AddMachineryDialogState();
}

class _AddMachineryDialogState extends State<AddMachineryDialog> {
  bool _isFromMaster = true;
  MachineryItemEntity? _selectedMachine;
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _quantityController = TextEditingController();

  List<MachineryItemEntity> _masterMachines = [];
  bool _isLoadingMaster = false;

  @override
  void initState() {
    super.initState();
    _loadMasterMachines();
  }

  Future<void> _loadMasterMachines() async {
    setState(() => _isLoadingMaster = true);
    final result = await GetIt.instance<GetMasterMachinesUseCase>().call();
    if (result.isSuccess) {
      setState(() {
        _masterMachines = result.dataOrThrow;
        _isLoadingMaster = false;
      });
    } else {
      setState(() => _isLoadingMaster = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.deliveryCreationL10n.add_machinery_dialog_title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _isFromMaster,
                  onChanged: (value) => setState(() => _isFromMaster = value!),
                ),
                Text(context.deliveryCreationL10n.from_master_label),
                Radio<bool>(
                  value: false,
                  groupValue: _isFromMaster,
                  onChanged: (value) => setState(() => _isFromMaster = value!),
                ),
                Text(context.deliveryCreationL10n.new_registration_label),
              ],
            ),
            const SizedBox(height: 16),
            if (_isFromMaster) _buildMasterSelection() else _buildManualInput(),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: context.deliveryCreationL10n.quantity_input_label,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: _onSave,
          child: const Text('追加'),
        ),
      ],
    );
  }

  Widget _buildMasterSelection() {
    if (_isLoadingMaster) return const CircularProgressIndicator();

    return DropdownButtonFormField<MachineryItemEntity>(
      value: _selectedMachine,
      hint: Text(context.deliveryCreationL10n.select_machine_hint),
      items: _masterMachines.map((machine) {
        return DropdownMenuItem(
          value: machine,
          child: Text('${machine.machineryName} (${machine.vehicleNumber})'),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedMachine = value),
    );
  }

  Widget _buildManualInput() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: context.deliveryCreationL10n.machine_name_input_label,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _numberController,
          decoration: InputDecoration(
            labelText: context.deliveryCreationL10n.vehicle_number_input_label,
          ),
        ),
      ],
    );
  }

  void _onSave() {
    final quantity = double.tryParse(_quantityController.text);
    if (quantity == null) return;

    final MachineryItemEntity machinery;
    if (_isFromMaster) {
      if (_selectedMachine == null) return;
      final m = _selectedMachine!;
      machinery = MachineryItemEntity(
        machineId: m.machineId,
        machineryName: m.machineryName,
        vehicleNumber: m.vehicleNumber,
        quantity: quantity,
        images: m.images,
        productId: m.productId,
        productName: m.productName ?? widget.productName,
      );
    } else {
      if (_nameController.text.isEmpty || _numberController.text.isEmpty) return;
      machinery = MachineryItemEntity(
        machineId: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID
        machineryName: _nameController.text,
        vehicleNumber: _numberController.text,
        quantity: quantity,
        productName: widget.productName,
      );
    }

    widget.onAdd(machinery);
    Navigator.of(context).pop(true);
  }
}
