import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final bool isIncome; // true = دخل, false = مصروف
  final DateTime date;
  final IconData icon;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.icon,
  });
}

// بيانات وهمية للتجربة (Dummy Data)
List<Transaction> dummyTransactions = [
  Transaction(
    id: '1', title: 'راتب شهري', amount: 5000, isIncome: true, 
    date: DateTime.now(), icon: Icons.attach_money,
  ),
  Transaction(
    id: '2', title: 'سوبر ماركت', amount: 350, isIncome: false, 
    date: DateTime.now().subtract(Duration(days: 1)), icon: Icons.shopping_cart,
  ),
  Transaction(
    id: '3', title: 'قهوة', amount: 25, isIncome: false, 
    date: DateTime.now().subtract(Duration(days: 2)), icon: Icons.local_cafe,
  ),
];
