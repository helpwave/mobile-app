import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/bed_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/tasks/data_types/index.dart';
import 'package:helpwave_service/src/api/tasks/tasks_api_service_clients.dart';

/// The GRPC Service for [Bed]s
///
/// Provides queries and requests that load or alter [Bed] objects on the server
/// The server is defined in the underlying [TasksAPIServiceClients]
class BedService {
  /// The GRPC ServiceClient which handles GRPC
  BedServiceClient bedService = TasksAPIServiceClients().bedServiceClient;

  Future<Bed> getBed({required String id}) async {
    GetBedRequest request = GetBedRequest(id: id);
    GetBedResponse response = await bedService.getBed(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    return Bed(
      id: response.id,
      name: response.name,
      roomId: response.roomId,
    );
  }

  Future<List<Bed>> getBeds() async {
    GetBedsRequest request = GetBedsRequest();
    GetBedsResponse response = await bedService.getBeds(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    List<Bed> beds = response.beds
        .map((bed) => Bed(
              id: bed.id,
              name: bed.name,
              roomId: bed.roomId,
            ))
        .toList();

    return beds;
  }

  Future<List<Bed>> getBedsByRoom({required String roomId}) async {
    GetBedsByRoomRequest request = GetBedsByRoomRequest(roomId: roomId);
    GetBedsByRoomResponse response = await bedService.getBedsByRoom(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    List<Bed> beds = response.beds
        .map((bed) => Bed(
              id: bed.id,
              name: bed.name,
              roomId: roomId,
            ))
        .toList();

    return beds;
  }

  Future<RoomWithBedFlat> getBedAndRoomByPatient({required String patientId}) async {
    GetBedByPatientRequest request = GetBedByPatientRequest(patientId: patientId);
    GetBedByPatientResponse response = await bedService.getBedByPatient(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    return RoomWithBedFlat(
      bed: Bed(
        id: response.bed.id,
        name: response.bed.name,
        roomId: response.room.id,
      ),
      room: RoomWithWardId(id: response.room.id, name: response.room.name, wardId: response.room.wardId),
    );
  }

  Future<Bed> create({required String roomId, required String name}) async {
    CreateBedRequest request = CreateBedRequest(roomId: roomId, name: name);
    CreateBedResponse response = await bedService.createBed(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    return Bed(id: response.id, name: name, roomId: roomId);
  }

  Future<void> update({
    required String id,
    String? name,
  }) async {
    UpdateBedRequest request = UpdateBedRequest(id: id, name: name);
    await bedService.updateBed(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );
  }

  Future<bool> delete({required String id}) async {
    DeleteBedRequest request = DeleteBedRequest(id: id);
    await bedService.deleteBed(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );
    return true;
  }
}
