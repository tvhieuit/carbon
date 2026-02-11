import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';

/// Toast type enum for different visual styles
enum AppToastType {
  success,
  error,
  warning,
  info,
}

/// Toast position on the screen
enum AppToastPosition {
  top,
  center,
  bottom,
}

/// Custom toast wrapper using FToast with injectable.
///
/// Register via injectable and call [init] once from your app's root widget
/// (e.g. MaterialApp builder) before showing any toasts.
///
/// ```dart
/// getIt<AppToast>().init(context);
/// ```
@lazySingleton
class AppToast {
  FToast? _fToast;

  /// Initialize FToast with context.
  /// Call this once from your app's root widget.
  AppToast(BuildContext context) {
    _fToast = FToast()..init(context);
  }

  /// Show a toast with custom type and message
  void show(
    String message, {
    AppToastType type = AppToastType.info,
    String? title,
    Duration duration = const Duration(seconds: 2),
    AppToastPosition position = AppToastPosition.bottom,
    VoidCallback? onTap,
  }) {
    assert(_fToast != null, 'AppToast.init(context) must be called before showing toasts');

    final toast = _buildToastWidget(
      message: message,
      type: type,
      title: title,
      onTap: onTap,
    );

    _fToast!.showToast(
      child: toast,
      gravity: _getGravity(position),
      toastDuration: duration,
    );
  }

  /// Show success toast (green)
  void success(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 2),
    AppToastPosition position = AppToastPosition.bottom,
  }) {
    show(
      message,
      type: AppToastType.success,
      title: title,
      duration: duration,
      position: position,
    );
  }

  /// Show error toast (red)
  void error(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 2),
    AppToastPosition position = AppToastPosition.bottom,
  }) {
    print('error $message');
    // show(
    //   message,
    //   type: AppToastType.error,
    //   title: title,
    //   duration: duration,
    //   position: position,
    // );
  }

  /// Show warning toast (orange)
  void warning(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 2),
    AppToastPosition position = AppToastPosition.bottom,
  }) {
    show(
      message,
      type: AppToastType.warning,
      title: title,
      duration: duration,
      position: position,
    );
  }

  /// Show info toast (blue)
  void info(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 2),
    AppToastPosition position = AppToastPosition.bottom,
  }) {
    show(
      message,
      type: AppToastType.info,
      title: title,
      duration: duration,
      position: position,
    );
  }

  /// Cancel current toast
  void cancel() {
    _fToast?.removeCustomToast();
  }

  /// Cancel all queued toasts
  void cancelAll() {
    _fToast?.removeQueuedCustomToasts();
  }

  ToastGravity _getGravity(AppToastPosition position) {
    switch (position) {
      case AppToastPosition.top:
        return ToastGravity.TOP;
      case AppToastPosition.center:
        return ToastGravity.CENTER;
      case AppToastPosition.bottom:
        return ToastGravity.BOTTOM;
    }
  }

  Color _getBackgroundColor(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return const Color(0xFF4CAF50);
      case AppToastType.error:
        return const Color(0xFFF44336);
      case AppToastType.warning:
        return const Color(0xFFFF9800);
      case AppToastType.info:
        return const Color(0xFF2196F3);
    }
  }

  IconData _getIcon(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return Icons.check_circle_outline;
      case AppToastType.error:
        return Icons.error_outline;
      case AppToastType.warning:
        return Icons.warning_amber_outlined;
      case AppToastType.info:
        return Icons.info_outline;
    }
  }

  Widget _buildToastWidget({
    required String message,
    required AppToastType type,
    String? title,
    VoidCallback? onTap,
  }) {
    final backgroundColor = _getBackgroundColor(type);
    final icon = _getIcon(type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
