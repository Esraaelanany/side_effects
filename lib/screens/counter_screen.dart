import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_event.dart';
import '../bloc/counter_state.dart';
import '../bloc/counter_side_effect.dart';
import '../core/side_effect_base.dart';
import '../core/side_effect_listener.dart';
import 'details_screen.dart';

/// Counter Screen مع نظام Side Effects المنفصل
/// 
/// يستخدم SideEffectBlocConsumer للجمع بين:
/// - BlocBuilder لبناء UI بناءً على State
/// - SideEffectBlocListener للاستماع وتنفيذ Side Effects
class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Side Effects - BLoC Pattern'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'حول المشروع',
            onPressed: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
      body: SideEffectBlocConsumer<CounterBloc, CounterState, CounterSideEffect>(
        // ==================== Side Effects Listener ====================
        // يتم تنفيذ Side Effects هنا فقط، منفصلة تماماً عن State
        listener: (context, sideEffect) {
          // معالجة Side Effects المختلفة
          if (sideEffect is CounterReached5SideEffect) {
            // عند الوصول للرقم 5، عرض SnackBar نجاح
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.celebration, color: Colors.white),
                    SizedBox(width: 8),
                    Text('🎉 رائع! وصلت للرقم 5'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          } else if (sideEffect is CounterBelowZeroErrorSideEffect) {
            // عند محاولة الإنقاص تحت الصفر، عرض Dialog خطأ
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
                content: const Text('لا يمكن الإنقاص تحت الصفر!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('حسناً'),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else if (sideEffect is CounterReachedLimitSideEffect) {
            // عند الوصول للحد الأقصى (10)
            
            // 1. عرض SnackBar تحذير
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text('⚠️ تحذير: وصلت للحد الأقصى 10!'),
                    ),
                  ],
                ),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );

            // 2. عرض Dialog للتهنئة والانتقال
            Future.delayed(const Duration(milliseconds: 300), () {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Row(
                      children: [
                        Icon(Icons.celebration, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('🎊 تهانينا!'),
                      ],
                    ),
                    content: const Text(
                      'وصلت للحد الأقصى!\nهل تريد الانتقال لشاشة التفاصيل؟',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('لاحقاً'),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          // الانتقال لشاشة التفاصيل
                          final count = context.read<CounterBloc>().state.count;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsScreen(count: count),
                            ),
                          );
                        },
                        child: const Text('انتقل'),
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            });
          } else if (sideEffect is CounterResetSideEffect) {
            // عند إعادة التعيين، عرض SnackBar معلومات
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.white),
                    SizedBox(width: 8),
                    Text('🔄 تم إعادة تعيين العداد'),
                  ],
                ),
                backgroundColor: Colors.blue,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },

        // ==================== State Builder ====================
        // بناء UI بناءً على State فقط
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // أيقونة تعبيرية حسب العداد
                  _buildCounterIcon(state.count),
                  const SizedBox(height: 20),

                  // عرض العداد
                  const Text(
                    'قيمة العداد:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${state.count}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getCounterColor(state.count),
                        ),
                  ),
                  const SizedBox(height: 40),

                  // معلومات حسب الحالة
                  _buildStateInfo(state),

                  const SizedBox(height: 40),

                  // الأزرار
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // زر الإنقاص
                      FloatingActionButton(
                        heroTag: 'decrement',
                        onPressed: () {
                          context.read<CounterBloc>().add(const DecrementEvent());
                        },
                        tooltip: 'إنقاص',
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 20),

                      // زر إعادة التعيين
                      FloatingActionButton(
                        heroTag: 'reset',
                        onPressed: () {
                          context.read<CounterBloc>().add(const ResetEvent());
                        },
                        backgroundColor: Colors.red,
                        tooltip: 'إعادة تعيين',
                        child: const Icon(Icons.refresh),
                      ),
                      const SizedBox(width: 20),

                      // زر الزيادة
                      FloatingActionButton(
                        heroTag: 'increment',
                        onPressed: () {
                          context.read<CounterBloc>().add(const IncrementEvent());
                        },
                        tooltip: 'زيادة',
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // زر الانتقال للشاشة التالية
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(count: state.count),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('عرض التفاصيل'),
                  ),

                  const SizedBox(height: 20),

                  // معلومات عن النظام
                  _buildInfoCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// بناء أيقونة حسب قيمة العداد
  Widget _buildCounterIcon(int count) {
    if (count == 0) {
      return const Icon(Icons.sentiment_neutral, size: 80, color: Colors.grey);
    } else if (count < 5) {
      return const Icon(Icons.sentiment_satisfied, size: 80, color: Colors.blue);
    } else if (count < 10) {
      return const Icon(Icons.sentiment_very_satisfied, size: 80, color: Colors.green);
    } else {
      return const Icon(Icons.celebration, size: 80, color: Colors.orange);
    }
  }

  /// الحصول على لون حسب قيمة العداد
  Color _getCounterColor(int count) {
    if (count == 0) return Colors.grey;
    if (count < 5) return Colors.blue;
    if (count < 10) return Colors.green;
    return Colors.orange;
  }

  /// بناء معلومات حسب الحالة
  Widget _buildStateInfo(CounterState state) {
    String info = '';
    Color color = Colors.black;
    IconData icon = Icons.info;

    if (state.count == 0) {
      info = 'ابدأ بزيادة العداد!';
      color = Colors.grey;
      icon = Icons.play_arrow;
    } else if (state.count == 5) {
      info = 'نقطة منتصف الطريق!';
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (state.count == 10) {
      info = 'الحد الأقصى!';
      color = Colors.orange;
      icon = Icons.warning;
    } else if (state.count < 5) {
      info = 'استمر... ${5 - state.count} للوصول للرقم 5';
      color = Colors.blue;
      icon = Icons.trending_up;
    } else if (state.count < 10) {
      info = 'قريب من الحد الأقصى... ${10 - state.count} متبقي';
      color = Colors.orange.shade300;
      icon = Icons.trending_up;
    }

    if (info.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(102), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            info,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء بطاقة معلومات
  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '✨ نظام Side Effects المنفصل',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'جرّب الزيادة للرقم 5 أو 10\nلرؤية Side Effects منفصلة تماماً عن State',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildFeatureRow(Icons.check, 'State نقي (فقط الأرقام)'),
            const SizedBox(height: 4),
            _buildFeatureRow(Icons.check, 'Side Effects منفصلة تماماً'),
            const SizedBox(height: 4),
            _buildFeatureRow(Icons.check, 'لا تكرار للـ Side Effects'),
            const SizedBox(height: 4),
            _buildFeatureRow(Icons.check, 'سهل الاختبار والصيانة'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.green),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎯 حول المشروع'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'نظام Side Effects المنفصل في Flutter BLoC',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('✅ State نقي يمثل الحالة فقط'),
              SizedBox(height: 4),
              Text('✅ Side Effects منفصلة (SnackBar, Dialog, Navigation)'),
              SizedBox(height: 4),
              Text('✅ عدم تكرار Side Effects عند rebuild'),
              SizedBox(height: 4),
              Text('✅ سهولة الاختبار والصيانة'),
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 8),
              Text(
                'البنية:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• BaseSideEffect - الأساس'),
              Text('• SideEffectBloc - Bloc مع stream منفصل'),
              Text('• SideEffectBlocListener - Listener للـ UI'),
              Text('• CounterSideEffect - Side effects محددة'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('رائع!'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
