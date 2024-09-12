import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/room_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/tasks/data_types/index.dart';
import 'package:helpwave_service/src/api/tasks/tasks_api_services.dart';

/// The GRPC Service for [Room]s
///
/// Provides queries and requests that load or alter [Room] objects on the server
/// The server is defined in the underlying [TasksAPIServices]
class RoomService {
  /// The GRPC ServiceClient which handles GRPC
  RoomServiceClient roomService = TasksAPIServices.roomServiceClient;

  Future<List<RoomWithBedWithMinimalPatient>> getRoomOverviews({required String wardId}) async {
    GetRoomOverviewsByWardRequest request = GetRoomOverviewsByWardRequest(id: wardId);
    GetRoomOverviewsByWardResponse response = await roomService.getRoomOverviewsByWard(
      request,
      options: CallOptions(metadata: TasksAPIServices().getMetaData()),
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
