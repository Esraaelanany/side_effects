import 'package:flutter/material.dart';
import '../core/side_effect_base.dart';

/// Counter Side Effects
/// جميع الـ Side Effects الخاصة بـ Counter Bloc
/// 
/// Side Effects هي تأثيرات خارجية مثل عرض رسالة أو فتح Dialog
/// وهي منفصلة تماماً عن State

/// Side Effect عند الوصول للرقم 5
class CounterReached5SideEffect extends BaseSideEffect {
  const CounterReached5SideEffect();
}

/// Side Effect عند محاولة الإنقاص تحت الصفر
class CounterBelowZeroErrorSideEffect extends BaseSideEffect {
  const CounterBelowZeroErrorSideEffect();
}

/// Side Effect عند الوصول للحد الأقصى (10)
class CounterReachedLimitSideEffect extends BaseSideEffect {
  final int limit;

  const CounterReachedLimitSideEffect(this.limit);
}

/// Side Effect عند إعادة التعيين
class CounterResetSideEffect extends BaseSideEffect {
  const CounterResetSideEffect();
}

/// Side Effect للانتقال لشاشة التفاصيل
class NavigateToDetailsSideEffect extends BaseSideEffect {
  final int count;

  const NavigateToDetailsSideEffect(this.count);
}

/// Side Effect لعرض معلومات إضافية
class ShowCounterInfoSideEffect extends BaseSideEffect {
  final String message;
  final Color? color;

  const ShowCounterInfoSideEffect({
    required this.message,
    this.color,
  });
}

