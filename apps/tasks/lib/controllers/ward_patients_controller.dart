import 'package:flutter/cupertino.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/services/current_ward_svc.dart';
import 'package:tasks/services/patient_svc.dart';
import 'package:tasks/util/search_helpers.dart';

/// The Controller for managing [Patient]s in a Ward
class WardPatientsController extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState state = LoadingState.initializing;

  /// The [Patient]s mapped by the [PatientsByAssignmentStatus]
  PatientsByAssignmentStatus _patientsByAssignmentStatus = PatientsByAssignmentStatus();

  PatientsByAssignmentStatus get patientsByAssignmentStatus => _patientsByAssignmentStatus;

  set patientsByAssignmentStatus(PatientsByAssignmentStatus value) {
    _patientsByAssignmentStatus = value;
    notifyListeners();
  }

  /// The current search text
  String _searchedText = "";

  String get searchedText => _searchedText;

  set searchedText(String value) {
    _searchedText = value;
    notifyListeners();
  }

  /// The selected PatientStatus
  PatientAssignmentStatus? selectedPatientStatus;

  WardPatientsController() {
    load();
  }

  // TODO add a field for errors

  /// A [List] of all loaded [Patients]
  List<Patient> get all => [
        ..._patientsByAssignmentStatus.active,
        ..._patientsByAssignmentStatus.unassigned,
        ..._patientsByAssignmentStatus.discharged,
      ];

  /// Filtered by Search
  List<Patient> get filtered {
    List<Patient> usedPatients = all;
    if (selectedPatientStatus != null) {
      usedPatients = _patientsByAssignmentStatus.byAssignmentStatus(selectedPatientStatus!);
    }
    List<Patient> results = multiSearchWithMapping(
      _searchedText,
      usedPatients,
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
    return results;
  }

  /// Loads the [patients]
  Future<void> load() async {
    state = LoadingState.loading;
    notifyListeners();

    _patientsByAssignmentStatus = await PatientService().getPatientList(wardId: CurrentWardService().currentWard?.wardId);
    state = LoadingState.loaded;
    notifyListeners();
  }

  /// Discharges the patient the [patients]
  Future<void> discharge(String patientId) async {
    state = LoadingState.loading;
    notifyListeners();
    await PatientService().dischargePatient(patientId: patientId);
    // Here we can maybe use optimistic updates
    load();
  }
}
