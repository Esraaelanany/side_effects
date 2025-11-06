/// مثال تطبيقي على استخدام نظام Side Effects المنفصل
/// في feature تسجيل الدخول
/// 
/// هذا المثال للتوضيح فقط ولا يتم استخدامه في التطبيق
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../core/side_effect_base.dart';
import '../core/side_effect_listener.dart';

// ==================== Side Effects ====================

/// Side Effect عند نجاح تسجيل الدخول
class LoginSuccessSideEffect extends BaseSideEffect {
  const LoginSuccessSideEffect();
}

/// Side Effect عند فشل تسجيل الدخول
class LoginErrorSideEffect extends BaseSideEffect {
  final String errorMessage;
  const LoginErrorSideEffect(this.errorMessage);
}

/// Side Effect للانتقال للصفحة الرئيسية
class NavigateToHomeSideEffect extends BaseSideEffect {
  const NavigateToHomeSideEffect();
}

/// Side Effect لعرض رسالة "نسيت كلمة المرور"
class ForgotPasswordSideEffect extends BaseSideEffect {
  const ForgotPasswordSideEffect();
}

// ==================== States (نقية) ====================

/// States خالية من أي side effect data
abstract class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
}

// لاحظ: لا يوجد LoginError state مع error message
// الـ error يتم التعامل معه كـ side effect

// ==================== Events ====================

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  
  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;
  
  const LoginSubmitted(this.username, this.password);
  
  @override
  List<Object> get props => [username, password];
}

class ForgotPasswordPressed extends LoginEvent {
  const ForgotPasswordPressed();
}

// ==================== Bloc ====================

class LoginBloc extends SideEffectBloc<LoginEvent, LoginState, BaseSideEffect> {
  LoginBloc() : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<ForgotPasswordPressed>(_onForgotPasswordPressed);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // عرض loading
    emit(const LoginLoading());
    
    try {
      // محاكاة API call
      await Future.delayed(const Duration(seconds: 2));
      
      // تحقق من بيانات الدخول
      if (event.username == 'admin' && event.password == 'password') {
        // نجح تسجيل الدخول
        emit(const LoginSuccess());
        
        // إصدار side effects
        produceSideEffect(const LoginSuccessSideEffect());
        
        // الانتقال للصفحة الرئيسية بعد ثانية
        await Future.delayed(const Duration(seconds: 1));
        produceSideEffect(const NavigateToHomeSideEffect());
      } else {
        // فشل تسجيل الدخول
        emit(const LoginInitial()); // العودة للحالة الأولية
        
        // إصدار side effect للخطأ
        produceSideEffect(
          const LoginErrorSideEffect('اسم المستخدم أو كلمة المرور غير صحيحة'),
        );
      }
    } catch (e) {
      emit(const LoginInitial());
      produceSideEffect(LoginErrorSideEffect('حدث خطأ: ${e.toString()}'));
    }
  }

  void _onForgotPasswordPressed(
    ForgotPasswordPressed event,
    Emitter<LoginState> emit,
  ) {
    // لا تغيير في State
    // فقط side effect
    produceSideEffect(const ForgotPasswordSideEffect());
  }
}

// ==================== UI ====================

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول'),
      ),
      body: SideEffectBlocConsumer<LoginBloc, LoginState, BaseSideEffect>(
        // ==================== Side Effects Listener ====================
        listener: (context, sideEffect) {
          if (sideEffect is LoginSuccessSideEffect) {
            // عرض SnackBar نجاح
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('✅ تم تسجيل الدخول بنجاح!'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (sideEffect is LoginErrorSideEffect) {
            // عرض Dialog خطأ
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Text('خطأ'),
                  ],
                ),
                content: Text(sideEffect.errorMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('حسناً'),
                  ),
                ],
              ),
            );
          } else if (sideEffect is NavigateToHomeSideEffect) {
            // الانتقال للصفحة الرئيسية
            // Navigator.of(context).pushReplacementNamed('/home');
            
            // للتوضيح فقط
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🚀 الانتقال للصفحة الرئيسية...'),
                duration: Duration(seconds: 1),
              ),
            );
          } else if (sideEffect is ForgotPasswordSideEffect) {
            // عرض Bottom Sheet لنسيان كلمة المرور
            showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'نسيت كلمة المرور؟',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('سنرسل لك رابط إعادة تعيين كلمة المرور'),
                    const SizedBox(height: 20),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إرسال'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        
        // ==================== State Builder ====================
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // شعار
                const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
                const SizedBox(height: 30),
                
                // حقل اسم المستخدم
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المستخدم',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  enabled: state is! LoginLoading,
                ),
                const SizedBox(height: 16),
                
                // حقل كلمة المرور
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  enabled: state is! LoginLoading,
                ),
                const SizedBox(height: 8),
                
                // رابط نسيت كلمة المرور
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: state is LoginLoading
                        ? null
                        : () {
                            context
                                .read<LoginBloc>()
                                .add(const ForgotPasswordPressed());
                          },
                    child: const Text('نسيت كلمة المرور؟'),
                  ),
                ),
                const SizedBox(height: 20),
                
                // زر تسجيل الدخول
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: state is LoginLoading
                        ? null
                        : () {
                            final username = _usernameController.text;
                            final password = _passwordController.text;
                            
                            if (username.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('الرجاء إدخال جميع الحقول'),
                                ),
                              );
                              return;
                            }
                            
                            context.read<LoginBloc>().add(
                                  LoginSubmitted(username, password),
                                );
                          },
                    child: state is LoginLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('تسجيل الدخول'),
                  ),
                ),
                const SizedBox(height: 20),
                
                // تلميح
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'للتجربة:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('اسم المستخدم: admin'),
                        Text('كلمة المرور: password'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

