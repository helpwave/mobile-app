import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/patient_svc.pbgrpc.dart';
import 'package:tasks/util/auth_interceptor.dart';

// TODO change later to api or better make it configurable
const apiURL = "staging.api.helpwave.de";

class GRPCClientService {
  static final taskServiceChannel = ClientChannel(
    apiURL,
  );
  static final userServiceChannel = ClientChannel(
    "$apiURL/user-svc",
  );

  static get getPatientServiceClient => PatientServiceClient(taskServiceChannel,interceptors: [AuthInterceptor()]);
}
