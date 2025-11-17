import 'package:flutter/material.dart';
import '../core/side_effect_base.dart';

/// Counter Side Effects
/// جميع الـ Side Effects الخاصة بـ Counter Bloc
/// 
/// Side Effects هي تأثيرات خارجية مثل عرض رسالة أو فتح Dialog
/// وهي منفصلة تماماً عن State

/// Side Effect عند الوصول للرقم 5
///
///
///

abstract class CounterSideEffect extends BaseSideEffect {}


class CounterReached5SideEffect extends CounterSideEffect {}

/// Side Effect عند محاولة الإنقاص تحت الصفر
class CounterBelowZeroErrorSideEffect extends CounterSideEffect {}

/// Side Effect عند الوصول للحد الأقصى (10)
class CounterReachedLimitSideEffect extends CounterSideEffect {
  final int limit;

  CounterReachedLimitSideEffect(this.limit);
}

/// Side Effect عند إعادة التعيين
class CounterResetSideEffect extends CounterSideEffect {}

/// Side Effect للانتقال لشاشة التفاصيل
class NavigateToDetailsSideEffect extends CounterSideEffect {
  final int count;
  NavigateToDetailsSideEffect(this.count);
}

/// Side Effect لعرض معلومات إضافية
class ShowCounterInfoSideEffect extends CounterSideEffect {
  final String message;
  final Color? color;

  ShowCounterInfoSideEffect({
    required this.message,
    this.color,
  });
}

