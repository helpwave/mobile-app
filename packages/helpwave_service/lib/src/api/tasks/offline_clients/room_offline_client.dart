import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/room_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/offline/offline_client_store.dart';
import 'package:helpwave_service/src/api/offline/util.dart';
import 'package:helpwave_service/src/api/tasks/data_types/index.dart';

class RoomUpdate {
  String id;
  String? name;

  RoomUpdate({required this.id, required this.name});
}

class RoomOfflineService {
  List<RoomWithWardId> rooms = [];

  RoomWithWardId? findRoom(String id) {
    int index = OfflineClientStore().roomStore.rooms.indexWhere((value) => value.id == id);
    if (index == -1) {
      return null;
    }
    return rooms[index];
  }

  List<RoomWithWardId> findRooms([String? wardId]) {
    final valueStore = OfflineClientStore().roomStore;
    if (wardId == null) {
      return valueStore.rooms;
    }
    return valueStore.rooms.where((value) => value.wardId == wardId).toList();
  }

  void create(RoomWithWardId room) {
    OfflineClientStore().roomStore.rooms.add(room);
  }

  void update(RoomUpdate room) {
    final valueStore = OfflineClientStore().roomStore;
    bool found = false;

    valueStore.rooms = valueStore.rooms.map((value) {
      if (value.id == room.id) {
        found = true;
        return RoomWithWardId(id: room.id, name: room.name ?? value.name, wardId: value.wardId);
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('UpdateRoom: Could not find room with id ${room.id}');
    }
  }

  void delete(String roomId) {
    final valueStore = OfflineClientStore().roomStore;
    valueStore.rooms = valueStore.rooms.where((value) => value.id != roomId).toList();
    OfflineClientStore().bedStore.findBeds(roomId).forEach((element) {
      OfflineClientStore().bedStore.delete(element.id);
    });
  }
}

class RoomServicePromiseClient extends RoomServiceClient {
  RoomServicePromiseClient(super.channel);

  @override
  ResponseFuture<GetRoomResponse> getRoom(GetRoomRequest request, {CallOptions? options}) {
    final room = OfflineClientStore().roomStore.findRoom(request.id);

    if (room == null) {
      throw "Room with room id ${request.id} not found";
    }

    final response = GetRoomResponse()
      ..id = room.id
      ..name = room.name
      ..wardId = room.wardId;

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetRoomsResponse> getRooms(GetRoomsRequest request, {CallOptions? options}) {
    final rooms = OfflineClientStore().roomStore.findRooms();
    final roomsList = rooms.map((room) => GetRoomsResponse_Room(
          id: room.id,
          name: room.name,
          wardId: room.wardId,
          beds: OfflineClientStore().bedStore.findBeds(room.id).map((bed) => GetRoomsResponse_Room_Bed(
                id: bed.id,
                name: bed.name,
              )),
        ));

    final response = GetRoomsResponse(rooms: roomsList);
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetRoomOverviewsByWardResponse> getRoomOverviewsByWard(GetRoomOverviewsByWardRequest request,
      {CallOptions? options}) {
    final rooms = OfflineClientStore().roomStore.findRooms(request.id);

    final response = GetRoomOverviewsByWardResponse()
      ..rooms.addAll(rooms.map((room) => GetRoomOverviewsByWardResponse_Room()
        ..id = room.id
        ..name = room.name
        ..beds.addAll(OfflineClientStore().bedStore.findBeds(room.id).map((bed) {
          final response = GetRoomOverviewsByWardResponse_Room_Bed(id: bed.id, name: bed.name);
          final patient = OfflineClientStore().patientStore.findPatientByBed(bed.id);
          if (patient != null) {
            final tasks = OfflineClientStore().taskStore.findTasks(patient.id);
            response.patient = GetRoomOverviewsByWardResponse_Room_Bed_Patient(
              id: patient.id,
              humanReadableIdentifier: patient.name,
              tasksDone: tasks.where((element) => element.status == TaskStatus.done).length,
              tasksInProgress: tasks.where((element) => element.status == TaskStatus.inProgress).length,
              tasksUnscheduled: tasks.where((element) => element.status == TaskStatus.todo).length,
            );
          }
          return response;
        }))));
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<CreateRoomResponse> createRoom(CreateRoomRequest request, {CallOptions? options}) {
    final newRoom = RoomWithWardId(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: request.name,
      wardId: request.wardId,
    );

    OfflineClientStore().roomStore.create(newRoom);

    final response = CreateRoomResponse()..id = newRoom.id;

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<UpdateRoomResponse> updateRoom(UpdateRoomRequest request, {CallOptions? options}) {
    final update = RoomUpdate(
      id: request.id,
      name: request.name,
    );

    OfflineClientStore().roomStore.update(update);

    final response = UpdateRoomResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<DeleteRoomResponse> deleteRoom(DeleteRoomRequest request, {CallOptions? options}) {
    OfflineClientStore().roomStore.delete(request.id);

    final response = DeleteRoomResponse();
    return MockResponseFuture.value(response);
  }
}
