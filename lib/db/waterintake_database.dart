import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:foodsnap/models/waterintake.dart';
import 'package:intl/intl.dart';

class WaterIntakeDatabase {
  static final WaterIntakeDatabase instance = WaterIntakeDatabase._init();

  static Database? _database;

  WaterIntakeDatabase._init();

  Future<void> deleteAllWaterIntake() async {
    final db = await instance.database;

    await db.delete(tableWaterIntake);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('waterintake.db');
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
      CREATE TABLE $tableWaterIntake ( 
        ${WaterIntakeFields.id} $idType,
        ${WaterIntakeFields.waterAmount} $integerType,
        ${WaterIntakeFields.time} $textType,
        ${WaterIntakeFields.editedTime} $textType,
        ${WaterIntakeFields.user} TEXT NULL
        )
      ''');
  }

  Future<WaterIntake> create(WaterIntake waterintake) async {
    final db = await instance.database;

    final id = await db.insert(tableWaterIntake, waterintake.toJson());
    return waterintake.copy(id: id);
  }

  Future<WaterIntake> readWaterIntake(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableWaterIntake,
      columns: WaterIntakeFields.values,
      where: '${WaterIntakeFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WaterIntake.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<WaterIntake>> readAllWaterIntake() async {
    final db = await instance.database;

    final orderBy = '${WaterIntakeFields.time} ASC';

    final result = await db.query(tableWaterIntake, orderBy: orderBy);

    return result.map((json) => WaterIntake.fromJson(json)).toList();
  }

  Future<int> update(WaterIntake waterintake) async {
    final db = await instance.database;

    final updatedWaterIntake = waterintake.copy(editedTime: DateTime.now());

    return db.update(
      tableWaterIntake,
      updatedWaterIntake.toJson(),
      where: '${WaterIntakeFields.id} = ?',
      whereArgs: [waterintake.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableWaterIntake,
      where: '${WaterIntakeFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllWaterIntakeForUser(String username) async {
    final db = await instance.database;

    await db.delete(
      tableWaterIntake,
      where: '${WaterIntakeFields.user} = ?',
      whereArgs: [username],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}