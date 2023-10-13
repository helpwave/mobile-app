import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/patient_svc.pbgrpc.dart';
import 'package:tasks/dataclasses/bed.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/room.dart';
import 'package:tasks/dataclasses/ward.dart';
import 'package:tasks/services/grpc_client_svc.dart';

/// The GRPC Service for [Patient]s
///
/// Provides queries and requests that load or alter [Patient] objects on the server
/// The server is defined in the underlying [GRPCClientService]
class PatientService {
  /// The GRPC ServiceClient which handles GRPC
  PatientServiceClient patientService = GRPCClientService.getPatientServiceClient;

  // TODO consider an enum instead of an string
  /// Loads the [Patient]s by [Ward] and sorts them by their assignment status
  Future<Map<PatientAssignmentStatus, List<Patient>>> getPatientList({String? wardId}) async {
    GetPatientListRequest patientListRequest = GetPatientListRequest(wardId: wardId);
    GetPatientListResponse patientListResponse = await patientService.getPatientList(patientListRequest,
        options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()));

    List<Patient> active = patientListResponse.active
        .map(
          (patient) => Patient(
            id: patient.id,
            name: patient.humanReadableIdentifier,
            tasks: [],
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
          ),
        )
        .toList();

    List<Patient> discharged = patientListResponse.dischargedPatients
        .map(
          (patient) => Patient(
            id: patient.id,
            name: patient.humanReadableIdentifier,
            tasks: [],
          ),
        )
        .toList();

    return {
      PatientAssignmentStatus.active: active,
      PatientAssignmentStatus.unassigned: unassigned,
      PatientAssignmentStatus.discharged: discharged
    };
  }

  // TODO consider an enum instead of an string
  /// Discharges a [Patient]
  Future<bool> dischargePatient({required String patientId}) async {
    DischargePatientRequest request = DischargePatientRequest(id: patientId);
    DischargePatientResponse response = await patientService.dischargePatient(request,
        options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()));

    if (response.isInitialized()) {
      return true;
    }
    return false;
  }
}
