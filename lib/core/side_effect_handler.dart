import 'package:flutter/material.dart';
import 'common_side_effects.dart';

/// Handler مركزي لتنفيذ Side Effects الشائعة
/// 
/// يوفر دوال مساعدة لتنفيذ side effects في UI بطريقة موحدة
class SideEffectHandler {
  SideEffectHandler._();

  /// معالجة ShowSnackBarSideEffect
  static void handleSnackBar(
    BuildContext context,
    ShowSnackBarSideEffect effect,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (effect.icon != null) ...[
              Icon(effect.icon, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(effect.message)),
          ],
        ),
        duration: effect.duration,
        backgroundColor: effect.backgroundColor,
        action: effect.action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// معالجة ShowDialogSideEffect
  static Future<void> handleDialog(
    BuildContext context,
    ShowDialogSideEffect effect,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: effect.barrierDismissible,
      builder: (context) => AlertDialog(
        title: effect.title != null ? Text(effect.title!) : null,
        content: Text(effect.content),
        actions: effect.actions.map((action) {
          return action.isDefault
              ? FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    action.onPressed?.call();
                  },
                  child: Text(action.text),
                )
              : TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    action.onPressed?.call();
                  },
                  child: Text(action.text),
                );
        }).toList(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// معالجة NavigateToSideEffect
  static void handleNavigateTo(
    BuildContext context,
    NavigateToSideEffect effect,
  ) {
    if (effect.routeName != null) {
      Navigator.of(context).pushNamed(
        effect.routeName!,
        arguments: effect.arguments,
      );
    } else if (effect.page != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => effect.page!,
        ),
      );
    }
  }

  /// معالجة NavigateAndReplaceSideEffect
  static void handleNavigateAndReplace(
    BuildContext context,
    NavigateAndReplaceSideEffect effect,
  ) {
    if (effect.routeName != null) {
      Navigator.of(context).pushReplacementNamed(
        effect.routeName!,
        arguments: effect.arguments,
      );
    } else if (effect.page != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => effect.page!,
        ),
      );
    }
  }

  /// معالجة NavigateAndRemoveUntilSideEffect
  static void handleNavigateAndRemoveUntil(
    BuildContext context,
    NavigateAndRemoveUntilSideEffect effect,
  ) {
    if (effect.routeName != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        effect.routeName!,
        (route) => false,
        arguments: effect.arguments,
      );
    } else if (effect.page != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => effect.page!,
        ),
        (route) => false,
      );
    }
  }

  /// معالجة NavigateBackSideEffect
  static void handleNavigateBack(
    BuildContext context,
    NavigateBackSideEffect effect,
  ) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(effect.result);
    }
  }

  /// معالجة ShowBottomSheetSideEffect
  static Future<void> handleBottomSheet(
    BuildContext context,
    ShowBottomSheetSideEffect effect,
  ) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: effect.isDismissible,
      showDragHandle: effect.showDragHandle,
      builder: effect.builder,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  /// معالجة ShowLoadingSideEffect
  static void handleShowLoading(
    BuildContext context,
    ShowLoadingSideEffect effect,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (effect.message != null) ...[
                    const SizedBox(height: 16),
                    Text(effect.message!),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// معالجة HideLoadingSideEffect
  static void handleHideLoading(
    BuildContext context,
    HideLoadingSideEffect effect,
  ) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}

