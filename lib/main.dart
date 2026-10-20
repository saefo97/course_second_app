import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/onboarding/onboarding_view.dart';
import 'views/main_nav/main_nav_view.dart';
import 'models/transaction.dart';

void main() async {
  // التأكد من تهيئة بيئة Flutter قبل تنفيذ أي شيء غير متزامن
  WidgetsFlutterBinding.ensureInitialized();
  
  // استرجاع البيانات المحفوظة
  await loadTransactionsFromPrefs();

  // فحص هل المستخدم رأى شاشات الترحيب مسبقاً
  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

  runApp(MyWalletApp(seenOnboarding: seenOnboarding));
}

class MyWalletApp extends StatelessWidget {
  final bool seenOnboarding;

  const MyWalletApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'محفظتي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        fontFamily: 'Tahoma',
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      // إذا رأى المستخدم الشاشات ينتقل مباشرة للتطبيق، وإلا يبدأ بالترحيب
      home: seenOnboarding ? MainNavView() : OnboardingView(),
    );
  }
}
