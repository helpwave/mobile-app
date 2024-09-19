import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/user_svc/v1/user_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/user_svc/v1/organization_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/user/offline_clients/organization_offline_client.dart';
import 'package:helpwave_service/src/api/user/offline_clients/user_offline_client.dart';
import 'package:helpwave_service/src/auth/index.dart';

/// A bundling of all User API services which can be used and are configured
///
/// Make sure to set the [apiURL] to use the services
class UserAPIServiceClients {
  UserAPIServiceClients._privateConstructor();

  static final UserAPIServiceClients _instance = UserAPIServiceClients._privateConstructor();

  factory UserAPIServiceClients() => _instance;

  /// The api URL used
  String? apiUrl;

  bool offlineMode = false;

  ClientChannel get serviceChannel {
    assert(apiUrl != null);
    return ClientChannel(apiUrl!);
  }

  Map<String, String> getMetaData({String? organizationId}) {
    var metaData = {
      ...AuthenticationUtility.authMetaData,
      "dapr-app-id": "user-svc",
    };

    if (organizationId != null) {
      metaData["X-Organization"] = organizationId;
    }

    return metaData;
  }

  UserServiceClient get userServiceClient =>
      offlineMode ? UserOfflineClient(serviceChannel) : UserServiceClient(serviceChannel);

  OrganizationServiceClient get organizationServiceClient =>
      offlineMode ? OrganizationOfflineClient(serviceChannel) : OrganizationServiceClient(serviceChannel);
}
