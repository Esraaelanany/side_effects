import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'side_effect_base.dart';

/// Widget للاستماع للـ Side Effects الصادرة من SideEffectBloc
/// 
/// يعمل بشكل مشابه لـ BlocListener لكن للـ side effects فقط
/// لا يُعيد بناء الـ UI، فقط يستمع وينفذ Side Effects
/// 
/// مثال:
/// ```dart
/// SideEffectBlocListener<MyBloc, MyState, MySideEffect>(
///   listener: (context, sideEffect) {
///     if (sideEffect is ShowSnackBarEffect) {
///       ScaffoldMessenger.of(context).showSnackBar(
///         SnackBar(content: Text(sideEffect.message)),
///       );
///     }
///   },
///   child: MyWidget(),
/// )
/// ```
class SideEffectBlocListener<
    B extends SideEffectBloc<dynamic, S, SE>,
    S,
    SE extends BaseSideEffect> extends StatefulWidget {
  /// الـ child widget
  final Widget child;

  /// Callback يتم استدعاؤه عند إصدار side effect جديد
  final void Function(BuildContext context, SE sideEffect) listener;

  /// Bloc اختياري، إذا لم يتم تحديده سيتم استخدام context.read
  final B? bloc;

  const SideEffectBlocListener({
    super.key,
    required this.listener,
    required this.child,
    this.bloc,
  });

  @override
  State<SideEffectBlocListener<B, S, SE>> createState() =>
      _SideEffectBlocListenerState<B, S, SE>();
}

class _SideEffectBlocListenerState<
    B extends SideEffectBloc<dynamic, S, SE>,
    S,
    SE extends BaseSideEffect> extends State<SideEffectBlocListener<B, S, SE>> {
  StreamSubscription<SE>? _subscription;
  late B _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _subscribe();
  }

  @override
  void didUpdateWidget(SideEffectBlocListener<B, S, SE> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? _bloc;
    final currentBloc = widget.bloc ?? _bloc;
    
    if (oldBloc != currentBloc) {
      _unsubscribe();
      _bloc = currentBloc;
      _subscribe();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscription = _bloc.sideEffectStream.listen((sideEffect) {
      if (mounted) {
        widget.listener(context, sideEffect);
      }
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Widget مركّب يجمع بين BlocBuilder و SideEffectBlocListener
/// 
/// يُستخدم عندما تحتاج لبناء UI بناءً على State
/// والاستماع للـ Side Effects في نفس الوقت
/// 
/// مثال:
/// ```dart
/// SideEffectBlocConsumer<MyBloc, MyState, MySideEffect>(
///   listener: (context, sideEffect) {
///     // معالجة side effects
///   },
///   builder: (context, state) {
///     // بناء UI
///     return MyWidget();
///   },
/// )
/// ```
class SideEffectBlocConsumer<
    B extends SideEffectBloc<dynamic, S, SE>,
    S,
    SE extends BaseSideEffect> extends StatelessWidget {
  /// Callback للاستماع للـ side effects
  final void Function(BuildContext context, SE sideEffect) listener;

  /// Builder لبناء UI بناءً على State
  final Widget Function(BuildContext context, S state) builder;

  /// Bloc اختياري
  final B? bloc;

  /// شرط اختياري لتصفية متى يتم rebuild
  final bool Function(S previous, S current)? buildWhen;

  const SideEffectBlocConsumer({
    super.key,
    required this.listener,
    required this.builder,
    this.bloc,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return SideEffectBlocListener<B, S, SE>(
      bloc: bloc,
      listener: listener,
      child: BlocBuilder<B, S>(
        bloc: bloc,
        buildWhen: buildWhen,
        builder: builder,
      ),
    );
  }
}

