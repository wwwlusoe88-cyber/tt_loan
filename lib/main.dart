import 'package:flutter/material.dart';
import 'login/login_screen.dart';
import 'global/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tt_loan',
      debugShowCheckedModeBanner: false,
      // Global Theme များ ချိတ်ဆက်ခြင်း
      theme: AppThemes.defaultTheme,
      darkTheme: AppThemes.modernHighlightTheme,
      themeMode: ThemeMode.system, // ဖုန်း၏ System Theme အလိုက် အလိုအလျောက် ပြောင်းလဲမည်
      home: const LoginScreen(),
    );
  }
}
