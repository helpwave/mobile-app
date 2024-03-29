import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/patient_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/room_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/task_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/ward_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/proto/services/user_svc/v1/organization_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/proto/services/user_svc/v1/user_svc.pbgrpc.dart';
import 'package:tasks/config/config.dart';
import 'package:tasks/services/current_ward_svc.dart';
import 'user_session_service.dart';

/// The Underlying GrpcService it provides other clients and the correct metadata for the requests
class GRPCClientService {
  static final taskServiceChannel = ClientChannel(
    usedAPIURL,
  );
  static final userServiceChannel = ClientChannel(
    usedAPIURL,
  );

  final UserSessionService authService = UserSessionService();

  Map<String, String> get authMetaData {
    if (authService.isLoggedIn) {
      return {
        "Authorization": "Bearer ${UserSessionService().identity?.idToken}",
      };
    }
    // Maybe throw a error instead
    return {};
  }

  String? get fallbackOrganizationId =>
      // Maybe throw a error instead for the last case
      CurrentWardService().currentWard?.organizationId ?? authService.identity?.firstOrganization;

  Map<String, String> getTaskServiceMetaData({String? organizationId}) {
    var metaData = {
      ...authMetaData,
      "dapr-app-id": "task-svc",
    };

    if (organizationId != null) {
      metaData["X-Organization"] = organizationId;
    } else {
      metaData["X-Organization"] = fallbackOrganizationId!;
    }

    return metaData;
  }

  Map<String, String> getUserServiceMetaData({String? organizationId}) {
    var metaData = {
      ...authMetaData,
      "dapr-app-id": "user-svc",
    };

    if (organizationId != null) {
      metaData["X-Organization"] = organizationId;
    }

    return metaData;
  }

  static PatientServiceClient get getPatientServiceClient => PatientServiceClient(taskServiceChannel);

  static WardServiceClient get getWardServiceClient => WardServiceClient(taskServiceChannel);

  static RoomServiceClient get getRoomServiceClient => RoomServiceClient(taskServiceChannel);

  static TaskServiceClient get getTaskServiceClient => TaskServiceClient(taskServiceChannel);

  static UserServiceClient get getUserServiceClient => UserServiceClient(userServiceChannel);

  static OrganizationServiceClient get getOrganizationServiceClient => OrganizationServiceClient(userServiceChannel);
}
