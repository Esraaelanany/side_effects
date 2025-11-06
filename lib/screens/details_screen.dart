import 'package:flutter/material.dart';
import '../managers/side_effect_manager.dart';
import '../constants/side_effect_ids.dart';

/// Details Screen
/// شاشة تفاصيل توضح استخدام SideEffectManager في شاشة ثانية
class DetailsScreen extends StatelessWidget {
  final int count;

  const DetailsScreen({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final sideEffectManager = SideEffectManager();

    // عرض SnackBar عند الدخول للشاشة (مرة واحدة فقط)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sideEffectManager.showSnackOnce(
        context,
        SideEffectIds.detailsScreenWelcome,
        'مرحباً بك في شاشة التفاصيل!',
        backgroundColor: Colors.purple,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('شاشة التفاصيل'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة
              const Icon(
                Icons.info_outline,
                size: 100,
                color: Colors.purple,
              ),
              const SizedBox(height: 30),

              // عنوان
              const Text(
                'تفاصيل العداد',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // عرض القيمة
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'القيمة الحالية:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // معلومات عن الـ Side Effects
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'إحصائيات Side Effect Manager:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'عدد الـ Side Effects المنفذة: ${sideEffectManager.executedCount}',
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'تم عرض رسالة الترحيب مرة واحدة فقط',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // أزرار تجريبية
              ElevatedButton.icon(
                onPressed: () {
                  sideEffectManager.showDialogOnce(
                    context,
                    SideEffectIds.detailsInfoDialog,
                    title: 'معلومات',
                    content: 'هذا Dialog سيظهر مرة واحدة فقط!\nحتى لو ضغطت الزر مجدداً.',
                  );
                },
                icon: const Icon(Icons.info),
                label: const Text('عرض Dialog (مرة واحدة)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: () {
                  sideEffectManager.showBottomSheetOnce(
                    context,
                    SideEffectIds.detailsBottomSheet,
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(20),
                      height: 200,
                      child: Column(
                        children: [
                          const Text(
                            'Bottom Sheet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'هذا Bottom Sheet سيظهر مرة واحدة فقط!',
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('إغلاق'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.playlist_add),
                label: const Text('عرض Bottom Sheet (مرة واحدة)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              // زر الرجوع
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('رجوع'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

