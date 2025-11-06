import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

/// Counter Bloc
/// يدير حالة العداد ويصدر Side Effects عند الحاجة
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<IncrementEvent>(_onIncrement);
    on<DecrementEvent>(_onDecrement);
    on<ResetEvent>(_onReset);
    on<ReachLimitEvent>(_onReachLimit);
  }

  /// معالج حدث الزيادة
  void _onIncrement(IncrementEvent event, Emitter<CounterState> emit) {
    final newCount = state.count + 1;

    // عند الوصول للرقم 5، نصدر حالة خاصة
    if (newCount == 5) {
      emit(CounterSuccess(newCount, 'رائع! وصلت للرقم 5 🎉'));
    }
    // عند الوصول للرقم 10، نصدر حالة حد أقصى
    else if (newCount == 10) {
      emit(CounterLimitReached(newCount, 'تحذير: وصلت للحد الأقصى 10!'));
    } else {
      emit(CounterUpdated(newCount));
    }
  }

  /// معالج حدث الإنقاص
  void _onDecrement(DecrementEvent event, Emitter<CounterState> emit) {
    final currentCount = state.count;

    // منع الإنقاص تحت الصفر
    if (currentCount <= 0) {
      emit(CounterError(currentCount, 'لا يمكن الإنقاص تحت الصفر!'));
    } else {
      emit(CounterUpdated(currentCount - 1));
    }
  }

  /// معالج حدث إعادة التعيين
  void _onReset(ResetEvent event, Emitter<CounterState> emit) {
    emit(const CounterReset());
  }

  /// معالج حدث الوصول لحد معين
  void _onReachLimit(ReachLimitEvent event, Emitter<CounterState> emit) {
    emit(CounterLimitReached(event.limit, 'وصلت للحد ${event.limit}'));
  }
}

