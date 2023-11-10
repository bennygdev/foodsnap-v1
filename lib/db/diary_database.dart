import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:foodsnap/models/diary.dart';
import 'package:foodsnap/models/user.dart';
import 'package:intl/intl.dart';
import 'package:foodsnap/dummydata/diary_dummy_data.dart';

class DiaryDatabase {
  static final DiaryDatabase instance = DiaryDatabase._init();

  static Database? _database;

  DiaryDatabase._init();

  Future<void> deleteAllDiary() async {
    final db = await instance.database;

    await db.delete(tableDiary);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('diary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tableDiary ( 
        ${DiaryFields.id} $idType,
        ${DiaryFields.title} $textType,
        ${DiaryFields.comment} $textType,
        ${DiaryFields.calorie} $integerType,
        ${DiaryFields.imagePath} TEXT NULL,
        ${DiaryFields.time} $textType,
        ${DiaryFields.editedTime} $textType,
        ${DiaryFields.user} TEXT NULL
        )
      ''');

    await _insertDummyData(db, dummyDiaries);
  }

  Future<void> _insertDummyData(Database db, List<Diary> dummyDiaries) async {
    final batch = db.batch();

    for (final diary in dummyDiaries) {
      batch.insert(tableDiary, diary.toJson());
    }

    await batch.commit();
  }

  Future<Diary> create(Diary diary) async {
    final db = await instance.database;

    final id = await db.insert(tableDiary, diary.toJson());
    return diary.copy(id: id);
  }

  Future<Diary> readDiary(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableDiary,
      columns: DiaryFields.values,
      where: '${DiaryFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Diary.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Diary>> readAllDiary() async {
    final db = await instance.database;

    final orderBy = '${DiaryFields.time} ASC';

    final result = await db.query(tableDiary, orderBy: orderBy);

    return result.map((json) => Diary.fromJson(json)).toList();
  }

  Future<int> update(Diary diary) async {
    final db = await instance.database;

    final updatedDiary = diary.copy(editedTime: DateTime.now());

    return db.update(
      tableDiary,
      updatedDiary.toJson(),
      where: '${DiaryFields.id} = ?',
      whereArgs: [diary.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableDiary,
      where: '${DiaryFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllDiaryForUser(String username) async {
    final db = await instance.database;

    await db.delete(
      tableDiary,
      where: '${DiaryFields.user} = ?',
      whereArgs: [username],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}