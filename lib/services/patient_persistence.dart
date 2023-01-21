import 'package:sqflite/sqflite.dart';
import 'package:helpwave/services/database_handler.dart';
import 'package:helpwave/data_classes/patient_data.dart';

/// The PersistenceService for [PatientData]
///
/// Loads and Saves PatientData to a file on the users device
class PatientPersistenceService {
  /// Singleton static variable
  static final PatientPersistenceService _serviceSingleton = PatientPersistenceService._internal();

  /// The Id which will be the default patient id
  static const int patientId = 0;

  factory PatientPersistenceService() => _serviceSingleton;

  PatientPersistenceService._internal();

  Future<PatientData> load({int patientId = patientId}) async {
    try {
      // load data
      Database db = await DatabaseHandler().database;
      List<Map<String, Object?>> res = await db.query("Patient", where: "id  = ?", whereArgs: [patientId]);
      if (res.isEmpty) {
        return PatientData();
      }
      Map<String, Object?> patientMap = Map.of(res.first);
      List<Map<String, Object?>> allergies = await db.query("Allergy", where: "patientId  = ?", whereArgs: [patientId]);
      List<Map<String, Object?>> medications =
          await db.query("Medication", where: "patientId  = ?", whereArgs: [patientId]);

      // change data to fit map-format
      patientMap.putIfAbsent("allergies",
          () => Map<String, Object?>.fromEntries(allergies.map((e) => MapEntry(e["name"] as String, e["severity"]))));
      patientMap.putIfAbsent("medication",
          () => Map<String, Object?>.fromEntries(medications.map((e) => MapEntry(e["name"] as String, e["dosage"]))));
      patientMap.remove("id");
      if (patientMap["isOrganDonor"] != null) {
        patientMap.update(
          "isOrganDonor",
          (value) => patientMap["isOrganDonor"] == 1,
          ifAbsent: () => patientMap["isOrganDonor"] == 1,
        );
      }

      return PatientData.fromJson(patientMap);
    } catch (e) {
      return PatientData();
    }
  }

  Future<void> save(PatientData patientData) async {
    try {
      // prepare data
      Database db = await DatabaseHandler().database;
      Map<String, dynamic> patientMap = patientData.toJson();
      patientMap.putIfAbsent("id", () => patientId);
      Map<String, dynamic> medication = patientMap.remove("medication");
      Map<String, dynamic> allergies = patientMap.remove("allergies");

      // insert data into db
      await db.insert("Patient", patientMap, conflictAlgorithm: ConflictAlgorithm.replace);
      medication.forEach((key, value) async {
        await db.insert(
          "Medication",
          {"patientId": patientId, "name": key, "dosage": value},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
      allergies.forEach((key, value) async {
        await db.insert(
          "Allergy",
          {"patientId": patientId, "name": key, "severity": value},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (_) {}
  }
}
