import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/ward_svc.pbgrpc.dart';
import 'package:tasks/dataclasses/ward.dart';
import 'package:tasks/services/grpc_client_svc.dart';

/// The GRPC Service for [Ward]s
///
/// Provides queries and requests that load or alter [Ward] objects on the server
/// The server is defined in the underlying [GRPCClientService]
class WardService {
  /// The GRPC ServiceClient which handles GRPC
  WardServiceClient wardService = GRPCClientService.getWardServiceClient;

  /// Loads a [Ward] by its identifier
  Future<Ward> getWard({required String id}) async {
    GetWardRequest request = GetWardRequest(id: id);
    GetWardResponse response = await wardService.getWard(
      request,
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return Ward(
      id: response.id,
      name: response.name,
      organizationId: response.organizationId,
    );
  }

  /// Loads the wards in the current organization
  Future<List<WardOverview>> getWardOverviews({String? organizationId}) async {
    GetWardOverviewsRequest request = GetWardOverviewsRequest();
    GetWardOverviewsResponse response = await wardService.getWardOverviews(
      request,
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData(organizationId: organizationId)),
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
