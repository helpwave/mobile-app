import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/ward_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/patient_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/room_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/task_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/patient_offline_client.dart';
import 'package:helpwave_service/src/api/tasks/offline_clients/ward_offline_client.dart';
import 'package:helpwave_service/src/auth/index.dart';

import 'offline_clients/room_offline_client.dart';
import 'offline_clients/task_offline_client.dart';

/// The Underlying GrpcService it provides other clients and the correct metadata for the requests
class TasksAPIServiceClients {
  TasksAPIServiceClients._privateConstructor();

  static final TasksAPIServiceClients _instance = TasksAPIServiceClients._privateConstructor();

  factory TasksAPIServiceClients() => _instance;

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
      "dapr-app-id": "task-svc",
    };

    if (organizationId != null) {
      metaData["X-Organization"] = organizationId;
    } else {
      metaData["X-Organization"] = AuthenticationUtility.fallbackOrganizationId!;
    }

    return metaData;
  }

  PatientServiceClient get patientServiceClient =>
      offlineMode ? PatientOfflineClient(serviceChannel) : PatientServiceClient(serviceChannel);

  WardServiceClient get wardServiceClient =>
      offlineMode ? WardOfflineClient(serviceChannel) : WardServiceClient(serviceChannel);

  RoomServiceClient get roomServiceClient =>
      offlineMode ? RoomOfflineClient(serviceChannel) : RoomServiceClient(serviceChannel);

  TaskServiceClient get taskServiceClient =>
      offlineMode ? TaskOfflineClient(serviceChannel) : TaskServiceClient(serviceChannel);
}
