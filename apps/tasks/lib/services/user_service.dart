import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/user_svc/v1/user_svc.pbgrpc.dart';
import 'package:tasks/services/grpc_client_svc.dart';
import '../dataclasses/user.dart';

/// The GRPC Service for [User]s
///
/// Provides queries and requests that load or alter [User] objects on the server
/// The server is defined in the underlying [GRPCClientService]
class UserService {
  /// The GRPC ServiceClient which handles GRPC
  UserServiceClient userService = GRPCClientService.getUserServiceClient;

  /// Loads the [User]s by it's identifier
  Future<User> getUser({String? id}) async {
    ReadPublicProfileRequest request = ReadPublicProfileRequest(id: id);
    ReadPublicProfileResponse response = await userService.readPublicProfile(
      request,
      options: CallOptions(metadata: GRPCClientService().getUserServiceMetaData()),
    );

    return User(
      id: response.id,
      name: response.name,
      nickName: response.nickname,
      profile: Uri.parse(response.avatarUrl),
    );
  }
}
