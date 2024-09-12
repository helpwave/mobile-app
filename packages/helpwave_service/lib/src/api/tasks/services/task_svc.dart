import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/google/protobuf/timestamp.pb.dart';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/task_svc.pbgrpc.dart';
import '../util/task_status_mapping.dart';

/// The GRPC Service for [Task]s
///
/// Provides queries and requests that load or alter [Task] objects on the server
/// The server is defined in the underlying [TasksAPIServices]
class TaskService {
  /// The GRPC ServiceClient which handles GRPC
  TaskServiceClient taskService = TasksAPIServices.taskServiceClient;

  /// Loads the [Task]s by a [Patient] identifier
  Future<List<Task>> getTasksByPatient({String? patientId}) async {
    GetTasksByPatientRequest request = GetTasksByPatientRequest(patientId: patientId);
    GetTasksByPatientResponse response = await taskService.getTasksByPatient(
      request,
      options: CallOptions(metadata: TasksAPIServices().getMetaData()),
    );

    return response.tasks
        .map((task) => Task(
              id: task.id,
              name: task.name,
              notes: task.description,
              isPublicVisible: task.public,
              status: GRPCTypeConverter.taskStatusFromGRPC(task.status),
              assignee: task.assignedUserId,
              dueDate: task.dueAt.toDateTime(),
              subtasks: task.subtasks
                  .map((subtask) => Subtask(
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
      options: CallOptions(metadata: TasksAPIServices().getMetaData()),
    );

    return TaskWithPatient(
      id: response.id,
      name: response.name,
      notes: response.description,
      isPublicVisible: response.public,
      status:  GRPCTypeConverter.taskStatusFromGRPC(response.status),
      assignee: response.assignedUserId,
      dueDate: response.dueAt.toDateTime(),
      patient: PatientMinimal(id: response.patient.id, name: response.patient.humanReadableIdentifier),
      subtasks: response.subtasks
          .map((subtask) => Subtask(
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
      initialStatus:  GRPCTypeConverter.taskStatusToGRPC(task.status),
      dueAt: task.dueDate != null ? Timestamp.fromDateTime(task.dueDate!) : null,
      patientId: !task.patient.isCreating ? task.patient.id : null,
      public: task.isPublicVisible,
    );
    CreateTaskResponse response = await taskService.createTask(
      request,
      options: CallOptions(metadata: TasksAPIServices().getMetaData()),
    );

    return response.id;
  }

  /// Assign a [Task] to a [User]
  Future<void> assignToUser({required String taskId, required String userId}) async {
    AssignTaskRequest request = AssignTaskRequest(taskId: taskId, userId: userId);
    AssignTaskResponse response = await taskService.assignTask(
      request,
      options: CallOptions(metadata: TasksAPIServices().getMetaData()),
    );

    if (!response.isInitialized()) {
      // Handle error
    }
  }

  /// Add a [Subtask] to a [Task]
  Future<Subtask> createSubTask({required String taskId, required Subtask subTask}) async {
    CreateSubtaskRequest request = CreateSubtaskRequest(
        taskId: taskId,
        subtask: CreateSubtaskRequest_Subtask(
          name: subTask.name,
          done: subTask.isDone,
        ));
    CreateSubtaskResponse response = await taskService.createSubtask(
      request,
      options: CallOptions(metadata: TasksAPIServices().getMetaData()),
    );

    return Subtask(
      id: response.subtaskId,
      name: subTask.name,
      isDone: subTask.isDone,
    );
  }

  /// Delete a [Subtask] by its identifier
  Future<bool> deleteSubTask({required String subtaskId, required String taskId}) async {
    DeleteSubtaskRequest request = DeleteSubtaskRequest(subtaskId: subtaskId, taskId: taskId);
    DeleteSubtaskResponse response = await taskService.deleteSubtask(
      request,
      options: CallOptions(metadata: TasksAPIServices().getMetaData()),
    );

    return response.isInitialized();
  }

  /// Update a [Subtask]'s
  Future<bool> updateSubtask({required Subtask subtask, required taskId}) async {
    UpdateSubtaskRequest request = UpdateSubtaskRequest(
      taskId: taskId,
      subtaskId: subtask.id,
      subtask: UpdateSubtaskRequest_Subtask(done: subtask.isDone, name: subtask.name),
    );
    UpdateSubtaskResponse response = await taskService.updateSubtask(
      request,
      options: CallOptions(metadata: TasksAPIServices().getMetaData()),
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
      status: GRPCTypeConverter.taskStatusToGRPC(task.status),
    );

    UpdateTaskResponse response = await taskService.updateTask(
      request,
      options: CallOptions(metadata: TasksAPIServices().getMetaData()),
    );

    return response.isInitialized();
  }
}
