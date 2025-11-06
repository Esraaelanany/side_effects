import 'package:equatable/equatable.dart';

/// Counter States
/// حالات الـ Counter Bloc
abstract class CounterState extends Equatable {
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
class CounterUpdated extends CounterState {
  const CounterUpdated(super.count);
}

/// حالة النجاح (عند زيادة العداد)
class CounterSuccess extends CounterState {
  final String message;

  const CounterSuccess(super.count, this.message);

  @override
  List<Object> get props => [count, message];
}

/// حالة الخطأ (عند محاولة إنقاص تحت الصفر)
class CounterError extends CounterState {
  final String errorMessage;

  const CounterError(super.count, this.errorMessage);

  @override
  List<Object> get props => [count, errorMessage];
}

/// حالة الوصول للحد الأقصى
class CounterLimitReached extends CounterState {
  final String message;

  const CounterLimitReached(super.count, this.message);

  @override
  List<Object> get props => [count, message];
}

/// حالة إعادة التعيين
class CounterReset extends CounterState {
  final String message;

  const CounterReset() : message = 'تم إعادة تعيين العداد', super(0);

  @override
  List<Object> get props => [count, message];
}

