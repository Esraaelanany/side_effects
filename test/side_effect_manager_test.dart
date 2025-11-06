import 'package:flutter_test/flutter_test.dart';
import 'package:side_effects/managers/side_effect_manager.dart';

/// Unit Tests for SideEffectManager
/// اختبارات وحدة لـ SideEffectManager
void main() {
  group('SideEffectManager Tests', () {
    late SideEffectManager manager;

    setUp(() {
      // الحصول على الـ instance وإعادة تعيينها قبل كل اختبار
      manager = SideEffectManager();
      manager.resetAll();
    });

    test('should be a singleton', () {
      // التحقق من أن كل instance هي نفسها
      final manager1 = SideEffectManager();
      final manager2 = SideEffectManager();

      expect(manager1, equals(manager2));
      expect(identical(manager1, manager2), true);
    });

    test('should track executed side effects', () {
      // قبل التنفيذ
      expect(manager.wasExecuted('test_effect'), false);
      expect(manager.executedCount, 0);

      // تنفيذ Side Effect
      manager.executeOnce('test_effect', () {});

      // بعد التنفيذ
      expect(manager.wasExecuted('test_effect'), true);
      expect(manager.executedCount, 1);
      expect(manager.executedEffects.contains('test_effect'), true);
    });

    test('should prevent duplicate execution', () {
      int executionCount = 0;

      // المحاولة الأولى - يجب أن تنفذ
      manager.executeOnce('prevent_duplicate', () {
        executionCount++;
      });
      expect(executionCount, 1);

      // المحاولة الثانية - لا يجب أن تنفذ
      manager.executeOnce('prevent_duplicate', () {
        executionCount++;
      });
      expect(executionCount, 1); // لم يتغير

      // المحاولة الثالثة - لا يجب أن تنفذ
      manager.executeOnce('prevent_duplicate', () {
        executionCount++;
      });
      expect(executionCount, 1); // لا يزال 1
    });

    test('should allow different IDs to execute', () {
      int count1 = 0;
      int count2 = 0;
      int count3 = 0;

      // تنفيذ عدة Side Effects بـ IDs مختلفة
      manager.executeOnce('effect_1', () => count1++);
      manager.executeOnce('effect_2', () => count2++);
      manager.executeOnce('effect_3', () => count3++);

      expect(count1, 1);
      expect(count2, 1);
      expect(count3, 1);
      expect(manager.executedCount, 3);
    });

    test('should reset single side effect', () {
      // تنفيذ
      manager.executeOnce('reset_test', () {});
      expect(manager.wasExecuted('reset_test'), true);

      // إعادة تعيين
      manager.reset('reset_test');
      expect(manager.wasExecuted('reset_test'), false);

      // يمكن التنفيذ مرة أخرى
      int executionCount = 0;
      manager.executeOnce('reset_test', () => executionCount++);
      expect(executionCount, 1);
    });

    test('should reset multiple side effects', () {
      // تنفيذ عدة Side Effects
      manager.executeOnce('multi_1', () {});
      manager.executeOnce('multi_2', () {});
      manager.executeOnce('multi_3', () {});
      manager.executeOnce('keep_this', () {});

      expect(manager.executedCount, 4);

      // إعادة تعيين بعضها فقط
      manager.resetMultiple(['multi_1', 'multi_2', 'multi_3']);

      expect(manager.wasExecuted('multi_1'), false);
      expect(manager.wasExecuted('multi_2'), false);
      expect(manager.wasExecuted('multi_3'), false);
      expect(manager.wasExecuted('keep_this'), true);
      expect(manager.executedCount, 1);
    });

    test('should reset all side effects', () {
      // تنفيذ عدة Side Effects
      manager.executeOnce('all_1', () {});
      manager.executeOnce('all_2', () {});
      manager.executeOnce('all_3', () {});
      manager.executeOnce('all_4', () {});
      manager.executeOnce('all_5', () {});

      expect(manager.executedCount, 5);

      // إعادة تعيين الكل
      manager.resetAll();

      expect(manager.executedCount, 0);
      expect(manager.wasExecuted('all_1'), false);
      expect(manager.wasExecuted('all_2'), false);
      expect(manager.wasExecuted('all_3'), false);
      expect(manager.wasExecuted('all_4'), false);
      expect(manager.wasExecuted('all_5'), false);
    });

    test('should return unmodifiable set of executed effects', () {
      manager.executeOnce('readonly_1', () {});
      manager.executeOnce('readonly_2', () {});

      final executedSet = manager.executedEffects;

      // التحقق من المحتوى
      expect(executedSet.length, 2);
      expect(executedSet.contains('readonly_1'), true);
      expect(executedSet.contains('readonly_2'), true);

      // التحقق من أنه unmodifiable
      expect(
        () => executedSet.add('should_fail'),
        throwsUnsupportedError,
      );
    });

    test('should handle empty ID gracefully', () {
      // يجب أن يعمل حتى مع string فارغ
      manager.executeOnce('', () {});
      expect(manager.wasExecuted(''), true);

      // لا يجب أن ينفذ مرة أخرى
      int count = 0;
      manager.executeOnce('', () => count++);
      expect(count, 0);
    });

    test('should maintain state across multiple operations', () {
      // سيناريو معقد يحاكي الاستخدام الحقيقي
      
      // تسجيل الدخول
      manager.executeOnce('login_success', () {});
      expect(manager.executedCount, 1);

      // إضافة منتجات للسلة
      manager.executeOnce('item_added_1', () {});
      manager.executeOnce('item_added_2', () {});
      manager.executeOnce('item_added_3', () {});
      expect(manager.executedCount, 4);

      // إتمام الطلب
      manager.executeOnce('order_completed', () {});
      expect(manager.executedCount, 5);

      // إعادة تعيين Side Effects السلة فقط
      manager.resetMultiple(['item_added_1', 'item_added_2', 'item_added_3']);
      expect(manager.executedCount, 2);

      // تسجيل الخروج - إعادة تعيين الكل
      manager.resetAll();
      expect(manager.executedCount, 0);
    });

    test('should handle rapid successive calls', () {
      int executionCount = 0;

      // محاكاة استدعاءات سريعة متتالية (مثل builds متعددة)
      for (int i = 0; i < 100; i++) {
        manager.executeOnce('rapid_call', () => executionCount++);
      }

      // يجب أن ينفذ مرة واحدة فقط
      expect(executionCount, 1);
    });

    test('should handle multiple managers (singleton test)', () {
      // إنشاء عدة "instances"
      final manager1 = SideEffectManager();
      final manager2 = SideEffectManager();
      final manager3 = SideEffectManager();

      // التنفيذ من أول instance
      manager1.executeOnce('singleton_test', () {});

      // التحقق من أن جميع الـ instances تشير لنفس البيانات
      expect(manager2.wasExecuted('singleton_test'), true);
      expect(manager3.wasExecuted('singleton_test'), true);
      expect(manager1.executedCount, 1);
      expect(manager2.executedCount, 1);
      expect(manager3.executedCount, 1);

      // إعادة التعيين من instance آخر
      manager2.reset('singleton_test');

      // التحقق من أن التغيير يظهر في الكل
      expect(manager1.wasExecuted('singleton_test'), false);
      expect(manager3.wasExecuted('singleton_test'), false);
    });

    test('should handle special characters in IDs', () {
      // IDs مع رموز خاصة
      final specialIds = [
        'test-with-dash',
        'test_with_underscore',
        'test.with.dot',
        'test:with:colon',
        'test/with/slash',
        'test@with@at',
        'test#with#hash',
        'test with spaces',
        'تست_بالعربي',
        '测试中文',
        '🎯_with_emoji',
      ];

      // يجب أن تعمل جميع الأنواع
      for (final id in specialIds) {
        manager.executeOnce(id, () {});
        expect(manager.wasExecuted(id), true);
      }

      expect(manager.executedCount, specialIds.length);
    });

    test('should handle concurrent IDs patterns', () {
      // محاكاة pattern شائع: ID مع معرّف ديناميكي
      final userId = '123';
      final productId = '456';

      manager.executeOnce('user_login_$userId', () {});
      manager.executeOnce('product_view_$productId', () {});

      expect(manager.wasExecuted('user_login_123'), true);
      expect(manager.wasExecuted('product_view_456'), true);
      expect(manager.wasExecuted('user_login_999'), false);
      expect(manager.wasExecuted('product_view_999'), false);
    });
  });

  group('SideEffectManager Scalability Tests', () {
    test('should handle large number of IDs', () {
      final manager = SideEffectManager();
      manager.resetAll();

      // إنشاء 100 Side Effect
      for (int i = 0; i < 100; i++) {
        manager.executeOnce('effect_$i', () {});
      }

      expect(manager.executedCount, 100);

      // التحقق من بعض IDs
      expect(manager.wasExecuted('effect_0'), true);
      expect(manager.wasExecuted('effect_50'), true);
      expect(manager.wasExecuted('effect_99'), true);
      expect(manager.wasExecuted('effect_100'), false);
    });

    test('should handle batch operations efficiently', () {
      final manager = SideEffectManager();
      manager.resetAll();

      // إضافة 50 ID
      for (int i = 0; i < 50; i++) {
        manager.executeOnce('batch_$i', () {});
      }

      expect(manager.executedCount, 50);

      // إعادة تعيين نصفهم
      final idsToReset = List.generate(25, (i) => 'batch_$i');
      manager.resetMultiple(idsToReset);

      expect(manager.executedCount, 25);

      // التحقق
      expect(manager.wasExecuted('batch_0'), false);
      expect(manager.wasExecuted('batch_24'), false);
      expect(manager.wasExecuted('batch_25'), true);
      expect(manager.wasExecuted('batch_49'), true);
    });
  });
}

