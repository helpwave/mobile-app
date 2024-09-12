import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/user_svc/v1/user_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/user_svc/v1/organization_svc.pbgrpc.dart';
import 'package:helpwave_service/src/auth/index.dart';

/// A bundling of all User API services which can be used and are configured
///
/// Make sure to set the [apiURL] to use the services
class UserAPIServices {
  /// The api URL used
  static String? apiUrl;

  static ClientChannel get serviceChannel {
    assert(UserAPIServices.apiUrl != null);
    return ClientChannel(
      UserAPIServices.apiUrl!,
    );
  }

  static Map<String, String> getMetaData({String? organizationId}) {
    var metaData = {
      ...AuthenticationUtility.authMetaData,
      "dapr-app-id": "user-svc",
    };

    if (organizationId != null) {
      metaData["X-Organization"] = organizationId;
    }

    return metaData;
  }

  static UserServiceClient get userServiceClient => UserServiceClient(serviceChannel);

  static OrganizationServiceClient get organizationServiceClient => OrganizationServiceClient(serviceChannel);
}
