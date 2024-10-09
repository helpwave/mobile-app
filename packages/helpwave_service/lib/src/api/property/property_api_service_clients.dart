import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/property_svc/v1/property_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/property_svc/v1/property_set_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/property_svc/v1/property_value_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/property_svc/v1/property_views_svc.pbgrpc.dart';
import 'package:helpwave_service/src/auth/index.dart';

/// The Underlying GrpcService it provides other clients and the correct metadata for the requests
class PropertyAPIServiceClients {
  PropertyAPIServiceClients._privateConstructor();

  static final PropertyAPIServiceClients _instance = PropertyAPIServiceClients._privateConstructor();

  factory PropertyAPIServiceClients() => _instance;

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
      "dapr-app-id": "property-svc",
    };

    if (organizationId != null) {
      metaData["X-Organization"] = organizationId;
    } else {
      metaData["X-Organization"] = AuthenticationUtility.fallbackOrganizationId!;
    }

    return metaData;
  }

  // TODO add offline clients here
  PropertyServiceClient get propertyServiceClient =>
      offlineMode ? PropertyServiceClient(serviceChannel) : PropertyServiceClient(serviceChannel);

  PropertyValueServiceClient get propertyValueServiceClient =>
      offlineMode ? PropertyValueServiceClient(serviceChannel) : PropertyValueServiceClient(serviceChannel);

  PropertyViewsServiceClient get propertyViewsServiceClient =>
      offlineMode ? PropertyViewsServiceClient(serviceChannel) : PropertyViewsServiceClient(serviceChannel);

  PropertySetServiceClient get propertySetServiceClient =>
      offlineMode ? PropertySetServiceClient(serviceChannel) : PropertySetServiceClient(serviceChannel);

}
