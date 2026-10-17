import 'package:flutter/material.dart';
import 'views/onboarding/onboarding_view.dart';

void main() {
  runApp(const MyWalletApp());
}

class MyWalletApp extends StatelessWidget {
  const MyWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'محفظتي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        fontFamily: 'Tahoma', // يمكنك تغيير الخط ليناسب اللغة العربية بشكل أفضل
      ),
      // هذا السطر يجعل واجهة التطبيق كاملة من اليمين لليسار (عربي)
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: OnboardingView(), // البداية من شاشة الترحيب
    );
  }
}
