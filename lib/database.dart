import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'dart:io';

import 'package:rxpro_app/patient.dart';

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

  Future<void> addPatient(Patient patient) async {
    _database!.execute(
      '''
      INSERT INTO patient(first_name, middle_name, last_name, birthdate, sex, 
      addr, contact, er_name, er_rel, er_addr, er_contact) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        patient.firstName,
        patient.middleName,
        patient.lastName,
        patient.birthDate.toString(),
        patient.sex,
        patient.address,
        patient.contact,
        patient.erName,
        patient.erRelation,
        patient.erAddress,
        patient.erContact,
      ],
    );
  }

  Future<List<Map<String, dynamic>>> select(
    String query, {
    List params = const [],
  }) async {
    final ResultSet result = _database!.select(query, params);
    return result.map((row) => {...row}).toList();
  }

  Future<List<Map<String, dynamic>>> getItems({
    required String tableName,
    int? limit,
    String? condition,
    bool? ascendingOrder,
    List<String> columnOrder = const [],
    List<String> columns = const [],
    List conditionParams = const [],
  }) async {
    String orderClause = '';
    if (columnOrder.isNotEmpty) {
      orderClause =
          ' ORDER BY ${columnOrder.join(', ')} ${(ascendingOrder == null) ? '' : ascendingOrder ? 'ASC' : 'DSC'}';
    }

    String whereClause = (condition == null) ? '' : ' WHERE $condition';
    String limitClause = (limit == null) ? '' : ' LIMIT $limit';

    final ResultSet result = _database!.select(
      '''
      SELECT ${columns.isEmpty ? '*' : columns.join(', ')} 
      FROM $tableName$whereClause$orderClause$limitClause
      ''',
      conditionParams,
    );

    return result.map((row) => {...row}).toList();
  }

  Future<int?> getNextIncrement(String tableName) async {
    final ResultSet result = _database!.select('SELECT last_insert_rowid()');

    if (result.isNotEmpty) {
      return result.first.values[0] as int;
    } else {
      return null;
    }
  }
}
