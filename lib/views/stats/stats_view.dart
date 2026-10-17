import 'package:flutter/material.dart';
import '../../core/constants.dart';

class StatsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart, size: 100, color: kPrimary.withOpacity(0.5)),
            SizedBox(height: 20),
            Text('شاشة الإحصائيات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('سيتم إضافة الرسوم البيانية هنا في الدرس القادم', style: TextStyle(color: kTextLight)),
          ],
        ),
      ),
    );
  }
}
