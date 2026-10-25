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

  // تحويل البيانات لـ Map لحفظها في SQLite
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'amount': amount,
    'isIncome': isIncome ? 1 : 0, // نحوله إلى 1 أو 0 لأن SQLite يخزنه كأرقام صحيحة
    'date': date.toIso8601String(),
    'icon': icon.codePoint, // نحفظ الرمز الخاص بالأيقونة كـ Integer
  };

  // استرجاع البيانات من Map من SQLite
  factory Transaction.fromMap(Map<String, dynamic> map) => Transaction(
    id: map['id'],
    title: map['title'],
    amount: map['amount'],
    isIncome: map['isIncome'] == 1, // نرجعه إلى bool (إذا كان 1 فهو true، وإلا false)
    date: DateTime.parse(map['date']),
    icon: _getIconFromCodePoint(map['icon']),
  );

  static IconData _getIconFromCodePoint(int codePoint) {
    if (codePoint == Icons.attach_money.codePoint) return Icons.attach_money;
    if (codePoint == Icons.shopping_bag.codePoint) return Icons.shopping_bag;
    return Icons.attach_money; // أيقونة افتراضية في حال عدم العثور عليها
  }
}

// مدير الحالة للواجهات
final ValueNotifier<List<Transaction>> transactionsNotifier = ValueNotifier([]);
