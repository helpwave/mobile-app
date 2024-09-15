import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/patient_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_service/src/api/tasks/util/task_status_mapping.dart';

/// The GRPC Service for [Patient]s
///
/// Provides queries and requests that load or alter [Patient] objects on the server
/// The server is defined in the underlying [TasksAPIServiceClients]
class PatientService {
  /// The GRPC ServiceClient which handles GRPC
  PatientServiceClient patientService = TasksAPIServiceClients().patientServiceClient;

  // TODO consider an enum instead of an string
  /// Loads the [Patient]s by [Ward] and sorts them by their assignment status
  Future<PatientsByAssignmentStatus> getPatientList({String? wardId}) async {
    GetPatientListRequest request = GetPatientListRequest(wardId: wardId);
    GetPatientListResponse response = await patientService.getPatientList(
      request,
      options: CallOptions(
        metadata: TasksAPIServiceClients().getMetaData(),
      ),
    );

    mapping(GetPatientListResponse_Patient patient) {
      final res = Patient(
        id: patient.id,
        name: patient.humanReadableIdentifier,
        isDischarged: response.dischargedPatients.contains(patient),
        tasks: patient.tasks
            .map((task) => Task(
                  id: task.id,
                  name: task.name,
                  notes: task.description,
                  status: GRPCTypeConverter.taskStatusFromGRPC(task.status),
                  isPublicVisible: task.public,
                  assigneeId: task.assignedUserId,
                  subtasks: task.subtasks
                      .map((subtask) =>
                          Subtask(id: subtask.id, name: subtask.name, isDone: subtask.done, taskId: task.id))
                      .toList(),
                  patientId: patient.id,
                  // TODO due and creation date
                ))
            .toList(),
        notes: patient.notes,
        bed: BedMinimal(id: patient.bed.id, name: patient.bed.name),
        room: RoomMinimal(id: patient.room.id, name: patient.room.name),
      );
      if (patient.hasBed() && patient.hasRoom()) {
        res.bed = BedMinimal(id: patient.bed.id, name: patient.bed.name);
        res.room = RoomMinimal(id: patient.room.id, name: patient.room.name);
      }
      return res;
    }

    final active = response.active.map(mapping).toList();
    final unassigned = response.unassignedPatients.map(mapping).toList();
    final discharged = response.dischargedPatients.map(mapping).toList();

    return PatientsByAssignmentStatus(
      all: active + unassigned + discharged,
      active: active,
      unassigned: unassigned,
      discharged: discharged,
    );
  }

  /// Loads the [Patient]s by id
  Future<PatientMinimal> getPatient({required String patientId}) async {
    GetPatientRequest request = GetPatientRequest(id: patientId);
    GetPatientResponse response = await patientService.getPatient(
      request,
      options: CallOptions(
        metadata: TasksAPIServiceClients().getMetaData(),
      ),
    );

    // TODO maybe also use bedId and notes from response
    return PatientMinimal(
      id: response.id,
      name: response.humanReadableIdentifier,
    );
  }

  /// Loads the [Patient]s with detailed information
  Future<Patient> getPatientDetails({required String patientId}) async {
    GetPatientDetailsRequest request = GetPatientDetailsRequest(id: patientId);
    GetPatientDetailsResponse response = await patientService.getPatientDetails(
      request,
      options: CallOptions(
        metadata: TasksAPIServiceClients().getMetaData(),
      ),
    );

    return Patient(
      id: response.id,
      name: response.humanReadableIdentifier,
      notes: response.notes,
      isDischarged: response.isDischarged,
      tasks: response.tasks
          .map((task) => Task(
              id: task.id,
              name: task.name,
              notes: task.description,
              assigneeId: task.assignedUserId,
              status: GRPCTypeConverter.taskStatusFromGRPC(task.status),
              isPublicVisible: task.public,
              subtasks: task.subtasks
                  .map((subtask) => Subtask(
                        id: subtask.id,
                        taskId: task.id,
                        name: subtask.name,
                      ))
                  .toList(),
              patientId: response.id))
          .toList(),
      bed: response.hasBed() ? BedMinimal(id: response.bed.id, name: response.bed.name) : null,
      room: response.hasRoom() ? RoomMinimal(id: response.room.id, name: response.room.name) : null,
    );
  }

  /// Loads the [Room]s with [Bed]s and an optional patient in them
  Future<List<RoomWithBedWithMinimalPatient>> getPatientAssignmentByWard({required String wardId}) async {
    GetPatientAssignmentByWardRequest request = GetPatientAssignmentByWardRequest(wardId: wardId);
    GetPatientAssignmentByWardResponse response = await patientService.getPatientAssignmentByWard(
      request,
      options: CallOptions(
        metadata: TasksAPIServiceClients().getMetaData(),
      ),
    );

    return response.rooms.map((room) {
      var beds = room.beds;
      return RoomWithBedWithMinimalPatient(
          id: room.id,
          name: room.id,
          beds: beds.map((bed) {
            var patient = bed.patient;
            return BedWithMinimalPatient(
              id: bed.id,
              name: bed.name,
              patient: patient.isInitialized() ? PatientMinimal(id: patient.id, name: patient.name) : null,
            );
          }).toList());
    }).toList();
  }

  /// Create a [Patient]
  Future<String> createPatient(Patient patient) async {
    CreatePatientRequest request = CreatePatientRequest(
      notes: patient.notes,
      humanReadableIdentifier: patient.name,
    );
    CreatePatientResponse response = await patientService.createPatient(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    return response.id;
  }

  /// Update a [Patient]
  Future<bool> updatePatient(Patient patient) async {
    UpdatePatientRequest request = UpdatePatientRequest(
      id: patient.id,
      notes: patient.notes,
      humanReadableIdentifier: patient.name,
    );
    UpdatePatientResponse response = await patientService.updatePatient(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    if (response.isInitialized()) {
      return true;
    }
    return false;
  }

  // TODO consider an enum instead of an string
  /// Discharges a [Patient]
  Future<bool> dischargePatient({required String patientId}) async {
    DischargePatientRequest request = DischargePatientRequest(id: patientId);
    DischargePatientResponse response = await patientService.dischargePatient(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    if (response.isInitialized()) {
      return true;
    }
    return false;
  }

  /// Unassigns a [Patient] from a [Bed]
  Future<bool> unassignPatient({required String patientId}) async {
    UnassignBedRequest request = UnassignBedRequest(id: patientId);
    UnassignBedResponse response = await patientService.unassignBed(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    if (response.isInitialized()) {
      return true;
    }
    return false;
  }

  /// Assigns a [Patient] to a [Bed]
  Future<bool> assignBed({required String patientId, required String bedId}) async {
    AssignBedRequest request = AssignBedRequest(id: patientId, bedId: bedId);
    AssignBedResponse response = await patientService.assignBed(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    if (response.isInitialized()) {
      return true;
    }
    return false;
  }
}
