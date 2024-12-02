import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/room_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/tasks/data_types/index.dart';
import 'package:helpwave_service/src/api/tasks/tasks_api_service_clients.dart';

/// The GRPC Service for [Room]s
///
/// Provides queries and requests that load or alter [Room] objects on the server
/// The server is defined in the underlying [TasksAPIServiceClients]
class RoomService {
  /// The GRPC ServiceClient which handles GRPC
  RoomServiceClient roomService = TasksAPIServiceClients().roomServiceClient;

  Future<RoomWithBedWithMinimalPatient> get({required String roomId}) async {
    GetRoomRequest request = GetRoomRequest(id: roomId);
    GetRoomResponse response = await roomService.getRoom(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    RoomWithBedWithMinimalPatient rooms = RoomWithBedWithMinimalPatient(
      id: response.id,
      name: response.name,
      beds: response.beds.map((bed) => Bed(id: bed.id, name: bed.name, roomId: roomId)).toList(),
    );

    return rooms;
  }

  Future<List<RoomWithBedWithMinimalPatient>> getRooms({required String wardId}) async {
    GetRoomsRequest request = GetRoomsRequest(wardId: wardId);
    GetRoomsResponse response = await roomService.getRooms(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    List<RoomWithBedWithMinimalPatient> rooms = response.rooms
        .map((room) => RoomWithBedWithMinimalPatient(
              id: room.id,
              name: room.name,
              beds: room.beds.map((bed) => Bed(id: bed.id, name: bed.name, roomId: room.id)).toList(),
            ))
        .toList();

    return rooms;
  }

  Future<List<RoomWithBedWithMinimalPatient>> getRoomOverviews({required String wardId}) async {
    GetRoomOverviewsByWardRequest request = GetRoomOverviewsByWardRequest(id: wardId);
    GetRoomOverviewsByWardResponse response = await roomService.getRoomOverviewsByWard(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    List<RoomWithBedWithMinimalPatient> rooms = response.rooms
        .map((room) => RoomWithBedWithMinimalPatient(
              id: room.id,
              name: room.name,
              beds: room.beds
                  .map((bed) => Bed(
                        id: bed.id,
                        name: bed.name,
                        roomId: room.id,
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

  Future<RoomMinimal> createRoom({required String wardId, required String name}) async {
    CreateRoomRequest request = CreateRoomRequest(wardId: wardId, name: name);
    CreateRoomResponse response = await roomService.createRoom(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    return RoomMinimal(id: response.id, name: name);
  }

  Future<void> update({
    required String id,
    String? name,
  }) async {
    UpdateRoomRequest request = UpdateRoomRequest(id: id, name: name);
    await roomService.updateRoom(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );
  }

  Future<bool> delete({
    required String id,
  }) async {
    DeleteRoomRequest request = DeleteRoomRequest(id: id);
    await roomService.deleteRoom(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );
    return true;
  }
}
