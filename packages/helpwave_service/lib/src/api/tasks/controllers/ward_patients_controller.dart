import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_util/loading.dart';
import 'package:helpwave_util/search.dart';

/// The Controller for managing [Patient]s in a [Ward]
class WardPatientsController extends LoadingChangeNotifier {
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

  /// Discharged [Patients]
  List<Patient> get discharged => _patientsByAssignmentStatus.discharged;

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

  /// Loads the [Patient]s
  Future<void> load() async {
    loadPatients() async {
      _patientsByAssignmentStatus = await PatientService().getPatientList();
    }
    loadHandler(future: loadPatients());
  }

  /// Discharges the patient the [patients]
  Future<void> discharge(String patientId) async {
    dischargePatient() async {
      await PatientService().dischargePatient(patientId: patientId);
      await load();
    }
    loadHandler(future: dischargePatient());
  }
}
