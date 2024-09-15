import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/bed_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/offline/offline_client_store.dart';
import 'package:helpwave_service/src/api/offline/util.dart';
import 'package:helpwave_service/src/api/tasks/data_types/bed.dart';
import 'package:helpwave_util/lists.dart';

class BedUpdate {
  String id;
  String? name;

  BedUpdate({required this.id, required this.name});
}

class BedOfflineService {
  List<BedWithRoomId> beds = [];

  BedWithRoomId? findBed(String id) {
    int index = OfflineClientStore().bedStore.beds.indexWhere((value) => value.id == id);
    if (index == -1) {
      return null;
    }
    return beds[index];
  }

  List<BedWithRoomId> findBeds([String? roomId]) {
    final valueStore = OfflineClientStore().bedStore;
    if (roomId == null) {
      return valueStore.beds;
    }
    return valueStore.beds.where((value) => value.roomId == roomId).toList();
  }

  void create(BedWithRoomId bed) {
    OfflineClientStore().bedStore.beds.add(bed);
  }

  void update(BedUpdate bed) {
    final valueStore = OfflineClientStore().bedStore;
    bool found = false;

    valueStore.beds = valueStore.beds.map((value) {
      if (value.id == bed.id) {
        found = true;
        return BedWithRoomId(id: bed.id, name: bed.name ?? value.name, roomId: value.roomId);
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('UpdateBed: Could not find bed with id ${bed.id}');
    }
  }

  void delete(String bedId) {
    final valueStore = OfflineClientStore().bedStore;
    valueStore.beds = valueStore.beds.where((value) => value.id != bedId).toList();
    // TODO: Cascade delete to bed-bound templates
  }
}

class BedServicePromiseClient extends BedServiceClient {
  BedServicePromiseClient(super.channel);

  @override
  ResponseFuture<GetBedResponse> getBed(GetBedRequest request, {CallOptions? options}) {
    final bed = OfflineClientStore().bedStore.findBed(request.id);

    if (bed == null) {
      throw "Bed with bed id ${request.id} not found";
    }

    final response = GetBedResponse()
      ..id = bed.id
      ..name = bed.name
      ..roomId = bed.roomId;

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetBedsResponse> getBeds(GetBedsRequest request, {CallOptions? options}) {
    final beds = OfflineClientStore().bedStore.findBeds();
    final bedsList = beds.map((bed) => GetBedsResponse_Bed(id: bed.id, name: bed.name, roomId: bed.roomId)).toList();

    final response = GetBedsResponse(beds: bedsList);

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetBedByPatientResponse> getBedByPatient(GetBedByPatientRequest request, {CallOptions? options}) {
    final patient = OfflineClientStore().patientStore.findPatient(request.patientId);
    if (patient == null) {
      throw "Patient with id ${request.patientId} not found";
    }
    if (!patient.hasBed) {
      throw "Patient with id ${request.patientId} has no bed";
    }
    final bed = OfflineClientStore().bedStore.findBed(patient.bedId!);
    if (bed == null) {
      throw "Inconsistent Data: Bed with id ${patient.bedId} not found";
    }
    final room = OfflineClientStore().roomStore.findRoom(bed.roomId);
    if (room == null) {
      throw "Inconsistent Data: Room with id ${bed.roomId} not found";
    }
    final response = GetBedByPatientResponse(
      bed: GetBedByPatientResponse_Bed(id: bed.id, name: bed.name),
      room: GetBedByPatientResponse_Room(id: room.id, name: room.name, wardId: room.wardId),
    );
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetBedsByRoomResponse> getBedsByRoom(GetBedsByRoomRequest request, {CallOptions? options}) {
    final beds = OfflineClientStore().bedStore.findBeds(request.roomId);
    final response =
        GetBedsByRoomResponse(beds: beds.map((bed) => GetBedsByRoomResponse_Bed(id: bed.id, name: bed.name)));
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<CreateBedResponse> createBed(CreateBedRequest request, {CallOptions? options}) {
    final newBed = BedWithRoomId(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: request.name,
      roomId: request.roomId,
    );

    OfflineClientStore().bedStore.create(newBed);

    final response = CreateBedResponse()..id = newBed.id;

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<BulkCreateBedsResponse> bulkCreateBeds(BulkCreateBedsRequest request, {CallOptions? options}) {
    final beds = range(0, request.amountOfBeds)
        .map((index) => BedWithRoomId(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: "New Bed ${index + 1}",
              roomId: request.roomId,
            ))
        .toList();

    for (var bed in beds) {
      OfflineClientStore().bedStore.create(bed);
    }

    final response =
        BulkCreateBedsResponse(beds: beds.map((bed) => BulkCreateBedsResponse_Bed(id: bed.id, name: bed.name)));

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<UpdateBedResponse> updateBed(UpdateBedRequest request, {CallOptions? options}) {
    final update = BedUpdate(
      id: request.id,
      name: request.name,
    );

    OfflineClientStore().bedStore.update(update);

    final response = UpdateBedResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<DeleteBedResponse> deleteBed(DeleteBedRequest request, {CallOptions? options}) {
    OfflineClientStore().bedStore.delete(request.id);

    final response = DeleteBedResponse();
    return MockResponseFuture.value(response);
  }
}
