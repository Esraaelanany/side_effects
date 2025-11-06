import 'package:flutter/material.dart';

/// Side Effect Manager
/// مدير مركزي للتحكم في الـ Side Effects مثل SnackBar، Dialog، Navigation
/// يمنع تكرار نفس الـ Side Effect باستخدام نظام IDs فريدة (One-Shot Pattern)
class SideEffectManager {
  // Private constructor للـ Singleton Pattern
  SideEffectManager._internal();

  // الـ Instance الوحيدة من الكلاس
  static final SideEffectManager _instance = SideEffectManager._internal();

  // Factory constructor يرجع نفس الـ Instance دائماً
  factory SideEffectManager() => _instance;

  // Set لتخزين IDs الـ Side Effects التي تم تنفيذها
  final Set<String> _executedEffects = {};

  /// التحقق من أن الـ Side Effect لم يتم تنفيذه من قبل
  bool _canExecute(String id) {
    return !_executedEffects.contains(id);
  }

  /// تسجيل أن الـ Side Effect تم تنفيذه
  void _markAsExecuted(String id) {
    _executedEffects.add(id);
  }

  /// عرض SnackBar مرة واحدة فقط باستخدام ID فريد
  /// 
  /// [context]: BuildContext الحالي
  /// [id]: معرّف فريد للـ SnackBar
  /// [message]: الرسالة المراد عرضها
  /// [duration]: مدة عرض الـ SnackBar (افتراضي: 3 ثواني)
  /// [backgroundColor]: لون خلفية الـ SnackBar
  /// [action]: زر إجراء اختياري
  void showSnackOnce(
    BuildContext context,
    String id,
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    if (!_canExecute(id)) {
      debugPrint('⚠️ Side Effect [$id] تم تنفيذه من قبل');
      return;
    }

    _markAsExecuted(id);
    debugPrint('✅ تنفيذ Side Effect: $id');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
      ),
    );
  }

  /// عرض Dialog مرة واحدة فقط باستخدام ID فريد
  /// 
  /// [context]: BuildContext الحالي
  /// [id]: معرّف فريد للـ Dialog
  /// [title]: عنوان الـ Dialog
  /// [content]: محتوى الـ Dialog
  /// [actions]: قائمة بالأزرار
  Future<void> showDialogOnce(
    BuildContext context,
    String id, {
    String? title,
    required String content,
    List<Widget>? actions,
  }) async {
    if (!_canExecute(id)) {
      debugPrint('⚠️ Side Effect [$id] تم تنفيذه من قبل');
      return;
    }

    _markAsExecuted(id);
    debugPrint('✅ تنفيذ Side Effect: $id');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: Text(content),
        actions: actions ??
            [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('حسناً'),
              ),
            ],
      ),
    );
  }

  /// الانتقال إلى صفحة جديدة مرة واحدة فقط باستخدام ID فريد
  /// 
  /// [context]: BuildContext الحالي
  /// [id]: معرّف فريد للـ Navigation
  /// [routeName]: اسم الـ Route
  /// [arguments]: معاملات اختيارية للصفحة الجديدة
  void navigateOnce(
    BuildContext context,
    String id,
    String routeName, {
    Object? arguments,
  }) {
    if (!_canExecute(id)) {
      debugPrint('⚠️ Side Effect [$id] تم تنفيذه من قبل');
      return;
    }

    _markAsExecuted(id);
    debugPrint('✅ تنفيذ Side Effect: $id');

    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  /// الانتقال إلى صفحة مع استبدال الصفحة الحالية (مرة واحدة)
  /// 
  /// [context]: BuildContext الحالي
  /// [id]: معرّف فريد
  /// [routeName]: اسم الـ Route
  /// [arguments]: معاملات اختيارية
  void navigateAndReplaceOnce(
    BuildContext context,
    String id,
    String routeName, {
    Object? arguments,
  }) {
    if (!_canExecute(id)) {
      debugPrint('⚠️ Side Effect [$id] تم تنفيذه من قبل');
      return;
    }

    _markAsExecuted(id);
    debugPrint('✅ تنفيذ Side Effect: $id');

    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  /// الانتقال إلى صفحة مع حذف كل الصفحات السابقة (مرة واحدة)
  /// 
  /// [context]: BuildContext الحالي
  /// [id]: معرّف فريد
  /// [routeName]: اسم الـ Route
  /// [arguments]: معاملات اختيارية
  void navigateAndRemoveUntilOnce(
    BuildContext context,
    String id,
    String routeName, {
    Object? arguments,
  }) {
    if (!_canExecute(id)) {
      debugPrint('⚠️ Side Effect [$id] تم تنفيذه من قبل');
      return;
    }

    _markAsExecuted(id);
    debugPrint('✅ تنفيذ Side Effect: $id');

    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// عرض Bottom Sheet مرة واحدة فقط
  /// 
  /// [context]: BuildContext الحالي
  /// [id]: معرّف فريد
  /// [builder]: Builder للـ Bottom Sheet
  Future<void> showBottomSheetOnce(
    BuildContext context,
    String id, {
    required Widget Function(BuildContext) builder,
  }) async {
    if (!_canExecute(id)) {
      debugPrint('⚠️ Side Effect [$id] تم تنفيذه من قبل');
      return;
    }

    _markAsExecuted(id);
    debugPrint('✅ تنفيذ Side Effect: $id');

    await showModalBottomSheet(
      context: context,
      builder: builder,
    );
  }

  /// تنفيذ أي Side Effect مخصص مرة واحدة فقط
  /// 
  /// [id]: معرّف فريد
  /// [effect]: الدالة المراد تنفيذها
  void executeOnce(String id, VoidCallback effect) {
    if (!_canExecute(id)) {
      debugPrint('⚠️ Side Effect [$id] تم تنفيذه من قبل');
      return;
    }

    _markAsExecuted(id);
    debugPrint('✅ تنفيذ Side Effect: $id');

    effect();
  }

  /// إعادة تفعيل Side Effect معين بحذف ID الخاص به
  /// 
  /// [id]: معرّف الـ Side Effect المراد إعادة تفعيله
  void reset(String id) {
    _executedEffects.remove(id);
    debugPrint('🔄 إعادة تفعيل Side Effect: $id');
  }

  /// إعادة تفعيل مجموعة من الـ Side Effects
  /// 
  /// [ids]: قائمة بمعرّفات الـ Side Effects
  void resetMultiple(List<String> ids) {
    for (final id in ids) {
      _executedEffects.remove(id);
    }
    debugPrint('🔄 إعادة تفعيل ${ids.length} Side Effects');
  }

  /// إعادة تفعيل جميع الـ Side Effects (حذف كل الـ IDs)
  void resetAll() {
    final count = _executedEffects.length;
    _executedEffects.clear();
    debugPrint('🔄 إعادة تفعيل جميع الـ Side Effects (تم حذف $count ID)');
  }

  /// التحقق من أن Side Effect معين تم تنفيذه
  /// 
  /// [id]: معرّف الـ Side Effect
  /// Returns: true إذا تم تنفيذه من قبل
  bool wasExecuted(String id) {
    return _executedEffects.contains(id);
  }

  /// الحصول على عدد الـ Side Effects التي تم تنفيذها
  int get executedCount => _executedEffects.length;

  /// الحصول على قائمة بجميع IDs الـ Side Effects التي تم تنفيذها
  Set<String> get executedEffects => Set.unmodifiable(_executedEffects);
}

