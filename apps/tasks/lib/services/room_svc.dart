import 'package:helpwave_proto_dart/proto/services/task_svc/v1/room_svc.pbgrpc.dart';
import 'package:tasks/services/grpc_client_svc.dart';

/// The GRPC Service for [Room]s
///
/// Provides queries and requests that load or alter [Room] objects on the server
/// The server is defined in the underlying [GRPCClientService]
class RoomService {
  /// The GRPC ServiceClient which handles GRPC
  RoomServiceClient roomService =
      GRPCClientService.getRoomServiceClient;

}
