import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/transaction.dart';
import '../../core/database_helper.dart';

import '../add_transaction/add_transaction_view.dart';

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
        child: ValueListenableBuilder<List<Transaction>>(
          valueListenable: transactionsNotifier,
          builder: (context, transactions, child) {
            
            // حساب الرصيد الإجمالي ديناميكياً
            double balance = 0;
            for (var tx in transactions) {
              if (tx.isIncome) {
                balance += tx.amount;
              } else {
                balance -= tx.amount;
              }
            }

            // ترتيب العمليات من الأحدث للأقدم
            final sortedTransactions = List<Transaction>.from(transactions)
              ..sort((a, b) => b.date.compareTo(a.date));

            return Padding(
              padding: const EdgeInsets.all(20.0),
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
                        Text('${balance.toStringAsFixed(2)} ر.س', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // 3. عنوان قائمة العمليات
                  Text('آخر العمليات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTextDark)),
                  SizedBox(height: 15),

                  // 4. قائمة العمليات (ListView)
                  Expanded(
                    child: sortedTransactions.isEmpty 
                      ? Center(child: Text('لا توجد عمليات مضافة بعد', style: TextStyle(color: kTextLight)))
                      : ListView.builder(
                      itemCount: sortedTransactions.length,
                      itemBuilder: (context, index) {
                        final tx = sortedTransactions[index];
                        return Dismissible(
                          key: Key(tx.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) async {
                            // 1. الحذف من قاعدة بيانات SQLite
                            await DatabaseHelper.instance.deleteTransaction(tx.id);

                            // 2. تحديث الواجهة (State)
                            final currentList = List<Transaction>.from(transactionsNotifier.value);
                            currentList.removeWhere((element) => element.id == tx.id);
                            transactionsNotifier.value = currentList;
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم حذف العملية بنجاح')),
                            );
                          },
                          child: Card(
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${tx.isIncome ? '+' : '-'} ${tx.amount}',
                                    style: TextStyle(
                                      color: tx.isIncome ? kIncome : kExpense,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  // زر التعديل (Edit)
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddTransactionView(transactionToEdit: tx),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.edit, color: Colors.blue, size: 20),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  // زر الحذف (Delete)
                                  InkWell(
                                    onTap: () async {
                                      // 1. الحذف من قاعدة بيانات SQLite
                                      await DatabaseHelper.instance.deleteTransaction(tx.id);

                                      // 2. تحديث الواجهة (State)
                                      final currentList = List<Transaction>.from(transactionsNotifier.value);
                                      currentList.removeWhere((element) => element.id == tx.id);
                                      transactionsNotifier.value = currentList;
                                      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('تم حذف العملية بنجاح')),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.delete, color: Colors.red, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
