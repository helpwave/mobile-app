import 'package:grpc/grpc.dart';

// TODO change later to api or better make it configurable
const apiURL = "staging.api.helpwave.de";

// TODO later fetch from [AuthService]
const token = "eyJzdWIiOiIxODE1OTcxMy01ZDRlLTRhZDUtOTRhZC1mYmI2YmIxNDc5ODQiLCJlbWFpbCI6InRlc3RpbmUudGVzdEBoZWxwd2F2ZS"
    "5kZSIsIm5hbWUiOiJUZXN0aW5lIFRlc3QiLCJuaWNrbmFtZSI6InRlc3RpbmUudGVzdCIsIm9yZ2FuaXphdGlvbnMiOlsiM2IyNWM2ZjUtNDcwNS00MDc0LTlmYzYtYTUwYzI4ZWJhNDA2Il19";

class GRPCClientService {
  static final serviceChannel = ClientChannel(
    apiURL,
  );

  // TODO later fetch from [AuthService]
  Map<String,String> get authMetaData  => {
    "Authorization": "Bearer $token",
  };

  String get fallbackOrganizationId => "3b25c6f5-4705-4074-9fc6-a50c28eba406";

  Map<String,String> getTaskServiceMetaData() {
    return {
      ...authMetaData,
      "dapr-app-id": "impulse-svc",
    };
  }

  // TODO when backend exists
  // static ImpulseServiceClient get getPatientServiceClient => PatientServiceClient(serviceChannel);
}
