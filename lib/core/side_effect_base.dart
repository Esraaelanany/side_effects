import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Base class لجميع Side Effects في التطبيق
/// 
/// Side Effect هو أي تأثير خارجي لا يجب أن يكون جزءاً من State
/// مثل: عرض SnackBar، فتح Dialog، الانتقال بين الشاشات، إلخ
/// 
/// فوائد فصل Side Effects عن State:
/// 1. State يصبح أنقى ويمثل الحالة فقط
/// 2. Side Effects لا تتكرر عند rebuild
/// 3. أسهل في الاختبار
/// 4. فصل واضح بين منطق الحالة ومنطق التفاعل
abstract class BaseSideEffect {
  const BaseSideEffect();
}

/// Base Bloc يدعم إصدار Side Effects منفصلة عن State
/// 
/// يوفر stream إضافي للـ side effects منفصل تماماً عن state stream
/// 
/// استخدام:
/// ```dart
/// class MyBloc extends SideEffectBloc<MyEvent, MyState, MySideEffect> {
///   MyBloc() : super(InitialState());
///   
///   void someMethod() {
///     emit(NewState()); // للـ state
///     produceSideEffect(ShowSnackBarEffect()); // للـ side effect
///   }
/// }
/// ```
abstract class SideEffectBloc<Event, State, SideEffect extends BaseSideEffect>
    extends Bloc<Event, State> {
  /// Controller للـ side effects stream
  final _sideEffectController = StreamController<SideEffect>.broadcast();

  /// Constructor
  SideEffectBloc(super.initialState);

  /// Stream للاستماع للـ side effects
  /// 
  /// يتم الاستماع له في UI عبر SideEffectBlocListener
  Stream<SideEffect> get sideEffectStream => _sideEffectController.stream;

  /// إصدار side effect جديد
  /// 
  /// يتم استدعاء هذه الدالة من داخل event handlers
  /// لإرسال side effect للـ UI
  /// 
  /// [sideEffect]: الـ side effect المراد إصداره
  void produceSideEffect(SideEffect sideEffect) {
    if (!_sideEffectController.isClosed) {
      _sideEffectController.add(sideEffect);
    }
  }

  @override
  Future<void> close() {
    _sideEffectController.close();
    return super.close();
  }
}

