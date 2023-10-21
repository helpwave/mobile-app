import 'package:flutter/material.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:tasks/dataclasses/bed.dart';
import 'package:tasks/services/patient_svc.dart';

import '../dataclasses/patient.dart';
import '../dataclasses/room.dart';

/// The Controller for managing [Patient]s in a Ward
class PatientController extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState _state = LoadingState.initializing;

  /// The current [Patient], may or may not be loaded depending on the [_state]
  Patient _patient;

  /// The error message to show should only be used when [state] == [LoadingState.error]
  String errorMessage = "";

  /// Saves whether we are currently creating of a patient or already have them
  bool _isCreating = false;

  // TODO fetch later on
  /// The list of rooms and beds where the [Patient] may lie
  List<RoomWithBedFlat> bedOptions = [
    RoomWithBedFlat(
      room: RoomMinimal(id: "room1", name: "Room 1"),
      bed: BedMinimal(id: "bed1", name: "Bed 1"),
    ),
    RoomWithBedFlat(
      room: RoomMinimal(id: "room1", name: "Room 1"),
      bed: BedMinimal(id: "bed2", name: "Bed 2"),
    ),
    RoomWithBedFlat(
      room: RoomMinimal(id: "room2", name: "Room 2"),
      bed: BedMinimal(id: "bed3", name: "Bed 1"),
    ),
    RoomWithBedFlat(
      room: RoomMinimal(id: "room2", name: "Room 2"),
      bed: BedMinimal(id: "bed4", name: "Bed 2"),
    ),
    RoomWithBedFlat(
      room: RoomMinimal(id: "room3", name: "Room 3"),
      bed: BedMinimal(id: "bed5", name: "Bed 1"),
    ),
  ];

  PatientController(this._patient) {
    _isCreating = _patient.id == "";
    if (!_isCreating) {
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

  // Used to trigger the notify call without having to copy or save the patient locally
  updatePatient(void Function(Patient patient) transformer) {
    transformer(patient);
    state = LoadingState.loaded;
  }

  get isCreating => _isCreating;

  /// A function to load the [Patient]
  load() async {
    state = LoadingState.loading;
    await PatientService()
        .getPatientDetails(patientId: patient.id)
        .then((value) => {patient = value})
        .catchError((error, stackTrace) {
      errorMessage = error.toString();
      state = LoadingState.error;
      return <Patient>{};
    });
  }
}
