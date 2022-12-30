import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:helpwave/data_classes/PatientData.dart';

/// The PersistenceService for [PatientData]
class PatientPersistenceService {
  static final PatientPersistenceService _serviceSingleton =
      PatientPersistenceService._internal();
  final String _filename = "patientData.json";

  factory PatientPersistenceService() => _serviceSingleton;

  PatientPersistenceService._internal();

  Future<PatientData> load() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$_filename');
    try {
      final contents = await file.readAsString();
      return PatientData.fromJson(jsonDecode(contents));
    } catch (e) {
      return PatientData();
    }
  }

  Future<void> save(PatientData patientData) async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$_filename');
    file.writeAsString(patientData.serialize());
  }
}
