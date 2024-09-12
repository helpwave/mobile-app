import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/ward_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/tasks/data_types/index.dart';
import 'package:helpwave_service/src/api/tasks/tasks_api_services.dart';

/// The Service for [Ward]s
///
/// Provides queries and requests that load or alter [Ward] objects on the server
/// The server is defined in the underlying [TasksAPIServices]
class WardService {
  /// The GRPC ServiceClient which handles GRPC
  WardServiceClient wardService = TasksAPIServices.wardServiceClient;

  /// Loads a [WardMinimal] by its identifier
  Future<WardMinimal> getWard({required String id}) async {
    GetWardRequest request = GetWardRequest(id: id);
    GetWardResponse response = await wardService.getWard(
      request,
      options: CallOptions(metadata: TasksAPIServices().getMetaData()),
    );

    return WardMinimal(
      id: response.id,
      name: response.name,
    );
  }

  /// Loads the wards in the current organization
  Future<List<WardOverview>> getWardOverviews({String? organizationId}) async {
    GetWardOverviewsRequest request = GetWardOverviewsRequest();
    GetWardOverviewsResponse response = await wardService.getWardOverviews(
      request,
      options: CallOptions(metadata: TasksAPIServices().getMetaData(organizationId: organizationId)),
    );

    return response.wards
        .map((ward) => WardOverview(
              id: ward.id,
              name: ward.name,
              bedCount: ward.bedCount,
              tasksInTodo: ward.tasksTodo,
              tasksInInProgress: ward.tasksInProgress,
              tasksInDone: ward.tasksDone,
            ))
        .toList();
  }

  // TODO ward requests
}
