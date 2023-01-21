import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Singleton for Providing the Database
class DatabaseHandler {
  /// The database
  Database? _database;

  /// The current version of the db change when updating
  final int _version = 1;

  /// The file name which represents the database on the device
  final String _dbName = "database.db";

  static final DatabaseHandler _databaseHandler = DatabaseHandler._internal();

  DatabaseHandler._internal();

  factory DatabaseHandler() => _databaseHandler;

  Future<Database> get database async {
    if (_database == null) {
      await initDatabase();
    }
    return _database!;
  }

  initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: _version,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE Patient('
            'id INTEGER PRIMARY KEY,'
            'name TEXT, language TEXT,'
            'birthDate TEXT,'
            'isOrganDonor BOOLEAN,'
            'weight TEXT, height TEXT,'
            'bloodType TEXT,'
            'rhesusFactor TEXT);');
        await db.execute('CREATE TABLE Allergy('
            'patientId INTEGER,'
            'name TEXT,'
            'severity TEXT,'
            'FOREIGN KEY(patientId) REFERENCES Patient(id),'
            'PRIMARY KEY (patientId, name));');
        await db.execute('CREATE TABLE Medication('
            'patientId INTEGER,'
            'name TEXT,'
            'dosage TEXT,'
            'FOREIGN KEY(patientId) REFERENCES Patient(id),'
            'PRIMARY KEY (patientId, name));');
      },
    );
  }
}
