import 'package:flutter/cupertino.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/services/patient_svc.dart';
import 'package:tasks/util/search_helpers.dart';

/// The Controller for managing [Patient]s in a Ward
class PatientsController extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState state = LoadingState.initializing;

  /// The [Patient]s mapped by the [PatientsByAssignmentStatus]
  PatientsByAssignmentStatus patientsByAssignmentStatus = PatientsByAssignmentStatus();

  /// The current search text
  String searchedText = "";

  /// The selected PatientStatus
  String selectedPatientStatus = "all";

  PatientsController(){
    load();
  }

  // TODO add a field for errors

  /// A [List] of all loaded [Patients]
  List<Patient> get all => [
        ...patientsByAssignmentStatus.active,
        ...patientsByAssignmentStatus.unassigned,
        ...patientsByAssignmentStatus.discharged,
      ];

  /// Filtered by Search
  List<Patient> get filtered => multiSearchWithMapping(
        searchedText,
        all,
        (patient) {
          List<String> searchTags = [patient.name];
          if (patient.bed != null) {
            searchTags.add(patient.bed!.name);
          }
          if (patient.room != null) {
            searchTags.add(patient.room!.name);
          }
          return searchTags;
        },
      );

  /// Loads the [patients]
  Future<void> load() async {
    state = LoadingState.loading;
    notifyListeners();

    patientsByAssignmentStatus = await PatientService().getPatientList();
    state = LoadingState.loaded;
    notifyListeners();
  }

  /// Discharges the patient the [patients]
  Future<void> discharge(String patientId) async {
    state = LoadingState.loading;
    notifyListeners();
    await PatientService().dischargePatient(patientId: patientId);
    state = LoadingState.loaded;
    notifyListeners();
  }
}
