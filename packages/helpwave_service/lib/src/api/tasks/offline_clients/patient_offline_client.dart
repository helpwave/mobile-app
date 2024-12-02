import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/patient_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/offline/offline_client_store.dart';
import 'package:helpwave_service/src/api/offline/util.dart';
import 'package:helpwave_service/src/api/tasks/data_types/patient.dart';
import 'package:helpwave_service/src/api/tasks/util/task_status_mapping.dart';

class PatientUpdate {
  String id;
  String? name;
  String? notes;
  bool? isDischarged;

  PatientUpdate({required this.id, this.name, this.notes, this.isDischarged});
}

class PatientOfflineService {
  List<PatientWithBedId> patients = [];

  PatientWithBedId? findPatient(String id) {
    int index = OfflineClientStore().patientStore.patients.indexWhere((value) => value.id == id);
    if (index == -1) {
      return null;
    }
    return patients[index];
  }

  PatientWithBedId? findPatientByBed(String bedId) {
    final valueStore = OfflineClientStore().patientStore;
    return valueStore.patients.where((value) => value.bedId == bedId).firstOrNull;
  }

  void create(PatientWithBedId patient) {
    OfflineClientStore().patientStore.patients.add(patient);
  }

  void update(PatientUpdate patientUpdate) {
    final valueStore = OfflineClientStore().patientStore;
    bool found = false;

    valueStore.patients = valueStore.patients.map((value) {
      if (value.id == patientUpdate.id) {
        found = true;
        return value.copyWith(
          notes: patientUpdate.notes,
          name: patientUpdate.name,
          isDischarged: patientUpdate.isDischarged,
        );
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('UpdatePatient: Could not find patient with id ${patientUpdate.id}');
    }
  }

  void assignBed(String patientId, String bedId) {
    final valueStore = OfflineClientStore().patientStore;
    final bed = OfflineClientStore().bedStore.findBed(bedId);
    if (bed != null) {
      throw Exception('Could not find bed with id $bedId');
    }
    bool found = false;

    valueStore.patients = valueStore.patients.map((value) {
      if (value.id == patientId) {
        found = true;
        return value.copyWith(bedId: bedId);
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('Could not find patient with id $patientId');
    }
  }

  void unassignBed(String patientId) {
    final valueStore = OfflineClientStore().patientStore;
    bool found = false;

    valueStore.patients = valueStore.patients.map((value) {
      if (value.id == patientId) {
        found = true;
        final copy = value.copyWith();
        copy.bedId = null;
        return copy;
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('Could not find patient with id $patientId');
    }
  }

  void delete(String patientId) {
    final valueStore = OfflineClientStore().patientStore;
    valueStore.patients = valueStore.patients.where((value) => value.id != patientId).toList();
    final tasks = OfflineClientStore().taskStore.findTasks(patientId);
    for (var task in tasks) {
      OfflineClientStore().taskStore.delete(task.id!);
    }
  }
}

class PatientOfflineClient extends PatientServiceClient {
  PatientOfflineClient(super.channel);

  @override
  ResponseFuture<GetPatientResponse> getPatient(GetPatientRequest request, {CallOptions? options}) {
    final patient = OfflineClientStore().patientStore.findPatient(request.id);

    if (patient == null) {
      throw "Patient with patient id ${request.id} not found";
    }

    final response = GetPatientResponse(id: patient.id, humanReadableIdentifier: patient.name, notes: patient.notes);

    if (patient.bedId == null) {
      return MockResponseFuture.value(response);
    }
    final bed = OfflineClientStore().bedStore.findBed(patient.bedId!);
    if (bed == null) {
      return MockResponseFuture.value(response);
    }
    final room = OfflineClientStore().roomStore.findRoom(bed.roomId);
    if (room == null) {
      return MockResponseFuture.value(response);
    }
    response.bed = GetPatientResponse_Bed(id: bed.id, name: bed.name);
    response.room = GetPatientResponse_Room(id: room.id, name: room.name);
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetPatientDetailsResponse> getPatientDetails(GetPatientDetailsRequest request,
      {CallOptions? options}) {
    final patient = OfflineClientStore().patientStore.findPatient(request.id);

    if (patient == null) {
      throw "Patient with patient id ${request.id} not found";
    }

    final response = GetPatientDetailsResponse(
      id: patient.id,
      humanReadableIdentifier: patient.name,
      notes: patient.notes,
      isDischarged: patient.isDischarged,
      tasks: OfflineClientStore().taskStore.findTasks(patient.id).map((task) => GetPatientDetailsResponse_Task(
            id: task.id,
            name: task.name,
            patientId: patient.id,
            assignedUserId: task.assigneeId,
            description: task.notes,
            public: task.isPublicVisible,
            status: TasksGRPCTypeConverter.taskStatusToGRPC(task.status),
            subtasks: OfflineClientStore()
                .subtaskStore
                .findSubtasks(task.id)
                .map((subtask) => GetPatientDetailsResponse_Task_SubTask(
                      id: subtask.id,
                      name: subtask.name,
                      done: subtask.isDone,
                    )),
          )),
    );

    if (patient.bedId == null) {
      return MockResponseFuture.value(response);
    }
    final bed = OfflineClientStore().bedStore.findBed(patient.bedId!);
    if (bed == null) {
      return MockResponseFuture.value(response);
    }
    final room = OfflineClientStore().roomStore.findRoom(bed.roomId);
    if (room == null) {
      return MockResponseFuture.value(response);
    }
    response.bed = GetPatientDetailsResponse_Bed(id: bed.id, name: bed.name);
    response.room = GetPatientDetailsResponse_Room(id: room.id, name: room.name);
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetPatientByBedResponse> getPatientByBed(GetPatientByBedRequest request, {CallOptions? options}) {
    final patient = OfflineClientStore().patientStore.findPatientByBed(request.bedId);

    if (patient == null) {
      throw "Patient with bed id ${request.bedId} not found";
    }

    final response = GetPatientByBedResponse(
      id: patient.id,
      humanReadableIdentifier: patient.name,
      notes: patient.notes,
      bedId: patient.bedId,
    );
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetPatientListResponse> getPatientList(GetPatientListRequest request, {CallOptions? options}) {
    mapping(patient) {
      final res = GetPatientListResponse_Patient(
        id: patient.id,
        notes: patient.description,
        humanReadableIdentifier: patient.name,
        tasks: OfflineClientStore().taskStore.findTasks(patient.id).map((task) => GetPatientListResponse_Task(
          id: task.id,
          name: task.name,
          patientId: patient.id,
          assignedUserId: task.assigneeId,
          description: task.notes,
          public: task.isPublicVisible,
          status: TasksGRPCTypeConverter.taskStatusToGRPC(task.status),
          subtasks: OfflineClientStore()
              .subtaskStore
              .findSubtasks(task.id)
              .map((subtask) => GetPatientListResponse_Task_SubTask(
            id: subtask.id,
            name: subtask.name,
            done: subtask.isDone,
          )),
        )),
      );
      if (patient.bedId == null) {
        return res;
      }
      final bed = OfflineClientStore().bedStore.findBed(patient.bedId!);
      if (bed == null) {
        return res;
      }
      final room = OfflineClientStore().roomStore.findRoom(bed.roomId);
      if (room == null) {
        return res;
      }
      res.bed = GetPatientListResponse_Bed(id: bed.id, name: bed.name);
      res.room = GetPatientListResponse_Room(id: room.id, name: room.name);
      return res;
    }

    final patients = OfflineClientStore().patientStore.patients;
    final active = patients.where((element) => element.hasBed).map(mapping);
    final discharged = patients.where((element) => element.isDischarged).map(mapping);
    final unassigned = patients.where((element) => !element.isDischarged && element.bedId == null).map(mapping);
    final response = GetPatientListResponse(
      active: active,
      dischargedPatients: discharged,
      unassignedPatients: unassigned,
    );

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetRecentPatientsResponse> getRecentPatients(GetRecentPatientsRequest request,
      {CallOptions? options}) {
    final patients = OfflineClientStore().patientStore.patients.where((element) => element.hasBed).map((patient) {
      final res = GetRecentPatientsResponse_Patient(
        id: patient.id,
        humanReadableIdentifier: patient.name,
      );
      if (patient.bedId == null) {
        return res;
      }
      final bed = OfflineClientStore().bedStore.findBed(patient.bedId!);
      if (bed == null) {
        return res;
      }
      final room = OfflineClientStore().roomStore.findRoom(bed.roomId);
      if (room == null) {
        return res;
      }
      res.bed = GetRecentPatientsResponse_Bed(id: bed.id, name: bed.name);
      res.room = GetRecentPatientsResponse_Room(id: room.id, name: room.name);
      return res;
    });
    final response = GetRecentPatientsResponse(recentPatients: patients);

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetPatientsByWardResponse> getPatientsByWard(GetPatientsByWardRequest request,
      {CallOptions? options}) {
    final rooms = OfflineClientStore().roomStore.findRooms(request.wardId);
    final beds = rooms.map((room) => OfflineClientStore().bedStore.findBeds(room.id)).expand((element) => element);
    List<GetPatientsByWardResponse_Patient> patients = [];

    for (final bed in beds) {
      final patient = OfflineClientStore().patientStore.findPatientByBed(bed.id);
      if (patient != null) {
        patients.add(GetPatientsByWardResponse_Patient(
            id: patient.id, notes: patient.notes, humanReadableIdentifier: patient.name, bedId: patient.bedId));
      }
    }
    final response = GetPatientsByWardResponse(patients: patients);

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetPatientAssignmentByWardResponse> getPatientAssignmentByWard(
      GetPatientAssignmentByWardRequest request,
      {CallOptions? options}) {
    final rooms =
        OfflineClientStore().roomStore.findRooms(request.wardId).map((room) => GetPatientAssignmentByWardResponse_Room(
              id: room.id,
              name: room.name,
              beds: OfflineClientStore().bedStore.findBeds(room.id).map((bed) {
                final res = GetPatientAssignmentByWardResponse_Room_Bed(id: bed.id, name: bed.name);
                final patient = OfflineClientStore().patientStore.findPatientByBed(bed.id);
                if (patient != null) {
                  res.patient = GetPatientAssignmentByWardResponse_Room_Bed_Patient(
                    id: patient.id,
                    name: patient.name,
                  );
                }
                return res;
              }),
            ));
    final response = GetPatientAssignmentByWardResponse(rooms: rooms);

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<CreatePatientResponse> createPatient(CreatePatientRequest request, {CallOptions? options}) {
    final newPatient = PatientWithBedId(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: request.humanReadableIdentifier,
      notes: request.notes,
      isDischarged: false,
    );

    OfflineClientStore().patientStore.create(newPatient);

    final response = CreatePatientResponse()..id = newPatient.id!;

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<UpdatePatientResponse> updatePatient(UpdatePatientRequest request, {CallOptions? options}) {
    final update = PatientUpdate(
      id: request.id,
      name: request.hasHumanReadableIdentifier() ? request.humanReadableIdentifier : null,
      notes: request.hasNotes() ? request.notes : null,
    );

    OfflineClientStore().patientStore.update(update);

    final response = UpdatePatientResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<AssignBedResponse> assignBed(AssignBedRequest request, {CallOptions? options}) {
    OfflineClientStore().patientStore.assignBed(request.id, request.bedId);
    final response = AssignBedResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<UnassignBedResponse> unassignBed(UnassignBedRequest request, {CallOptions? options}) {
    OfflineClientStore().patientStore.unassignBed(request.id);
    final response = UnassignBedResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<DischargePatientResponse> dischargePatient(DischargePatientRequest request, {CallOptions? options}) {
    final update = PatientUpdate(id: request.id, isDischarged: true);

    OfflineClientStore().patientStore.update(update);
    OfflineClientStore().patientStore.unassignBed(request.id);

    final response = DischargePatientResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<ReadmitPatientResponse> readmitPatient(ReadmitPatientRequest request, {CallOptions? options}) {
    final update = PatientUpdate(id: request.patientId, isDischarged: false);

    OfflineClientStore().patientStore.update(update);

    final response = ReadmitPatientResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<DeletePatientResponse> deletePatient(DeletePatientRequest request, {CallOptions? options}) {
    OfflineClientStore().patientStore.delete(request.id);

    final response = DeletePatientResponse();
    return MockResponseFuture.value(response);
  }
}
