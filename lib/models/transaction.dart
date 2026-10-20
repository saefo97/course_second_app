import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // تحويل البيانات لـ JSON لحفظها
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'isIncome': isIncome,
    'date': date.toIso8601String(),
    'icon': icon.codePoint, // نحفظ الرمز الخاص بالأيقونة
  };

  // استرجاع البيانات من JSON
  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    title: json['title'],
    amount: json['amount'],
    isIncome: json['isIncome'],
    date: DateTime.parse(json['date']),
    icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
  );
}

// مدير الحالة
final ValueNotifier<List<Transaction>> transactionsNotifier = ValueNotifier([]);

// وظيفة حفظ البيانات
Future<void> saveTransactionsToPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final String encodedData = jsonEncode(transactionsNotifier.value.map((e) => e.toJson()).toList());
  await prefs.setString('transactions_data', encodedData);
}

// وظيفة استرجاع البيانات
Future<void> loadTransactionsFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final String? encodedData = prefs.getString('transactions_data');
  if (encodedData != null) {
    final List<dynamic> decodedData = jsonDecode(encodedData);
    final List<Transaction> loaded = decodedData.map((e) => Transaction.fromJson(e)).toList();
    transactionsNotifier.value = loaded;
  } else {
    // إذا لم يكن هناك بيانات محفوظة، نضع بيانات وهمية للتجربة
    transactionsNotifier.value = [
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
  }
}
