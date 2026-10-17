import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/transaction.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('محفظتي', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: kTextDark),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: CircleAvatar(
              backgroundColor: kPrimary.withOpacity(0.2),
              child: Icon(Icons.person, color: kPrimary),
            ),
          )
        ],
      ),
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. الترحيب
              Text('مرحباً بك 👋', style: TextStyle(fontSize: 18, color: kTextLight)),
              Text('محفظتك اليوم', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kTextDark)),
              SizedBox(height: 20),
              
              // 2. بطاقة الرصيد (Balance Card)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [kPrimary, Colors.blueAccent]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: kPrimary.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الرصيد الإجمالي', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    SizedBox(height: 10),
                    Text('4,625 ر.س', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // 3. عنوان قائمة العمليات
              Text('آخر العمليات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTextDark)),
              SizedBox(height: 15),

              // 4. قائمة العمليات (ListView)
              Expanded(
                child: ListView.builder(
                  itemCount: dummyTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = dummyTransactions[index];
                    return Card(
                      color: Colors.white,
                      elevation: 0,
                      margin: EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: tx.isIncome ? kIncome.withOpacity(0.2) : kExpense.withOpacity(0.2),
                          child: Icon(tx.icon, color: tx.isIncome ? kIncome : kExpense),
                        ),
                        title: Text(tx.title, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${tx.date.day}/${tx.date.month}/${tx.date.year}'),
                        trailing: Text(
                          '${tx.isIncome ? '+' : '-'} ${tx.amount}',
                          style: TextStyle(
                            color: tx.isIncome ? kIncome : kExpense,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
