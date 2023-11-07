import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/patient_svc.pbgrpc.dart';
import 'package:tasks/dataclasses/bed.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/room.dart';
import 'package:tasks/dataclasses/subtask.dart';
import 'package:tasks/dataclasses/ward.dart';
import 'package:tasks/services/grpc_client_svc.dart';

import '../dataclasses/task.dart';

/// The GRPC Service for [Patient]s
///
/// Provides queries and requests that load or alter [Patient] objects on the server
/// The server is defined in the underlying [GRPCClientService]
class PatientService {
  /// The GRPC ServiceClient which handles GRPC
  PatientServiceClient patientService =
      GRPCClientService.getPatientServiceClient;

  // TODO consider an enum instead of an string
  /// Loads the [Patient]s by [Ward] and sorts them by their assignment status
  Future<PatientsByAssignmentStatus> getPatientList({String? wardId}) async {
    GetPatientListRequest patientListRequest =
        GetPatientListRequest(wardId: wardId);
    GetPatientListResponse patientListResponse =
        await patientService.getPatientList(
      patientListRequest,
      options: CallOptions(
        metadata: GRPCClientService().getTaskServiceMetaData(),
      ),
    );

    List<Patient> active = patientListResponse.active
        .map(
          (patient) => Patient(
            id: patient.id,
            name: patient.humanReadableIdentifier,
            tasks: [],
            notes: "",
            bed: BedMinimal(id: patient.bed.id, name: patient.bed.name),
            room: RoomMinimal(id: patient.room.id, name: patient.room.name),
          ),
        )
        .toList();

    List<Patient> unassigned = patientListResponse.unassignedPatients
        .map(
          (patient) => Patient(
            id: patient.id,
            name: patient.humanReadableIdentifier,
            tasks: [],
            notes: "",
          ),
        )
        .toList();

    List<Patient> discharged = patientListResponse.dischargedPatients
        .map(
          (patient) => Patient(
            id: patient.id,
            name: patient.humanReadableIdentifier,
            tasks: [],
            notes: "",
          ),
        )
        .toList();

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
        metadata: GRPCClientService().getTaskServiceMetaData(),
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
        metadata: GRPCClientService().getTaskServiceMetaData(),
      ),
    );

    Map<GetPatientDetailsResponse_TaskStatus, TaskStatus> statusMap = {
      GetPatientDetailsResponse_TaskStatus.TASK_STATUS_TODO: TaskStatus.todo,
      GetPatientDetailsResponse_TaskStatus.TASK_STATUS_IN_PROGRESS:
          TaskStatus.inProgress,
      GetPatientDetailsResponse_TaskStatus.TASK_STATUS_DONE: TaskStatus.done,
      GetPatientDetailsResponse_TaskStatus.TASK_STATUS_UNSPECIFIED:
          TaskStatus.unspecified,
    };

    return Patient(
      id: response.id,
      name: response.humanReadableIdentifier,
      notes: response.notes,
      tasks: response.tasks
          .map((task) => Task(
                id: task.id,
                name: task.name,
                notes: task.description,
                assignee: task.assignedUserId,
                status: statusMap[task.status]!,
                isPublicVisible: task.public,
                subtasks: task.subtasks
                    .map((subtask) => SubTask(
                          id: subtask.id,
                          name: subtask.name,
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }

  /// Loads the [Room]s with [Bed]s and an optional patient in them
  Future<List<RoomWithBedWithMinimalPatient>> getPatientAssignmentByWard(
      {required String wardId}) async {
    GetPatientAssignmentByWardRequest request =
        GetPatientAssignmentByWardRequest(wardId: wardId);
    GetPatientAssignmentByWardResponse response =
        await patientService.getPatientAssignmentByWard(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getTaskServiceMetaData(),
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
              patient: patient.isInitialized()
                  ? PatientMinimal(id: patient.id, name: patient.name)
                  : null,
            );
          }).toList());
    }).toList();
  }

  // TODO consider an enum instead of an string
  /// Discharges a [Patient]
  Future<bool> dischargePatient({required String patientId}) async {
    DischargePatientRequest request = DischargePatientRequest(id: patientId);
    DischargePatientResponse response = await patientService.dischargePatient(
        request,
        options: CallOptions(
            metadata: GRPCClientService().getTaskServiceMetaData()));

    if (response.isInitialized()) {
      return true;
    }
    return false;
  }
}
