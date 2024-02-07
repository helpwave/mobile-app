import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/google/protobuf/timestamp.pb.dart';
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
    GetTasksByPatientRequest request = GetTasksByPatientRequest(patientId: patientId);
    GetTasksByPatientResponse response = await taskService.getTasksByPatient(
      request,
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return response.tasks
        .map((task) => Task(
              id: task.id,
              name: task.name,
              notes: task.description,
              isPublicVisible: task.public,
              status: taskStatusMappingFromProto[task.status]!,
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
  Future<TaskWithPatient> getTask({String? id}) async {
    GetTaskRequest request = GetTaskRequest(id: id);
    GetTaskResponse response = await taskService.getTask(
      request,
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return TaskWithPatient(
      id: response.id,
      name: response.name,
      notes: response.description,
      isPublicVisible: response.public,
      status: taskStatusMappingFromProto[response.status]!,
      assignee: response.assignedUserId,
      dueDate: response.dueAt.toDateTime(),
      patient: PatientMinimal(id: response.patient.id, name: response.patient.name),
      subtasks: response.subtasks
          .map((subtask) => SubTask(
                id: subtask.id,
                name: subtask.name,
                isDone: subtask.done,
              ))
          .toList(),
    );
  }

  Future<String> createTask(TaskWithPatient task) async {
    CreateTaskRequest request = CreateTaskRequest(
      name: task.name,
      description: task.notes,
      initialStatus: taskStatusMappingToProto[task.status],
      dueAt: task.dueDate != null ? Timestamp.fromDateTime(task.dueDate!) : null,
      patientId: !task.patient.isCreating ? task.patient.id : null,
      public: task.isPublicVisible,
    );
    CreateTaskResponse response = await taskService.createTask(
      request,
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return response.id;
  }

  /// Assign a [Task] to a [User]
  Future<void> assignToUser({required String taskId, required String userId}) async {
    AssignTaskToUserRequest request = AssignTaskToUserRequest(id: taskId, userId: userId);
    AssignTaskToUserResponse response = await taskService.assignTaskToUser(
      request,
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    if (!response.isInitialized()) {
      // Handle error
    }
  }

  /// Add a [SubTask] to a [Task]
  Future<SubTask> addSubTask({required String taskId, required SubTask subTask}) async {
    AddSubTaskRequest request = AddSubTaskRequest(
      taskId: taskId,
      name: subTask.name,
      done: subTask.isDone,
    );
    AddSubTaskResponse response = await taskService.addSubTask(
      request,
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
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
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return response.isInitialized();
  }

  /// Change a [SubTask]'s status to done by its identifier
  Future<bool> subtaskToDone({required String id}) async {
    SubTaskToDoneRequest request = SubTaskToDoneRequest(id: id);
    SubTaskToDoneResponse response = await taskService.subTaskToDone(
      request,
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return response.isInitialized();
  }

  /// Change a [SubTask]'s status to todo by its identifier
  Future<bool> subtaskToToDo({required String id}) async {
    SubTaskToToDoRequest request = SubTaskToToDoRequest(id: id);
    SubTaskToToDoResponse response = await taskService.subTaskToToDo(
      request,
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
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
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return response.isInitialized();
  }

  Future<bool> updateTask(Task task) async {
    UpdateTaskRequest request = UpdateTaskRequest(
      id: task.id,
      name: task.name,
      description: task.notes,
      dueAt: task.dueDate != null ? Timestamp.fromDateTime(task.dueDate!) : null,
      public: task.isPublicVisible,
    );

    UpdateTaskResponse response = await taskService.updateTask(
      request,
      options: CallOptions(metadata: GRPCClientService().getTaskServiceMetaData()),
    );

    return response.isInitialized();
  }
}
