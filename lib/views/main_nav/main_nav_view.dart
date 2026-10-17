import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../home/home_view.dart';
import '../stats/stats_view.dart';
import '../add_transaction/add_transaction_view.dart';

class MainNavView extends StatefulWidget {
  @override
  _MainNavViewState createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  int _currentIndex = 0;

  // الشاشات التي سيتم التبديل بينها
  final List<Widget> _screens = [HomeView(), StatsView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // عرض الشاشة حسب الفهرس الحالي
      // الزر العائم في المنتصف (لإضافة عملية)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionView()),
          );
        },
        backgroundColor: kPrimary,
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // شريط التنقل السفلي
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0 ? kPrimary : Colors.grey,
              ),
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            SizedBox(width: 40), // مساحة للزر العائم في المنتصف
            IconButton(
              icon: Icon(
                Icons.pie_chart,
                color: _currentIndex == 1 ? kPrimary : Colors.grey,
              ),
              onPressed: () => setState(() => _currentIndex = 1),
            ),
          ],
        ),
      ),
    );
  }
}
