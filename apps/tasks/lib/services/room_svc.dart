import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/room_svc.pbgrpc.dart';
import 'package:tasks/dataclasses/bed.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/room.dart';
import 'package:tasks/services/grpc_client_svc.dart';

/// The GRPC Service for [Room]s
///
/// Provides queries and requests that load or alter [Room] objects on the server
/// The server is defined in the underlying [GRPCClientService]
class RoomService {
  /// The GRPC ServiceClient which handles GRPC
  RoomServiceClient roomService = GRPCClientService.getRoomServiceClient;

  Future<List<RoomWithBedWithMinimalPatient>> getRoomOverviews({required String wardId}) async {
    GetRoomOverviewsByWardRequest request = GetRoomOverviewsByWardRequest(id: wardId);
    GetRoomOverviewsByWardResponse response = await roomService.getRoomOverviewsByWard(
      request,
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    List<RoomWithBedWithMinimalPatient> rooms = response.rooms
        .map((room) => RoomWithBedWithMinimalPatient(
              id: room.id,
              name: room.name,
              beds: room.beds
                  .map((bed) => BedWithMinimalPatient(
                        id: bed.id,
                        name: bed.name,
                        patient: bed.hasPatient()
                            // TODO bed.patient possibly has more information
                            ? PatientMinimal(
                                name: bed.patient.humanReadableIdentifier,
                                id: bed.patient.id,
                              )
                            : null,
                      ))
                  .toList(),
            ))
        .toList();

    return rooms;
  }
}
