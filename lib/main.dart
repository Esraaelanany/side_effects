import 'package:flutter/material.dart';
import 'screens/counter_screen.dart';

/// Side Effect Manager Demo
/// مثال عملي يوضح استخدام SideEffectManager لإدارة الـ Side Effects
/// مثل SnackBar و Dialog و Navigation بطريقة مركزية ومنع التكرار
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Side Effect Manager Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      // الشاشة الرئيسية
      home: const CounterScreen(),
    );
  }
}
