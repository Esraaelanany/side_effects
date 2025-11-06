/// Side Effect IDs Constants
/// ملف مركزي لتخزين جميع IDs الخاصة بـ Side Effects
/// 
/// فوائد استخدام ملف Constants:
/// 1. تجنب الأخطاء الإملائية
/// 2. سهولة البحث والتعديل
/// 3. Auto-complete في IDE
/// 4. إعادة الاستخدام في عدة أماكن
/// 5. التوثيق المركزي

class SideEffectIds {
  // منع إنشاء instance من الكلاس
  SideEffectIds._();

  // ==================== Counter Screen ====================
  
  /// عند نجاح الوصول للرقم 5
  static const String counterSuccess5 = 'counter_success_5';
  
  /// عند محاولة الإنقاص تحت الصفر
  static const String counterErrorNegative = 'counter_error_negative';
  
  /// Dialog عند الوصول للحد الأقصى 10
  static const String counterLimitReached10 = 'counter_limit_reached_10';
  
  /// SnackBar عند الوصول للحد الأقصى 10
  static const String counterLimitSnack10 = 'counter_limit_snack_10';
  
  /// عند إعادة تعيين العداد
  static const String counterReset = 'counter_reset';

  // ==================== Details Screen ====================
  
  /// رسالة ترحيب عند الدخول لشاشة التفاصيل
  static const String detailsScreenWelcome = 'details_screen_welcome';
  
  /// Dialog معلومات في شاشة التفاصيل
  static const String detailsInfoDialog = 'details_info_dialog';
  
  /// Bottom Sheet في شاشة التفاصيل
  static const String detailsBottomSheet = 'details_bottom_sheet';

  // ==================== Login (مثال) ====================
  
  /// عند نجاح تسجيل الدخول
  static const String loginSuccess = 'login_success';
  
  /// عند فشل تسجيل الدخول
  static const String loginError = 'login_error';
  
  /// الانتقال للصفحة الرئيسية بعد تسجيل الدخول
  static const String navigateToHome = 'navigate_to_home';

  // ==================== Cart (مثال) ====================
  
  /// عند إضافة منتج للسلة
  /// استخدم مع suffix: itemAdded('product_id')
  static String itemAdded(String productId) => 'item_added_$productId';
  
  /// عند الوصول للحد الأقصى من المنتجات
  static const String cartLimitWarning = 'cart_limit_warning';
  
  /// عند إتمام الطلب
  static const String orderCompleted = 'order_completed';

  // ==================== Network (مثال) ====================
  
  /// عند فقدان الاتصال بالإنترنت
  static const String noInternetConnection = 'no_internet_connection';
  
  /// عند استعادة الاتصال
  static const String internetRestored = 'internet_restored';

  // ==================== Notifications (مثال) ====================
  
  /// طلب صلاحية الإشعارات
  static const String requestNotificationPermission = 'request_notification_permission';
  
  /// عند رفض صلاحية الإشعارات
  static const String notificationPermissionDenied = 'notification_permission_denied';

  // ==================== Utility Methods ====================
  
  /// إنشاء ID فريد بناءً على معرّف ديناميكي
  /// مفيد للعناصر المتعددة مثل: قائمة المنتجات، قائمة المستخدمين، إلخ
  static String withId(String prefix, String id) => '${prefix}_$id';
  
  /// إنشاء ID فريد بناءً على timestamp
  /// مفيد للـ Side Effects التي يجب أن تظهر في كل مرة ولكن مع تتبع
  static String withTimestamp(String prefix) => '${prefix}_${DateTime.now().millisecondsSinceEpoch}';
  
  /// قائمة بجميع IDs الخاصة بشاشة معينة
  static List<String> getCounterScreenIds() => [
    counterSuccess5,
    counterErrorNegative,
    counterLimitReached10,
    counterLimitSnack10,
    counterReset,
  ];
  
  /// قائمة بجميع IDs الخاصة بشاشة التفاصيل
  static List<String> getDetailsScreenIds() => [
    detailsScreenWelcome,
    detailsInfoDialog,
    detailsBottomSheet,
  ];
  
  /// قائمة بجميع IDs الخاصة بعملية تسجيل الدخول
  static List<String> getLoginIds() => [
    loginSuccess,
    loginError,
    navigateToHome,
  ];
}

/// أمثلة على الاستخدام:
/// 
/// ```dart
/// // بدلاً من:
/// SideEffectManager().showSnackOnce(context, 'login_success', 'نجح!');
/// 
/// // استخدم:
/// SideEffectManager().showSnackOnce(
///   context, 
///   SideEffectIds.loginSuccess, 
///   'نجح!',
/// );
/// 
/// // للعناصر الديناميكية:
/// SideEffectManager().showSnackOnce(
///   context,
///   SideEffectIds.itemAdded(product.id),
///   'تمت الإضافة',
/// );
/// 
/// // إعادة تفعيل مجموعة:
/// SideEffectManager().resetMultiple(SideEffectIds.getLoginIds());
/// ```

