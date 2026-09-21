import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tt_loan_secure.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        // SQLite တွင် Foreign Key ထိန်းချုပ်မှု အလုပ်လုပ်စေရန်
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Users Table (Local Auth & Freemium/Expiry Control)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        pin TEXT NOT NULL,
        is_premium INTEGER NOT NULL DEFAULT 0,
        expiry_date TEXT,
        updated_at TEXT NOT NULL
      )
    ''');

    // 2. Borrowers Table (Scoped by user_phone to prevent data mixing)
    await db.execute('''
      CREATE TABLE borrowers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_phone TEXT NOT NULL,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_phone) REFERENCES users (phone) ON DELETE CASCADE
      )
    ''');

    // 3. Loans Table (Scoped by user_phone and linked to borrower)
    await db.execute('''
      CREATE TABLE loans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_phone TEXT NOT NULL,
        borrower_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        interest_rate REAL NOT NULL,
        term_months INTEGER NOT NULL,
        start_date TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (user_phone) REFERENCES users (phone) ON DELETE CASCADE,
        FOREIGN KEY (borrower_id) REFERENCES borrowers (id) ON DELETE CASCADE
      )
    ''');

    // 4. Repayments Table (Linked to loan and user_phone)
    await db.execute('''
      CREATE TABLE repayments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_phone TEXT NOT NULL,
        loan_id INTEGER NOT NULL,
        paid_amount REAL NOT NULL,
        paid_date TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (user_phone) REFERENCES users (phone) ON DELETE CASCADE,
        FOREIGN KEY (loan_id) REFERENCES loans (id) ON DELETE CASCADE
      )
    ''');
  }

  // ==================== USER OPERATIONS ====================
  
  Future<int> upsertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(
      'users',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    final db = await instance.database;
    final results = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [phone],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // ==================== BORROWER OPERATIONS ====================
  
  Future<int> insertBorrower(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('borrowers', row);
  }

  Future<List<Map<String, dynamic>>> getBorrowersByUser(String userPhone) async {
    final db = await instance.database;
    return await db.query(
      'borrowers',
      where: 'user_phone = ?',
      whereArgs: [userPhone],
      orderBy: 'id DESC',
    );
  }

  // ==================== LOAN OPERATIONS ====================
  
  Future<int> insertLoan(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('loans', row);
  }

  Future<List<Map<String, dynamic>>> getLoansByUser(String userPhone) async {
    final db = await instance.database;
    return await db.query(
      'loans',
      where: 'user_phone = ?',
      whereArgs: [userPhone],
      orderBy: 'id DESC',
    );
  }

  // ==================== REPAYMENT OPERATIONS ====================
  
  Future<int> insertRepayment(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('repayments', row);
  }

  Future<List<Map<String, dynamic>>> getRepaymentsByLoan(int loanId, String userPhone) async {
    final db = await instance.database;
    return await db.query(
      'repayments',
      where: 'loan_id = ? AND user_phone = ?',
      whereArgs: [loanId, userPhone],
      orderBy: 'id DESC',
    );
  }

  // Database Connection Close
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
