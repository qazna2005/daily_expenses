
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'daily_expenses.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Bazani birinchi marta yaratish
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        server_id INTEGER,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        expense_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        sync_status INTEGER NOT NULL DEFAULT 0,
        is_deleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // Eski bazani yangi versiyaga o'tkazish
  Future<void> _onUpgrade(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE expenses
        ADD COLUMN is_deleted INTEGER NOT NULL DEFAULT 0
      ''');
    }
  }

  // Xarajat qo'shish
  Future<int> insertExpense(Map<String, dynamic> expense) async {
    final db = await database;

    return await db.insert(
      'expenses',
      expense,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // O'chirilmagan barcha xarajatlarni olish
  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await database;

    return await db.query(
      'expenses',
      where: 'is_deleted = ?',
      whereArgs: [0],
      orderBy: 'expense_date DESC',
    );
  }

  // ID orqali bitta xarajatni olish
  Future<Map<String, dynamic>?> getExpenseById(int id) async {
    final db = await database;

    final result = await db.query(
      'expenses',
      where: 'id = ? AND is_deleted = ?',
      whereArgs: [id, 0],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return result.first;
  }

  // Xarajatni tahrirlash
  Future<int> updateExpense(
      int id,
      Map<String, dynamic> expense,
      ) async {
    final db = await database;

    return await db.update(
      'expenses',
      {
        ...expense,
        'sync_status': 0,
        'is_deleted': 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Xarajatni o'chirish (soft delete)
  Future<int> deleteExpense(int id) async {
    final db = await database;

    return await db.update(
      'expenses',
      {
        'is_deleted': 1,
        'sync_status': 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Serverga yuborilmagan xarajatlarni olish
  // O'chirilgan xarajatlar ham sinxronlash uchun olinadi
  Future<List<Map<String, dynamic>>> getUnsyncedExpenses() async {
    final db = await database;

    return await db.query(
      'expenses',
      where: 'sync_status = ?',
      whereArgs: [0],
    );
  }

  // Xarajat server bilan sinxronlangan deb belgilash
  Future<int> markExpenseSynced(
      int id, {
        int? serverId,
      }) async {
    final db = await database;

    return await db.update(
      'expenses',
      {
        'sync_status': 1,
        if (serverId case final id?) 'server_id': id,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
