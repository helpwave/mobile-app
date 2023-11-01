import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/patient_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/room_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/task_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/proto/services/user_svc/v1/organization_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/proto/services/user_svc/v1/user_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/ward_svc.pbgrpc.dart';
import 'package:tasks/services/current_ward_svc.dart';

import 'auth_service.dart';

// TODO change later to api or better make it configurable
const apiURL = "api.helpwave.de";

// TODO later fetch from [AuthService]
const token = "eyJzdWIiOiIxODE1OTcxMy01ZDRlLTRhZDUtOTRhZC1mYmI2YmIxNDc5ODQiLCJlbWFpbCI6InRlc3RpbmUudGVzdEBoZWxwd2F2ZS"
    "5kZSIsIm5hbWUiOiJUZXN0aW5lIFRlc3QiLCJuaWNrbmFtZSI6InRlc3RpbmUudGVzdCIsIm9yZ2FuaXphdGlvbnMiOlsiM2IyNWM2ZjUtNDcwNS00MDc0LTlmYzYtYTUwYzI4ZWJhNDA2Il19";

/// The Underlying GrpcService it provides other clients and the correct metadata for the requests
class GRPCClientService {
  static final taskServiceChannel = ClientChannel(
    apiURL,
  );
  static final userServiceChannel = ClientChannel(
    apiURL,
  );

  Map<String, String> get authMetaData => {
        "Authorization": "Bearer ${AuthService().identity?.credential.idToken.toCompactSerialization() ?? token}",
      };

  String get fallbackOrganizationId =>
      CurrentWardService().currentWard?.organizationId ??
      AuthService().identity?.organizations[0] ??
      "3b25c6f5-4705-4074-9fc6-a50c28eba406";

  Map<String, String> getTaskServiceMetaData({String? organizationId}) {
    return {
      ...authMetaData,
      "dapr-app-id": "task-svc",
      "X-Organization": organizationId ?? fallbackOrganizationId,
    };
  }

  Map<String, String> getUserServiceMetaData({String? organizationId}) {
    return {
      ...authMetaData,
      "dapr-app-id": "user-svc",
      "X-Organization": organizationId ?? fallbackOrganizationId,
    };
  }

  static PatientServiceClient get getPatientServiceClient => PatientServiceClient(taskServiceChannel);

  static WardServiceClient get getWardServiceClient => WardServiceClient(taskServiceChannel);

  static RoomServiceClient get getRoomServiceClient => RoomServiceClient(taskServiceChannel);

  static TaskServiceClient get getTaskServiceClient => TaskServiceClient(taskServiceChannel);

  static UserServiceClient get getUserServiceClient => UserServiceClient(userServiceChannel);

  static OrganizationServiceClient get getOrganizationServiceClient => OrganizationServiceClient(userServiceChannel);
}
