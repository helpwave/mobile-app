import 'package:helpwave_util/loading.dart';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_service/util.dart';

/// The Controller for managing [Patient]s in a Ward
class PatientController extends LoadingChangeNotifier {
  /// The current [Patient]
  Patient _patient = Patient.empty();

  /// The current [Patient]
  Patient get patient => _patient;

  set patient(Patient value) {
    _patient = value;
    changeState(LoadingState.loaded);
  }

  /// Is the current [Patient] already saved on the server or are we creating?
  get isCreating => _patient.isCreating;

  PatientController({String? id, Patient? patient}) {
    assert(patient == null || id == patient.id, "The id and patient id must be equal or not provided.");
    if(patient != null) {
      _patient = patient;
    } else if(id != null) {
      _patient.copyWith(id: id);
    }
    load();
  }

  /// A function to load the [Patient]
  Future<void> load() async {
    loadPatient() async {
      if (isCreating) {
        return;
      }
      patient = await PatientService().getPatientDetails(patientId: patient.id!);
    }

    loadHandler(
      future: loadPatient(),
    );
  }

  /// Unassigns the [Patient] from their [Bed]
  Future<void> unassign() async {
    unassignPatient() async {
      if(patient.isCreating) {
        final patientCopy = patient.copyWith();
        patientCopy.bed = null;
        patientCopy.room = null;
        _patient = patientCopy;
      }
      await PatientService().unassignPatient(patientId: patient.id!).then((value) {
        final patientCopy = patient.copyWith();
        patientCopy.bed = null;
        patientCopy.room = null;
        _patient = patientCopy;
      });
    }

    loadHandler(future: unassignPatient());
  }

  /// Discharges the [Patient]
  Future<void> discharge() async {
    assert(!patient.isCreating, "You can only discharge created patients");
    dischargePatient() async {
      await PatientService().dischargePatient(patientId: patient.id!).then((value) {
        final patientCopy = patient.copyWith(isDischarged: true);
        patientCopy.bed = null;
        patientCopy.room = null;
        patient = patientCopy;
      });
    }

    loadHandler(future: dischargePatient());
  }

  /// Assigns the [Patient] to a [Bed] and [Room]
  Future<void> assignToBed(RoomMinimal room, BedMinimal bed) async {
    assignPatientToBed() async {
      if (isCreating) {
        patient.room = room;
        patient.bed = bed;
        return;
      }
      await PatientService().assignBed(patientId: patient.id!, bedId: bed.id).then((value) {
        patient = patient.copyWith(bed: bed, room: room);
      });
    }

    loadHandler(future: assignPatientToBed());
  }

  /// Change the name of the [Patient]
  Future<void> changeName(String name) async {
    if (isCreating) {
      patient.name = name;
      return;
    }
    updateName() async {
      await PatientService().updatePatient(id: patient.id!, name: name).then((_) {
        patient.name = name;
      });
    }

    loadHandler(future: updateName());
  }

  /// Change the notes of the [Patient]
  Future<void> changeNotes(String notes) async {
    if (isCreating) {
      patient.notes = notes;
      return;
    }
    updateNotes() async {
      await PatientService().updatePatient(id: patient.id!, notes: notes).then((_) {
        patient.notes = notes;
      });
    }

    loadHandler(future: updateNotes());
  }

  /// Creates the [Patient]
  Future<void> create() async {
    createPatient() async {
      await PatientService().createPatient(patient).then((id) {
        patient = patient.copyWith(id: id);
      });
      if (!patient.isNotAssignedToBed) {
        await assignToBed(patient.room!, patient.bed!);
      }
    }

    loadHandler(future: createPatient());
  }
}
