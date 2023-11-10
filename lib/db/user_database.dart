import 'package:foodsnap/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();

  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _close(Database db) async {
    await db.close();
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableUsers ( 
        ${UserFields.id} $idType,
        ${UserFields.username} $textType,
        ${UserFields.email} $textType,
        ${UserFields.password} $textType,
        ${UserFields.age} INTEGER NULL,
        ${UserFields.gender} TEXT NULL,
        ${UserFields.weight} INTEGER NULL,
        ${UserFields.height} INTEGER NULL,
        ${UserFields.watergoal} INTEGER NULL,
        ${UserFields.urlAvatar} TEXT NULL
      );
      ''');
  }

  Future<User?> registerUser(User user) async {
    final db = await instance.database;

    final id = await db.insert(tableUsers, user.toJson());
    return user.copy(id: id);
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await instance.database;

    final result = await db.query(
      tableUsers,
      where: '${UserFields.email} = ? AND ${UserFields.password} = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<User?> checkDuplicateUser(String username, String email) async {
    final db = await instance.database;

    final result = await db.query(
      tableUsers,
      where: '${UserFields.username} = ? OR ${UserFields.email} = ?',
      whereArgs: [username, email],
    );

    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<void> updateUser(User updatedUser) async {
    final db = await instance.database;

    await db.update(
      tableUsers,
      updatedUser.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [updatedUser.id],
    );
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await instance.database;

    final result = await db.query(
      tableUsers,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    } else {
      return null;
    }
  }
}
