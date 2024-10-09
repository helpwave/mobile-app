import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/property_svc/v1/property_value_svc.pb.dart';
import 'package:helpwave_proto_dart/services/property_svc/v1/property_views_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/property/data_types/property_view_filter_update.dart';
import 'package:helpwave_service/src/api/property/property_api_service_clients.dart';
import '../../../../property.dart';

/// The GRPC Service for [PropertyViewRules]s
///
/// Provides queries and requests that load or alter [PropertyViewRules] objects on the server
/// The server is defined in the underlying [PropertyAPIServiceClients]
class PropertyValueService {
  /// The GRPC ServiceClient which handles GRPC
  PropertyViewsServiceClient service = PropertyAPIServiceClients().propertyViewsServiceClient;

  Future<bool> updateViewRule({
    required PropertySubjectType subjectType,
    required String id,
    PropertyViewFilterUpdate? update = const PropertyViewFilterUpdate(),
  }) async {
    UpdatePropertyViewRuleRequest request = UpdatePropertyViewRuleRequest();
    switch (subjectType) {
      case PropertySubjectType.patient:
        request.patientMatcher = PatientPropertyMatcher(patientId: id);
        break;
      case PropertySubjectType.task:
        request.taskMatcher = TaskPropertyMatcher(wardId: id);
        break;
    }

    await service.updatePropertyViewRule(
      request,
      options: CallOptions(metadata: PropertyAPIServiceClients().getMetaData()),
    );

    return true;
  }
}
