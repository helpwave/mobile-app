import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/ward_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/offline/offline_client_store.dart';
import 'package:helpwave_service/src/api/offline/util.dart';
import 'package:helpwave_service/src/api/tasks/index.dart';

class WardUpdate {
  String id;
  String? name;

  WardUpdate({required this.id, required this.name});
}

class WardOfflineService {
  List<Ward> wards = [];

  Ward? findWard(String id) {
    int index = OfflineClientStore().wardStore.wards.indexWhere((value) => value.id == id);
    if (index == -1) {
      return null;
    }
    return wards[index];
  }

  List<Ward> findWards([String? organizationId]) {
    final valueStore = OfflineClientStore().wardStore;
    if (organizationId == null) {
      return valueStore.wards;
    }
    return valueStore.wards.where((value) => value.organizationId == organizationId).toList();
  }

  void create(Ward ward) {
    OfflineClientStore().wardStore.wards.add(ward);
  }

  void update(WardUpdate ward) {
    final valueStore = OfflineClientStore().wardStore;
    bool found = false;

    valueStore.wards = valueStore.wards.map((value) {
      if (value.id == ward.id) {
        found = true;
        return Ward(id: ward.id, name: ward.name ?? value.name, organizationId: value.organizationId);
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('UpdateWard: Could not find ward with id ${ward.id}');
    }
  }

  void delete(String wardId) {
    final valueStore = OfflineClientStore().wardStore;
    valueStore.wards = valueStore.wards.where((value) => value.id != wardId).toList();
    OfflineClientStore().roomStore.findRooms(wardId).forEach((element) {
      OfflineClientStore().roomStore.delete(element.id);
    });
    final taskTemplates = OfflineClientStore().taskTemplateStore.findTaskTemplates(wardId);
    for (var element in taskTemplates) {
      OfflineClientStore().taskTemplateStore.delete(element.id);
    }
  }
}

class WardOfflineClient extends WardServiceClient {
  WardOfflineClient(super.channel);

  @override
  ResponseFuture<GetWardResponse> getWard(GetWardRequest request, {CallOptions? options}) {
    final ward = OfflineClientStore().wardStore.findWard(request.id);

    if (ward == null) {
      throw "Ward with ward id ${request.id} not found";
    }

    final response = GetWardResponse()
      ..id = ward.id
      ..name = ward.name;

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetWardDetailsResponse> getWardDetails(GetWardDetailsRequest request, {CallOptions? options}) {
    final ward = OfflineClientStore().wardStore.findWard(request.id);

    if (ward == null) {
      throw "Ward with ward id ${request.id} not found";
    }

    final rooms = OfflineClientStore().roomStore.findRooms(ward.id).map((room) {
      final beds = OfflineClientStore()
          .bedStore
          .findBeds(room.id)
          .map((bed) => GetWardDetailsResponse_Bed(id: bed.id, name: bed.name))
          .toList();

      return GetWardDetailsResponse_Room()
        ..id = room.id
        ..name = room.name
        ..beds.addAll(beds);
    }).toList();

    final response = GetWardDetailsResponse(
      id: ward.id,
      name: ward.name,
      rooms: rooms,
      taskTemplates: OfflineClientStore()
          .taskTemplateStore
          .findTaskTemplates(ward.id)
          .map((template) => GetWardDetailsResponse_TaskTemplate(
                id: template.id,
                name: template.name,
                subtasks: OfflineClientStore().taskTemplateSubtaskStore.findTemplateSubtasks(template.id).map(
                      (subtask) => GetWardDetailsResponse_Subtask(id: subtask.id, name: subtask.name),
                    ),
              )),
    );

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetWardsResponse> getWards(GetWardsRequest request, {CallOptions? options}) {
    final wards = OfflineClientStore().wardStore.findWards();
    final wardsList = wards
        .map((ward) => GetWardsResponse_Ward()
          ..id = ward.id
          ..name = ward.name)
        .toList();

    final response = GetWardsResponse()..wards.addAll(wardsList);

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetRecentWardsResponse> getRecentWards(GetRecentWardsRequest request, {CallOptions? options}) {
    final wards = OfflineClientStore().wardStore.findWards();
    final wardsList = wards.map((ward) {
      final rooms = OfflineClientStore().roomStore.findRooms(ward.id);
      final beds =
          rooms.map((room) => OfflineClientStore().bedStore.findBeds(room.id)).expand((element) => element).toList();
      List<PatientWithBedId> patients = [];
      for (var bed in beds) {
        final patient = OfflineClientStore().patientStore.findPatient(bed.id);
        if (patient != null) {
          patients.add(patient);
        }
      }
      List<Task> tasks = patients
          .map((patient) => OfflineClientStore().taskStore.findTasks(patient.id))
          .expand((element) => element)
          .toList();
      return GetRecentWardsResponse_Ward(
        id: ward.id,
        name: ward.name,
        bedCount: beds.length,
        tasksDone: tasks.where((element) => element.status == TaskStatus.done).length,
        tasksInProgress: tasks.where((element) => element.status == TaskStatus.inProgress).length,
        tasksTodo: tasks.where((element) => element.status == TaskStatus.todo).length,
      );
    });
    final response = GetRecentWardsResponse()..wards.addAll(wardsList);

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetWardOverviewsResponse> getWardOverviews(GetWardOverviewsRequest request, {CallOptions? options}) {
    final wards = OfflineClientStore().wardStore.findWards();
    final wardsList = wards.map((ward) {
      final rooms = OfflineClientStore().roomStore.findRooms(ward.id);
      final beds =
          rooms.map((room) => OfflineClientStore().bedStore.findBeds(room.id)).expand((element) => element).toList();
      List<PatientWithBedId> patients = [];
      for (var bed in beds) {
        final patient = OfflineClientStore().patientStore.findPatient(bed.id);
        if (patient != null) {
          patients.add(patient);
        }
      }
      List<Task> tasks = patients
          .map((patient) => OfflineClientStore().taskStore.findTasks(patient.id))
          .expand((element) => element)
          .toList();
      return GetWardOverviewsResponse_Ward(
        id: ward.id,
        name: ward.name,
        bedCount: beds.length,
        tasksDone: tasks.where((element) => element.status == TaskStatus.done).length,
        tasksInProgress: tasks.where((element) => element.status == TaskStatus.inProgress).length,
        tasksTodo: tasks.where((element) => element.status == TaskStatus.todo).length,
      );
    });
    final response = GetWardOverviewsResponse(wards: wardsList);

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<CreateWardResponse> createWard(CreateWardRequest request, {CallOptions? options}) {
    final newWard = Ward(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: request.name,
      organizationId: 'organization', // TODO: Check organization
    );

    OfflineClientStore().wardStore.create(newWard);

    final response = CreateWardResponse()..id = newWard.id;

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<UpdateWardResponse> updateWard(UpdateWardRequest request, {CallOptions? options}) {
    final update = WardUpdate(
      id: request.id,
      name: request.name,
    );

    OfflineClientStore().wardStore.update(update);

    final response = UpdateWardResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<DeleteWardResponse> deleteWard(DeleteWardRequest request, {CallOptions? options}) {
    OfflineClientStore().wardStore.delete(request.id);

    final response = DeleteWardResponse();
    return MockResponseFuture.value(response);
  }
}
