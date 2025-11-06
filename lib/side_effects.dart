/// Side Effects Manager Library
/// مكتبة إدارة Side Effects في Flutter
///
/// توفر هذه المكتبة نظام مركزي لإدارة جميع الـ Side Effects
/// مثل SnackBar، Dialog، Navigation، وغيرها بطريقة منع التكرار
library side_effects;

// Core Manager
export 'managers/side_effect_manager.dart';

// Constants
export 'constants/side_effect_ids.dart';

// Bloc (للمثال التوضيحي)
export 'bloc/counter_bloc.dart';
export 'bloc/counter_event.dart';
export 'bloc/counter_state.dart';

// Screens (للمثال التوضيحي)
export 'screens/counter_screen.dart';
export 'screens/details_screen.dart';

