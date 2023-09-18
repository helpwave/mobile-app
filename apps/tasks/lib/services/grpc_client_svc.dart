import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/patient_svc.pbgrpc.dart';
import 'package:tasks/util/auth_interceptor.dart';

const apiURL = "api.helpwave.de";

class GRPCClientService {
  static final taskServiceChannel = ClientChannel(
    apiURL,
    port: 8080, // TODO add the correct port
  );
  static final userServiceChannel = ClientChannel(
    "$apiURL/user-svc",
  );

  static get getPatientServiceClient => PatientServiceClient(taskServiceChannel,interceptors: [AuthInterceptor()]);
}
