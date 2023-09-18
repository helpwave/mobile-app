import 'package:helpwave_proto_dart/proto/services/task_svc/v1/patient_svc.pbgrpc.dart';
import 'package:tasks/dataclasses/bed.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/room.dart';
import 'package:tasks/services/grpc_client_svc.dart';

class PatientService {
  PatientServiceClient patientService =
      GRPCClientService.getPatientServiceClient;

  // TODO consider an enum instead of an string
  Future<Map<PatientAssignmentStatus, List<Patient>>> getPatientList(
      {String? wardId}) async {
    GetPatientListRequest patientListRequest = GetPatientListRequest(wardId: wardId);
    GetPatientListResponse patientListResponse =
        await patientService.getPatientList(patientListRequest);

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
}
