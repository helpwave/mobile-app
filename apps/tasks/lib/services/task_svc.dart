import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/task_svc.pbgrpc.dart';
import 'package:tasks/dataclasses/patient.dart';
import 'package:tasks/dataclasses/subtask.dart';
import 'package:tasks/services/grpc_client_svc.dart';
import 'package:tasks/util/task_status_mapping.dart';
import '../dataclasses/task.dart';

/// The GRPC Service for [Task]s
///
/// Provides queries and requests that load or alter [Task] objects on the server
/// The server is defined in the underlying [GRPCClientService]
class TaskService {
  /// The GRPC ServiceClient which handles GRPC
  TaskServiceClient taskService = GRPCClientService.getTaskServiceClient;

  /// Loads the [Task]s by a [Patient] identifier
  Future<List<Task>> getTasksByPatient({String? patientId}) async {
    GetTasksByPatientRequest request =
        GetTasksByPatientRequest(patientId: patientId);
    GetTasksByPatientResponse response = await taskService.getTasksByPatient(
      request,
      options:
          CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return response.tasks
        .map((task) => Task(
              id: task.id,
              name: task.name,
              notes: task.description,
              isPublicVisible: task.public,
              status: taskStatusMapping[task.status]!,
              assignee: task.assignedUserId,
              dueDate: task.dueAt.toDateTime(),
              subtasks: task.subtasks
                  .map((subtask) => SubTask(
                        id: subtask.id,
                        name: subtask.name,
                        isDone: subtask.done,
                      ))
                  .toList(),
            ))
        .toList();
  }

  /// Loads the [Task]s by it's identifier
  Future<Task> getTask({String? id}) async {
    GetTaskRequest request = GetTaskRequest(id: id);
    GetTaskResponse response = await taskService.getTask(
      request,
      options:
          CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return Task(
      id: response.id,
      name: response.name,
      notes: response.description,
      isPublicVisible: response.public,
      status: taskStatusMapping[response.status]!,
      assignee: response.assignedUserId,
      dueDate: response.dueAt.toDateTime(),
      subtasks: response.subtasks
          .map((subtask) => SubTask(
                id: subtask.id,
                name: subtask.name,
                isDone: subtask.done,
              ))
          .toList(),
    );
  }
}
