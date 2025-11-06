import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/side_effect_base.dart';
import 'counter_event.dart';
import 'counter_state.dart';
import 'counter_side_effect.dart';

/// Counter Bloc مع دعم Side Effects منفصلة
/// 
/// يدير حالة العداد ويصدر Side Effects منفصلة عن الـ State
/// 
/// الفصل التام بين:
/// - State: يمثل قيمة العداد فقط (نقية، قابلة للاختبار بسهولة)
/// - Side Effects: التأثيرات الخارجية (SnackBar، Dialog، Navigation)
/// 
/// فوائد هذا النمط:
/// 1. State نقي ولا يحتوي على أي منطق UI
/// 2. Side Effects لا تتكرر عند rebuild
/// 3. أسهل في الاختبار
/// 4. فصل واضح بين المسؤوليات
class CounterBloc extends SideEffectBloc<CounterEvent, CounterState, BaseSideEffect> {
  CounterBloc() : super(const CounterInitial()) {
    on<IncrementEvent>(_onIncrement);
    on<DecrementEvent>(_onDecrement);
    on<ResetEvent>(_onReset);
  }

  /// معالج حدث الزيادة
  void _onIncrement(IncrementEvent event, Emitter<CounterState> emit) {
    final newCount = state.count + 1;

    // تحديث الـ State (فقط القيمة)
    emit(CounterUpdated(newCount));

    // إصدار Side Effects حسب القيمة
    if (newCount == 5) {
      // عند الوصول للرقم 5، نصدر side effect لإظهار رسالة نجاح
      produceSideEffect(const CounterReached5SideEffect());
    } else if (newCount == 10) {
      // عند الوصول للحد الأقصى، نصدر side effect لإظهار dialog وsnackbar
      produceSideEffect(const CounterReachedLimitSideEffect(10));
    }
  }

  /// معالج حدث الإنقاص
  void _onDecrement(DecrementEvent event, Emitter<CounterState> emit) {
    final currentCount = state.count;

    // منع الإنقاص تحت الصفر
    if (currentCount <= 0) {
      // إصدار side effect للخطأ فقط، بدون تغيير الـ State
      produceSideEffect(const CounterBelowZeroErrorSideEffect());
      return;
    }

    // تحديث الـ State
    emit(CounterUpdated(currentCount - 1));
  }

  /// معالج حدث إعادة التعيين
  void _onReset(ResetEvent event, Emitter<CounterState> emit) {
    // إعادة تعيين الـ State
    emit(const CounterInitial());

    // إصدار side effect لإظهار رسالة إعادة التعيين
    produceSideEffect(const CounterResetSideEffect());
  }
}
