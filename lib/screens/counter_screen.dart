import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_event.dart';
import '../bloc/counter_state.dart';
import '../managers/side_effect_manager.dart';
import '../constants/side_effect_ids.dart';
import 'details_screen.dart';

/// Counter Screen
/// شاشة العداد التي تستخدم SideEffectManager لإدارة الـ Side Effects
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
    final sideEffectManager = SideEffectManager();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Side Effect Manager Demo'),
        actions: [
          // زر إعادة تعيين جميع الـ Side Effects
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة تعيين Side Effects',
            onPressed: () {
              sideEffectManager.resetAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إعادة تعيين جميع Side Effects'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CounterBloc, CounterState>(
        // Listener للـ Side Effects فقط
        listener: (context, state) {
          // استخدام SideEffectManager لإدارة الـ Side Effects

          // عند نجاح الوصول للرقم 5
          if (state is CounterSuccess) {
            sideEffectManager.showSnackOnce(
              context,
              SideEffectIds.counterSuccess5,
              state.message,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            );
          }

          // عند وجود خطأ
          if (state is CounterError) {
            sideEffectManager.showDialogOnce(
              context,
              SideEffectIds.counterErrorNegative,
              title: 'خطأ',
              content: state.errorMessage,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('حسناً'),
                ),
              ],
            );
          }

          // عند الوصول للحد الأقصى (10)
          if (state is CounterLimitReached && state.count == 10) {
            // عرض Dialog
            sideEffectManager.showDialogOnce(
              context,
              SideEffectIds.counterLimitReached10,
              title: '🎊 تهانينا!',
              content: 'وصلت للحد الأقصى! هل تريد الانتقال لشاشة التفاصيل؟',
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('لاحقاً'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // الانتقال لشاشة التفاصيل
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(count: state.count),
                      ),
                    );
                  },
                  child: const Text('انتقل'),
                ),
              ],
            );

            // عرض SnackBar أيضاً
            sideEffectManager.showSnackOnce(
              context,
              SideEffectIds.counterLimitSnack10,
              state.message,
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            );
          }

          // عند إعادة التعيين
          if (state is CounterReset) {
            sideEffectManager.showSnackOnce(
              context,
              SideEffectIds.counterReset,
              state.message,
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 2),
            );

            // إعادة تعيين Side Effects معينة باستخدام الـ utility method
            sideEffectManager.resetMultiple(
              SideEffectIds.getCounterScreenIds(),
            );
          }
        },
        // Builder لبناء الـ UI فقط
        builder: (context, state) {
          return Center(
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
                const SizedBox(height: 30),

                // معلومات إضافية حسب الحالة
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

                // معلومات عن الـ Side Effects المنفذة
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Side Effects المنفذة: ${sideEffectManager.executedCount}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'جرّب الزيادة للرقم 5 أو 10 لرؤية Side Effects',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
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

  /// بناء معلومات إضافية حسب الحالة
  Widget _buildStateInfo(CounterState state) {
    String info = '';
    Color color = Colors.black;

    if (state is CounterSuccess) {
      info = '✅ ${state.message}';
      color = Colors.green;
    } else if (state is CounterError) {
      info = '❌ ${state.errorMessage}';
      color = Colors.red;
    } else if (state is CounterLimitReached) {
      info = '⚠️ ${state.message}';
      color = Colors.orange;
    } else if (state is CounterReset) {
      info = '🔄 ${state.message}';
      color = Colors.blue;
    }

    if (info.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        info,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

