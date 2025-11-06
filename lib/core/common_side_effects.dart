import 'package:flutter/material.dart';
import 'side_effect_base.dart';

/// ==================== SnackBar Side Effects ====================

/// Side Effect لعرض SnackBar
class ShowSnackBarSideEffect extends BaseSideEffect {
  /// الرسالة المراد عرضها
  final String message;
  
  /// لون الخلفية
  final Color? backgroundColor;
  
  /// مدة العرض
  final Duration duration;
  
  /// أيقونة اختيارية
  final IconData? icon;
  
  /// زر إجراء اختياري
  final SnackBarAction? action;

  const ShowSnackBarSideEffect({
    required this.message,
    this.backgroundColor,
    this.duration = const Duration(seconds: 3),
    this.icon,
    this.action,
  });
}

/// Side Effect لعرض SnackBar نجاح (أخضر)
class ShowSuccessSnackBarSideEffect extends ShowSnackBarSideEffect {
  const ShowSuccessSnackBarSideEffect({
    required super.message,
    super.duration,
    super.action,
  }) : super(
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
}

/// Side Effect لعرض SnackBar خطأ (أحمر)
class ShowErrorSnackBarSideEffect extends ShowSnackBarSideEffect {
  const ShowErrorSnackBarSideEffect({
    required super.message,
    super.duration,
    super.action,
  }) : super(
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
}

/// Side Effect لعرض SnackBar تحذير (برتقالي)
class ShowWarningSideEffect extends ShowSnackBarSideEffect {
  const ShowWarningSideEffect({
    required super.message,
    super.duration,
    super.action,
  }) : super(
          backgroundColor: Colors.orange,
          icon: Icons.warning,
        );
}

/// Side Effect لعرض SnackBar معلومات (أزرق)
class ShowInfoSnackBarSideEffect extends ShowSnackBarSideEffect {
  const ShowInfoSnackBarSideEffect({
    required super.message,
    super.duration,
    super.action,
  }) : super(
          backgroundColor: Colors.blue,
          icon: Icons.info,
        );
}

/// ==================== Dialog Side Effects ====================

/// Side Effect لعرض Dialog
class ShowDialogSideEffect extends BaseSideEffect {
  /// عنوان الـ Dialog
  final String? title;
  
  /// محتوى الـ Dialog
  final String content;
  
  /// قائمة بالأزرار
  final List<DialogAction> actions;
  
  /// يمكن الإغلاق بالضغط خارج الـ Dialog
  final bool barrierDismissible;

  const ShowDialogSideEffect({
    this.title,
    required this.content,
    this.actions = const [],
    this.barrierDismissible = true,
  });
}

/// تمثيل لزر في Dialog
class DialogAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isDefault;
  
  const DialogAction({
    required this.text,
    this.onPressed,
    this.isDefault = false,
  });
}

/// Side Effect لعرض Dialog تأكيد
class ShowConfirmDialogSideEffect extends ShowDialogSideEffect {
  /// Callback عند التأكيد
  final VoidCallback onConfirm;
  
  /// Callback عند الإلغاء
  final VoidCallback? onCancel;
  
  /// نص زر التأكيد
  final String confirmText;
  
  /// نص زر الإلغاء
  final String cancelText;

  ShowConfirmDialogSideEffect({
    super.title,
    required super.content,
    required this.onConfirm,
    this.onCancel,
    this.confirmText = 'تأكيد',
    this.cancelText = 'إلغاء',
  }) : super(
          actions: [
            DialogAction(text: cancelText, onPressed: onCancel),
            DialogAction(text: confirmText, onPressed: onConfirm, isDefault: true),
          ],
        );
}

/// ==================== Navigation Side Effects ====================

/// Side Effect للانتقال لصفحة جديدة
class NavigateToSideEffect extends BaseSideEffect {
  /// اسم الـ Route
  final String? routeName;
  
  /// Widget للصفحة (بديل عن routeName)
  final Widget? page;
  
  /// معاملات اختيارية
  final Object? arguments;

  const NavigateToSideEffect({
    this.routeName,
    this.page,
    this.arguments,
  }) : assert(routeName != null || page != null, 'يجب تحديد routeName أو page');
}

/// Side Effect للانتقال مع استبدال الصفحة الحالية
class NavigateAndReplaceSideEffect extends BaseSideEffect {
  /// اسم الـ Route
  final String? routeName;
  
  /// Widget للصفحة
  final Widget? page;
  
  /// معاملات اختيارية
  final Object? arguments;

  const NavigateAndReplaceSideEffect({
    this.routeName,
    this.page,
    this.arguments,
  }) : assert(routeName != null || page != null, 'يجب تحديد routeName أو page');
}

/// Side Effect للانتقال مع حذف كل الصفحات السابقة
class NavigateAndRemoveUntilSideEffect extends BaseSideEffect {
  /// اسم الـ Route
  final String? routeName;
  
  /// Widget للصفحة
  final Widget? page;
  
  /// معاملات اختيارية
  final Object? arguments;

  const NavigateAndRemoveUntilSideEffect({
    this.routeName,
    this.page,
    this.arguments,
  }) : assert(routeName != null || page != null, 'يجب تحديد routeName أو page');
}

/// Side Effect للرجوع للصفحة السابقة
class NavigateBackSideEffect extends BaseSideEffect {
  /// نتيجة اختيارية للإرجاع
  final Object? result;

  const NavigateBackSideEffect([this.result]);
}

/// ==================== Bottom Sheet Side Effects ====================

/// Side Effect لعرض Bottom Sheet
class ShowBottomSheetSideEffect extends BaseSideEffect {
  /// Builder للـ Bottom Sheet
  final Widget Function(BuildContext) builder;
  
  /// يمكن الإغلاق بالسحب
  final bool isDismissible;
  
  /// يعرض handle في الأعلى
  final bool showDragHandle;

  const ShowBottomSheetSideEffect({
    required this.builder,
    this.isDismissible = true,
    this.showDragHandle = true,
  });
}

/// ==================== Loading Side Effects ====================

/// Side Effect لعرض Loading Indicator
class ShowLoadingSideEffect extends BaseSideEffect {
  /// رسالة اختيارية
  final String? message;

  const ShowLoadingSideEffect([this.message]);
}

/// Side Effect لإخفاء Loading Indicator
class HideLoadingSideEffect extends BaseSideEffect {
  const HideLoadingSideEffect();
}

/// ==================== Custom Side Effects ====================

/// Side Effect مخصص لتنفيذ أي إجراء
class CustomSideEffect extends BaseSideEffect {
  /// معرّف للـ side effect
  final String id;
  
  /// بيانات إضافية
  final Map<String, dynamic>? data;

  const CustomSideEffect({
    required this.id,
    this.data,
  });
}

