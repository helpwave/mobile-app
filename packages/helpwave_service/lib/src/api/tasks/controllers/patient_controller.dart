import 'package:flutter/material.dart';
import 'package:helpwave_util/loading_state.dart';
import 'package:helpwave_service/src/api/tasks/index.dart';

/// The Controller for managing [Patient]s in a Ward
class PatientController extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState _state = LoadingState.initializing;

  /// The current [Patient], may or may not be loaded depending on the [_state]
  Patient _patient;

  /// The error message to show should only be used when [state] == [LoadingState.error]
  String errorMessage = "";

  PatientController(this._patient) {
    if (!_patient.isCreating) {
      load();
    }
  }

  LoadingState get state => _state;

  set state(LoadingState value) {
    _state = value;
    notifyListeners();
  }

  Patient get patient => _patient;

  set patient(Patient value) {
    _patient = value;
    _state = LoadingState.loaded;
    notifyListeners();
  }

  /// Saves whether we are currently creating of a patient or already have them
  get isCreating => _patient.isCreating;

  // Used to trigger the notify call without having to copy or save the patient locally
  updatePatient(void Function(Patient patient) updateTransform, void Function(Patient patient) revertTransform) {
    updateTransform(patient);
    if (!isCreating) {
      PatientService().updatePatient(patient).then((value) {
        if (value) {
          state = LoadingState.loaded;
        } else {
          throw Error();
        }
      }).catchError((error, stackTrace) {
        revertTransform(patient);
        errorMessage = error.toString();
        state = LoadingState.error;
      });
    } else {
      state = LoadingState.loaded;
    }
  }

  /// A function to load the [Patient]
  Future<void> load() async {
    state = LoadingState.loading;
    await PatientService().getPatientDetails(patientId: patient.id).then((value) {
      patient = value;
      state = LoadingState.loaded;
    }).catchError((error, stackTrace) {
      errorMessage = error.toString();
      state = LoadingState.error;
    });
  }

  /// Unassigns the patient the [patients]
  Future<void> unassign() async {
    state = LoadingState.loading;
    notifyListeners();
    await PatientService().unassignPatient(patientId: patient.id);
    // Here we can maybe use optimistic updates
    load();
  }

  /// Discharges the patient the [patients]
  Future<void> discharge() async {
    state = LoadingState.loading;
    notifyListeners();
    await PatientService().dischargePatient(patientId: patient.id);
    // Here we can maybe use optimistic updates
    load();
  }

  /// Assigns the patient to a bed
  Future<void> changeBed(RoomMinimal room, BedMinimal bed) async {
    if (isCreating) {
      patient.room = room;
      patient.bed = bed;
      state = LoadingState.loaded;
      return;
    }
    state = LoadingState.loading;
    await PatientService().assignBed(patientId: patient.id, bedId: bed.id).then((value) {
      patient.room = room;
      patient.bed = bed;
      state = LoadingState.loaded;
    }).catchError((error, stackTrace) {
      errorMessage = error.toString();
      state = LoadingState.error;
    });
  }

  /// Change the name of the [patient]
  Future<void> changeName(String name) async {
    String oldName = name;
    updatePatient(
      (patient) {
        patient.name = name;
      },
      (patient) {
        patient.name = oldName;
      },
    );
  }

  /// Change the notes of the [patient]
  Future<void> changeNotes(String notes) async {
    String oldNotes = notes;
    updatePatient(
      (patient) {
        patient.notes = notes;
      },
      (patient) {
        patient.notes = oldNotes;
      },
    );
  }

  /// Creates the patient and returns
  Future<bool> create() async {
    state = LoadingState.loading;
    return await PatientService().createPatient(patient).then((value) async {
      patient.id = value;
      if (!patient.isUnassigned) {
        await PatientService().assignBed(patientId: patient.id, bedId: patient.bed!.id);
      }
      state = LoadingState.loaded;
      return true;
    }).catchError((error, stackTrace) {
      errorMessage = error.toString();
      state = LoadingState.error;
      return false;
    });
  }
}
