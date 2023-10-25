import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/task_svc.pbgrpc.dart';
import 'package:tasks/dataclasses/subtask.dart';
import 'package:tasks/services/grpc_client_svc.dart';

import '../dataclasses/task.dart';

/// The GRPC Service for [Task]s
///
/// Provides queries and requests that load or alter [Task] objects on the server
/// The server is defined in the underlying [GRPCClientService]
class TaskService {
  /// The GRPC ServiceClient which handles GRPC
  TaskServiceClient taskService = GRPCClientService.getTaskServiceClient;

  /// Add a [SubTask] to a [Task]
  Future<SubTask> addSubTask(
      {required String taskId, required SubTask subTask}) async {
    AddSubTaskRequest request = AddSubTaskRequest(
      taskId: taskId,
      name: subTask.name,
      done: subTask.isDone,
    );
    AddSubTaskResponse response = await taskService.addSubTask(
      request,
      options:
          CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return SubTask(
      id: response.id,
      name: subTask.name,
      isDone: subTask.isDone,
    );
  }

  /// Delete a [SubTask] by its identifier
  Future<bool> deleteSubTask({required String id}) async {
    RemoveSubTaskRequest request = RemoveSubTaskRequest(id: id);
    RemoveSubTaskResponse response = await taskService.removeSubTask(
      request,
      options:
          CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return response.isInitialized();
  }

  /// Change a [SubTask]'s status to done by its identifier
  Future<bool> subtaskToDone({required String id}) async {
    SubTaskToDoneRequest request = SubTaskToDoneRequest(id: id);
    SubTaskToDoneResponse response = await taskService.subTaskToDone(
      request,
      options:
          CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return response.isInitialized();
  }

  /// Change a [SubTask]'s status to todo by its identifier
  Future<bool> subtaskToToDo({required String id}) async {
    SubTaskToToDoRequest request = SubTaskToToDoRequest(id: id);
    SubTaskToToDoResponse response = await taskService.subTaskToToDo(
      request,
      options:
          CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return response.isInitialized();
  }

  /// Change a [SubTask]'s status by its identifier
  Future<bool> changeSubtaskStatus({
    required String id,
    required isDone,
  }) async {
    if (isDone) {
      return subtaskToDone(id: id);
    } else {
      return subtaskToToDo(id: id);
    }
  }

  /// Update a [SubTask]'s
  Future<bool> updateSubTask({required SubTask subTask}) async {
    UpdateSubTaskRequest request = UpdateSubTaskRequest(
      id: subTask.id,
      name: subTask.name,
    );
    UpdateSubTaskResponse response = await taskService.updateSubTask(
      request,
      options:
          CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return response.isInitialized();
  }
}
