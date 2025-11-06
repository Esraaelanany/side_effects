import 'package:equatable/equatable.dart';

/// Counter Events
/// الأحداث الخاصة بـ Counter Bloc
abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

/// حدث زيادة العداد
class IncrementEvent extends CounterEvent {
  const IncrementEvent();
}

/// حدث إنقاص العداد
class DecrementEvent extends CounterEvent {
  const DecrementEvent();
}

/// حدث إعادة تعيين العداد
class ResetEvent extends CounterEvent {
  const ResetEvent();
}

/// حدث الوصول لرقم معين
class ReachLimitEvent extends CounterEvent {
  final int limit;

  const ReachLimitEvent(this.limit);

  @override
  List<Object> get props => [limit];
}

