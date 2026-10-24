import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';
import '../models/transaction.dart';

class DatabaseHelper {
  // نمط Singleton لضمان وجود نسخة واحدة فقط من قاعدة البيانات
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('transactions.db');
    return _database!;
  }

  // إنشاء قاعدة البيانات
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // إنشاء جدول العمليات
  Future _createDB(Database db, int version) async {
    // ملاحظة: SQLite لا يدعم نوع Boolean مباشرة، ولكن يمكن تخزينه كـ INTEGER (0 للخطأ، 1 للصواب)
    // أو كـ TEXT ('true', 'false'). فلاتر/Sqflite تستطيع التعامل معه كـ INTEGER بسهولة.
    await db.execute('''
    CREATE TABLE transactions (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      isIncome INTEGER NOT NULL,
      date TEXT NOT NULL,
      icon INTEGER NOT NULL
    )
    ''');
  }

  // ----------------------------------------------------
  // وظائف قاعدة البيانات (CRUD Operations)
  // ----------------------------------------------------

  // 1. إضافة عملية جديدة
  Future<void> insertTransaction(Transaction transaction) async {
    final db = await instance.database;
    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 2. جلب جميع العمليات
  Future<List<Transaction>> getTransactions() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');

    if (maps.isNotEmpty) {
      return maps.map((map) => Transaction.fromMap(map)).toList();
    } else {
      return [];
    }
  }

  // 3. تحديث عملية (Update)
  Future<void> updateTransaction(Transaction transaction) async {
    final db = await instance.database;
    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // 4. حذف عملية (Delete)
  Future<void> deleteTransaction(String id) async {
    final db = await instance.database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}