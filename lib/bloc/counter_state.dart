import 'package:equatable/equatable.dart';

/// Counter States
/// حالات الـ Counter Bloc - نظيفة وخالية من أي Side Effects
/// 
/// ملاحظة: تم إزالة جميع الـ messages والبيانات المتعلقة بـ Side Effects
/// State الآن يمثل الحالة فقط، بدون أي تأثيرات خارجية
abstract class CounterState extends Equatable {
  /// قيمة العداد الحالية
  final int count;

  const CounterState(this.count);

  @override
  List<Object> get props => [count];
}

/// الحالة الأولية
class CounterInitial extends CounterState {
  const CounterInitial() : super(0);
}

/// حالة التحديث العادية
/// 
/// يتم إصدار هذه الحالة عند أي تغيير في قيمة العداد
class CounterUpdated extends CounterState {
  const CounterUpdated(super.count);
}
