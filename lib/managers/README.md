# Side Effect Manager 🎯

مدير مركزي للتحكم في الـ Side Effects في تطبيقات Flutter باستخدام نمط Singleton.

## 📋 نظرة عامة

`SideEffectManager` هو كلاس يوفر طريقة منظمة لإدارة الـ Side Effects مثل:
- ✅ SnackBar
- ✅ Dialog
- ✅ Bottom Sheet
- ✅ Navigation
- ✅ أي Side Effect مخصص

## 🎯 المميزات الرئيسية

### 1. منع التكرار (One-Shot Pattern)
كل Side Effect يتم تنفيذه مرة واحدة فقط باستخدام ID فريد.

### 2. Singleton Pattern
Instance واحدة فقط في التطبيق بأكمله.

### 3. إعادة التفعيل
إمكانية إعادة تفعيل Side Effects معينة أو جميعها.

### 4. سهولة الاستخدام
API بسيط وواضح للاستخدام في أي مكان.

## 🚀 الاستخدام الأساسي

### 1. عرض SnackBar مرة واحدة

```dart
final sideEffectManager = SideEffectManager();

sideEffectManager.showSnackOnce(
  context,
  'login_success',           // ID فريد
  'تم تسجيل الدخول بنجاح',
  backgroundColor: Colors.green,
  duration: const Duration(seconds: 3),
);
```

### 2. عرض Dialog مرة واحدة

```dart
sideEffectManager.showDialogOnce(
  context,
  'error_network',           // ID فريد
  title: 'خطأ في الاتصال',
  content: 'تحقق من الاتصال بالإنترنت',
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('حسناً'),
    ),
  ],
);
```

### 3. Navigation مرة واحدة

```dart
// الانتقال لصفحة جديدة
sideEffectManager.navigateOnce(
  context,
  'go_to_home',
  '/home',
  arguments: {'userId': 123},
);

// الانتقال مع استبدال الصفحة الحالية
sideEffectManager.navigateAndReplaceOnce(
  context,
  'replace_with_dashboard',
  '/dashboard',
);

// الانتقال مع حذف كل الصفحات السابقة
sideEffectManager.navigateAndRemoveUntilOnce(
  context,
  'logout_to_login',
  '/login',
);
```

### 4. عرض Bottom Sheet مرة واحدة

```dart
sideEffectManager.showBottomSheetOnce(
  context,
  'welcome_sheet',
  builder: (context) => Container(
    padding: const EdgeInsets.all(20),
    child: const Text('مرحباً!'),
  ),
);
```

### 5. تنفيذ Side Effect مخصص

```dart
sideEffectManager.executeOnce(
  'custom_action',
  () {
    // أي كود تريد تنفيذه مرة واحدة فقط
    print('تم التنفيذ');
  },
);
```

## 🔄 إعادة التفعيل

### إعادة تفعيل Side Effect واحد

```dart
sideEffectManager.reset('login_success');
```

### إعادة تفعيل عدة Side Effects

```dart
sideEffectManager.resetMultiple([
  'login_success',
  'error_network',
  'welcome_sheet',
]);
```

### إعادة تفعيل الكل

```dart
sideEffectManager.resetAll();
```

## 🎓 الاستخدام مع BlocListener

### مثال كامل

```dart
BlocListener<LoginBloc, LoginState>(
  listener: (context, state) {
    final sideEffectManager = SideEffectManager();
    
    // عند النجاح
    if (state is LoginSuccess) {
      sideEffectManager.showSnackOnce(
        context,
        'login_success',
        'تم تسجيل الدخول بنجاح',
        backgroundColor: Colors.green,
      );
      
      sideEffectManager.navigateAndRemoveUntilOnce(
        context,
        'login_to_home',
        '/home',
      );
    }
    
    // عند الخطأ
    if (state is LoginError) {
      sideEffectManager.showDialogOnce(
        context,
        'login_error',
        title: 'خطأ',
        content: state.message,
      );
    }
  },
  child: YourWidget(),
)
```

### مع BlocConsumer

```dart
BlocConsumer<CounterBloc, CounterState>(
  listener: (context, state) {
    // جميع الـ Side Effects هنا
    if (state is CounterSuccess) {
      SideEffectManager().showSnackOnce(
        context,
        'counter_success',
        state.message,
        backgroundColor: Colors.green,
      );
    }
  },
  builder: (context, state) {
    // UI هنا فقط
    return YourWidget();
  },
)
```

## 📊 معلومات إضافية

### التحقق من التنفيذ

```dart
// هل تم تنفيذ Side Effect معين؟
bool wasExecuted = sideEffectManager.wasExecuted('login_success');

// عدد الـ Side Effects المنفذة
int count = sideEffectManager.executedCount;

// قائمة بجميع IDs المنفذة
Set<String> executed = sideEffectManager.executedEffects;
```

## 💡 نصائح الاستخدام

1. **استخدم IDs وصفية**: اختر أسماء واضحة للـ IDs مثل `'login_success'` بدلاً من `'s1'`

2. **أعد التفعيل عند الحاجة**: استخدم `reset()` عند إعادة تعيين الحالة

3. **استخدمه في الـ Listener**: ضع جميع الـ Side Effects في `listener` وليس في `builder`

4. **لا تكرر الـ IDs**: تأكد من أن كل Side Effect له ID فريد

## 🏗️ البنية الداخلية

```dart
class SideEffectManager {
  // Singleton Pattern
  static final SideEffectManager _instance = SideEffectManager._internal();
  factory SideEffectManager() => _instance;
  
  // تخزين IDs المنفذة
  final Set<String> _executedEffects = {};
  
  // منطق التحقق والتنفيذ
  bool _canExecute(String id) => !_executedEffects.contains(id);
  void _markAsExecuted(String id) => _executedEffects.add(id);
}
```

## 📝 ملاحظات

- ✅ متوافق مع Flutter Best Practices
- ✅ يدعم Material و Cupertino
- ✅ آمن للاستخدام في الـ Hot Reload
- ✅ لا يؤثر على منطق الـ Bloc

## 🤝 المساهمة

إذا كان لديك اقتراحات أو تحسينات، لا تتردد في المساهمة!

---

Made with ❤️ for Flutter Developers

