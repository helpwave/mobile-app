import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/patient_svc.pbgrpc.dart';

// TODO change later to api or better make it configurable
const apiURL = "staging.api.helpwave.de";

// TODO later fetch from [AuthService]
const token = "eyJzdWIiOiIxODE1OTcxMy01ZDRlLTRhZDUtOTRhZC1mYmI2YmIxNDc5ODQiLCJlbWFpbCI6InRlc3RpbmUudGVzdEBoZWxwd2F2ZS"
    "5kZSIsIm5hbWUiOiJUZXN0aW5lIFRlc3QiLCJuaWNrbmFtZSI6InRlc3RpbmUudGVzdCIsIm9yZ2FuaXphdGlvbnMiOlsiM2IyNWM2ZjUtNDcwNS00MDc0LTlmYzYtYTUwYzI4ZWJhNDA2Il19";

class GRPCClientService {
  static final taskServiceChannel = ClientChannel(
    apiURL,
  );
  static final userServiceChannel = ClientChannel(
    apiURL,
  );

  // TODO later fetch from [AuthService]
  Map<String,String> get authMetaData  => {
    "Authorization": "Bearer $token",
  };

  String get fallbackOrganizationId => "3b25c6f5-4705-4074-9fc6-a50c28eba406";

  Map<String,String> getTaskServiceMetaData({String? organizationId}) {
    return {
      ...authMetaData,
      "dapr-app-id": "task-svc",
      "X-Organization": organizationId ?? fallbackOrganizationId,
    };
  }

  Map<String,String> getUserServiceMetaData({String? organizationId}) {
    return {
      ...authMetaData,
      "dapr-app-id": "user-svc",
      "X-Organization": organizationId ?? fallbackOrganizationId,
    };
  }

  static PatientServiceClient get getPatientServiceClient => PatientServiceClient(taskServiceChannel);
}
