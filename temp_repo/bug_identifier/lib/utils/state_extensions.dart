import 'package:flutter/material.dart';

/// Helper class for checking widget mount state
class MountedChecker {
  /// Check if a BuildContext is still valid (for mounted widgets)
  static bool isContextMounted(BuildContext context) {
    try {
      context.widget;
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// Extension methods for BuildContext
extension ContextMountedExtension on BuildContext {
  /// Check if the widget associated with this context is still mounted
  /// Usage: if (context.isMounted) { ... }
  bool get isMounted => MountedChecker.isContextMounted(this);

  /// Safely execute a callback if context is mounted
  /// Usage: context.ifMounted(() { Navigator.pop(context); });
  void ifMounted(VoidCallback callback) {
    if (isMounted) {
      callback();
    }
  }
}
