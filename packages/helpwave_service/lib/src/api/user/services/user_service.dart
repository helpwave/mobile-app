import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/user_svc/v1/user_svc.pbgrpc.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/src/api/user/user_api_service_clients.dart';
import '../data_types/index.dart';

/// The GRPC Service for [User]s
///
/// Provides queries and requests that load or alter [User] objects on the server
/// The server is defined in the underlying [UserAPIServiceClients]
class UserService {
  /// The GRPC ServiceClient which handles GRPC
  UserServiceClient userService = UserAPIServiceClients().userServiceClient;

  /// Loads the [User]s by it's identifier
  Future<User> getUser({String? id}) async {
    ReadPublicProfileRequest request = ReadPublicProfileRequest(id: id);
    ReadPublicProfileResponse response = await userService.readPublicProfile(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(
          organizationId: AuthenticationUtility.fallbackOrganizationId,
        ),
      ),
    );

    return User(
      id: response.id,
      name: response.name,
      nickName: response.nickname,
      email: "no-email", // TODO replace this
      profileUrl: Uri.parse(response.avatarUrl),
    );
  }
}
