import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'dart:io';

class RxProDbHelper {
  // Private constructor
  RxProDbHelper._privateConstructor();
  static final RxProDbHelper instance = RxProDbHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the application documents directory
    final documentsDirectory = await getApplicationDocumentsDirectory();
    // Construct the path to the database file
    final path = join(documentsDirectory.path, 'rx_pro_database.db');

    // Open the database
    final File dbFile = File(path);
    final db = sqlite3.open(dbFile.path);
    // final db = sqlite3.openInMemory();

    // get sql file creating tables of the database
    final String initialDB =
        await rootBundle.loadString('assets/init_database.sql');
    db.execute(initialDB);

    return db;
  }

  Future<void> addPatient({
    required String firstName,
    required String middleName,
    required String lastName,
    required DateTime birthDate,
    required int sex,
    String? mobile,
  }) async {
    _database!.execute(
      '''
    INSERT INTO patient(first_name, middle_name, last_name, birthdate, sex, mobile) VALUES (?, ?, ?, ?, ?, ?)
    ''',
      [firstName, middleName, lastName, birthDate.toString(), sex, mobile],
    );
  }

  Future<List<Map<String, dynamic>>> getItems({
    required String tableName,
    int? limit,
  }) async {
    final ResultSet result = _database!.select(
      'SELECT * FROM $tableName${limit != null ? ' LIMIT $limit' : ''}',
    );
    return result.map((row) => row).toList();
  }
}
