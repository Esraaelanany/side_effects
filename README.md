# 🎯 Side Effect Manager

مدير مركزي لإدارة جميع الـ Side Effects في تطبيقات Flutter بطريقة احترافية ومنع التكرار.

## ✨ المميزات

- ✅ **Singleton Pattern** - Instance واحدة في التطبيق بأكمله
- ✅ **One-Shot Pattern** - تنفيذ كل Side Effect مرة واحدة فقط
- ✅ **إدارة مركزية** - تحكم كامل في SnackBar، Dialog، Navigation، Bottom Sheet
- ✅ **منع التكرار** - لا مزيد من SnackBars المتكررة!
- ✅ **سهولة الاستخدام** - API بسيط وواضح
- ✅ **Best Practices** - متوافق مع Flutter و Bloc Best Practices
- ✅ **مختبر بالكامل** - 16 اختبار شامل (100% نجاح)
- ✅ **موثّق بالكامل** - توثيق عربي شامل مع أمثلة

## 🚀 البدء السريع

### التثبيت

```bash
flutter pub get
```

### الاستخدام الأساسي

```dart
import 'package:side_effects/side_effects.dart';

// في BlocListener أو BlocConsumer
BlocListener<LoginBloc, LoginState>(
  listener: (context, state) {
    if (state is LoginSuccess) {
      // عرض SnackBar مرة واحدة فقط
      SideEffectManager().showSnackOnce(
        context,
        SideEffectIds.loginSuccess,
        'تم تسجيل الدخول بنجاح',
        backgroundColor: Colors.green,
      );
      
      // الانتقال للصفحة الرئيسية (مرة واحدة)
      SideEffectManager().navigateAndRemoveUntilOnce(
        context,
        SideEffectIds.navigateToHome,
        '/home',
      );
    }
  },
  child: LoginForm(),
)
```

## 📚 التوثيق

- 📖 **[SIDE_EFFECT_MANAGER_GUIDE.md](SIDE_EFFECT_MANAGER_GUIDE.md)** - دليل شامل مع أمثلة عملية
- 📖 **[lib/managers/README.md](lib/managers/README.md)** - توثيق API كامل
- 📖 **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - ملخص المشروع

## 🎓 الأمثلة

### مثال 1: SnackBar

```dart
SideEffectManager().showSnackOnce(
  context,
  'success_message',
  'تمت العملية بنجاح!',
  backgroundColor: Colors.green,
  duration: const Duration(seconds: 3),
);
```

### مثال 2: Dialog

```dart
SideEffectManager().showDialogOnce(
  context,
  'error_dialog',
  title: 'خطأ',
  content: 'حدث خطأ ما، حاول مرة أخرى',
);
```

### مثال 3: Navigation

```dart
SideEffectManager().navigateOnce(
  context,
  'go_to_profile',
  '/profile',
  arguments: {'userId': 123},
);
```

### مثال 4: إعادة التفعيل

```dart
// إعادة تفعيل Side Effect واحد
SideEffectManager().reset('success_message');

// إعادة تفعيل عدة Side Effects
SideEffectManager().resetMultiple([
  'success_message',
  'error_dialog',
]);

// إعادة تفعيل الكل
SideEffectManager().resetAll();
```

## 🏗️ هيكل المشروع

```
lib/
├── managers/
│   ├── side_effect_manager.dart    # الكلاس الرئيسي
│   └── README.md                   # التوثيق
├── constants/
│   └── side_effect_ids.dart        # IDs مركزية
├── bloc/                           # مثال Bloc
├── screens/                        # شاشات المثال
├── main.dart                       # نقطة الدخول
└── side_effects.dart               # Exports

test/
└── side_effect_manager_test.dart   # 16 اختبار
```

## 🧪 تشغيل الاختبارات

```bash
flutter test
```

**النتيجة:** 16/16 اختبار نجح ✅

## 🎮 تشغيل التطبيق التجريبي

```bash
flutter run
```

سيعرض لك مثال تفاعلي يوضح كيفية استخدام SideEffectManager.

## 📊 الإحصائيات

- ✅ 16 اختبار (100% نجاح)
- ✅ 2000+ سطر كود
- ✅ 3 ملفات توثيق
- ✅ 14 ملف مصدري

## 💡 حالات الاستخدام

### متى تستخدم SideEffectManager؟

✅ عند استخدام Bloc Pattern  
✅ لمنع تكرار SnackBar/Dialog/Navigation  
✅ لإدارة مركزية للـ Side Effects  
✅ لتتبع Side Effects المنفذة  

### متى لا تستخدمه؟

❌ عندما تريد عرض نفس SnackBar عدة مرات  
❌ في ال builder (استخدمه فقط في listener)  
❌ للـ Side Effects البسيطة جداً  

## 🤝 المساهمة

هذا المشروع مفتوح المصدر. يمكنك:
- استخدامه في مشاريعك
- تعديله حسب احتياجاتك
- إضافة ميزات جديدة
- مشاركته مع الآخرين

## 📝 الترخيص

هذا المشروع مجاني للاستخدام الشخصي والتجاري.

## 🌟 الميزات القادمة (اختياري)

- ⭐ دعم Cupertino Dialogs
- ⭐ Timeout للـ Side Effects
- ⭐ Priority System
- ⭐ Firebase Analytics Integration
- ⭐ Persistent Storage

## 📞 الدعم والمساعدة

للأسئلة والاستفسارات:
- 📖 راجع [SIDE_EFFECT_MANAGER_GUIDE.md](SIDE_EFFECT_MANAGER_GUIDE.md)
- 🧪 شغّل الاختبارات: `flutter test`
- 🚀 شغّل المثال: `flutter run`

---

**صُنع بـ ❤️ لمطوري Flutter**

*النسخة: 1.0.0*
