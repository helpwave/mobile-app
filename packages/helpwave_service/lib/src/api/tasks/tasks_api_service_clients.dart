import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/ward_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/patient_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/room_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/task_svc.pbgrpc.dart';
import 'package:helpwave_service/src/auth/index.dart';

/// The Underlying GrpcService it provides other clients and the correct metadata for the requests
class TasksAPIServiceClients {
  /// The api URL used
  static String? apiUrl;

  static ClientChannel get serviceChannel {
    assert(TasksAPIServiceClients.apiUrl != null);
    return ClientChannel(
      TasksAPIServiceClients.apiUrl!,
    );
  }

  Map<String, String> getMetaData({String? organizationId}) {
    var metaData = {
      ...AuthenticationUtility.authMetaData,
      "dapr-app-id": "task-svc",
    };

    if (organizationId != null) {
      metaData["X-Organization"] = organizationId;
    } else {
      metaData["X-Organization"] = AuthenticationUtility.fallbackOrganizationId!;
    }

    return metaData;
  }

  static PatientServiceClient get patientServiceClient => PatientServiceClient(serviceChannel);

  static WardServiceClient get wardServiceClient => WardServiceClient(serviceChannel);

  static RoomServiceClient get roomServiceClient => RoomServiceClient(serviceChannel);

  static TaskServiceClient get taskServiceClient => TaskServiceClient(serviceChannel);
}
