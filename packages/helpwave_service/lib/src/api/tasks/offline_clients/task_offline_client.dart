import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/google/protobuf/timestamp.pb.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/task_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/offline/offline_client_store.dart';
import 'package:helpwave_service/src/api/offline/util.dart';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_service/src/api/tasks/util/task_status_mapping.dart';

class TaskUpdate {
  String id;
  String? name;
  String? notes;
  TaskStatus? status;
  bool? isPublicVisible;
  DateTime? dueDate;

  TaskUpdate({required this.id, this.name, this.notes, this.status, this.isPublicVisible, this.dueDate});
}

class SubtaskUpdate {
  String id;
  bool? isDone;
  String? name;

  SubtaskUpdate({required this.id, this.name, this.isDone});
}

class TaskOfflineService {
  List<Task> tasks = [];

  Task? findTask(String id) {
    int index = OfflineClientStore().taskStore.tasks.indexWhere((value) => value.id == id);
    if (index == -1) {
      return null;
    }
    return tasks[index];
  }

  List<Task> findTasks([String? patientId]) {
    final valueStore = OfflineClientStore().taskStore;
    if (patientId == null) {
      return valueStore.tasks;
    }
    return valueStore.tasks.where((value) => value.patientId == patientId).toList();
  }

  void create(Task task) {
    OfflineClientStore().taskStore.tasks.add(task);
  }

  void update(TaskUpdate taskUpdate) {
    final valueStore = OfflineClientStore().taskStore;
    bool found = false;

    valueStore.tasks = valueStore.tasks.map((value) {
      if (value.id == taskUpdate.id) {
        found = true;
        return value.copyWith(
          name: taskUpdate.name,
          notes: taskUpdate.notes,
          status: taskUpdate.status,
          isPublicVisible: taskUpdate.isPublicVisible,
          dueDate: taskUpdate.dueDate,
        );
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('UpdateTask: Could not find task with id ${taskUpdate.id}');
    }
  }

  void removeDueDate(String taskId) {
    final valueStore = OfflineClientStore().taskStore;
    bool found = false;

    valueStore.tasks = valueStore.tasks.map((value) {
      if (value.id == taskId) {
        found = true;
        final copy = value.copyWith();
        copy.dueDate = null;
        return copy;
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('Could not find task with id $taskId');
    }
  }

  assignUser(String taskId, String assigneeId) {
    final user = OfflineClientStore().userStore.find(assigneeId);
    if (user == null) {
      throw "Could not find user with id $assigneeId";
    }
    final valueStore = OfflineClientStore().taskStore;
    bool found = false;

    valueStore.tasks = valueStore.tasks.map((value) {
      if (value.id == taskId) {
        found = true;
        return value.copyWith(assigneeId: assigneeId);
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('Could not find task with id $taskId');
    }
  }

  unassignUser(String taskId, String assigneeId) {
    final valueStore = OfflineClientStore().taskStore;
    bool found = false;

    valueStore.tasks = valueStore.tasks.map((value) {
      if (value.id == taskId) {
        found = true;
        final copy = value.copyWith();
        copy.assigneeId = null;
        return copy;
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('Could not find task with id $taskId');
    }
  }

  void delete(String taskId) {
    final valueStore = OfflineClientStore().taskStore;
    valueStore.tasks = valueStore.tasks.where((value) => value.id != taskId).toList();
    OfflineClientStore().subtaskStore.findSubtasks(taskId).forEach((subtask) {
      OfflineClientStore().subtaskStore.delete(subtask.id);
    });
  }
}

class SubtaskOfflineService {
  List<Subtask> subtasks = [];

  Subtask? findSubtask(String id) {
    int index = OfflineClientStore().subtaskStore.subtasks.indexWhere((value) => value.id == id);
    if (index == -1) {
      return null;
    }
    return subtasks[index];
  }

  List<Subtask> findSubtasks([String? taskId]) {
    final valueStore = OfflineClientStore().subtaskStore;
    if (taskId == null) {
      return valueStore.subtasks;
    }
    return valueStore.subtasks.where((value) => value.taskId == taskId).toList();
  }

  void create(Subtask subtask) {
    OfflineClientStore().subtaskStore.subtasks.add(subtask);
  }

  void update(SubtaskUpdate subtaskUpdate) {
    final valueStore = OfflineClientStore().subtaskStore;
    bool found = false;

    valueStore.subtasks = valueStore.subtasks.map((value) {
      if (value.id == subtaskUpdate.id) {
        found = true;
        return value.copyWith(name: subtaskUpdate.name, isDone: subtaskUpdate.isDone);
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('UpdateSubtask: Could not find subtask with id ${subtaskUpdate.id}');
    }
  }

  void delete(String subtaskId) {
    final valueStore = OfflineClientStore().subtaskStore;
    valueStore.subtasks = valueStore.subtasks.where((value) => value.id != subtaskId).toList();
  }
}

class TaskServicePromiseClient extends TaskServiceClient {
  TaskServicePromiseClient(super.channel);

  @override
  ResponseFuture<GetTaskResponse> getTask(GetTaskRequest request, {CallOptions? options}) {
    final task = OfflineClientStore().taskStore.findTask(request.id);

    if (task == null) {
      throw "Task with task id ${request.id} not found";
    }

    final patient = OfflineClientStore().patientStore.findPatient(task.patientId);
    if (patient == null) {
      throw "Inconsistency error: Patient with patient id ${task.patientId} not found";
    }

    final subtasks = OfflineClientStore()
        .subtaskStore
        .findSubtasks(task.id)
        .map((subtask) => GetTaskResponse_SubTask(id: subtask.id, name: subtask.name, done: subtask.isDone));

    final response = GetTaskResponse(
        id: task.id,
        name: task.name,
        description: task.notes,
        status: GRPCTypeConverter.taskStatusToGRPC(task.status),
        dueAt: task.dueDate == null ? null : Timestamp.fromDateTime(task.dueDate!),
        createdBy: task.createdBy,
        createdAt: task.creationDate == null ? null : Timestamp.fromDateTime(task.creationDate!),
        public: task.isPublicVisible,
        assignedUserId: task.assigneeId,
        patient: GetTaskResponse_Patient(id: patient.id, humanReadableIdentifier: patient.name),
        subtasks: subtasks);

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetTasksByPatientResponse> getTasksByPatient(GetTasksByPatientRequest request,
      {CallOptions? options}) {
    final tasks =
        OfflineClientStore().taskStore.findTasks(request.patientId).map((task) => GetTasksByPatientResponse_Task(
              id: task.id,
              name: task.name,
              description: task.notes,
              status: GRPCTypeConverter.taskStatusToGRPC(task.status),
              dueAt: task.dueDate == null ? null : Timestamp.fromDateTime(task.dueDate!),
              createdBy: task.createdBy,
              createdAt: task.creationDate == null ? null : Timestamp.fromDateTime(task.creationDate!),
              public: task.isPublicVisible,
              assignedUserId: task.assigneeId,
              patientId: request.patientId,
              subtasks: OfflineClientStore()
                  .subtaskStore
                  .findSubtasks(task.id)
                  .map((subtask) => GetTasksByPatientResponse_Task_SubTask(
                        id: subtask.id,
                        name: subtask.name,
                        done: subtask.isDone,
                      )),
            ));

    final response = GetTasksByPatientResponse(tasks: tasks);

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetAssignedTasksResponse> getAssignedTasks(GetAssignedTasksRequest request, {CallOptions? options}) {
    final user = OfflineClientStore().userStore.users[0];
    final tasks = OfflineClientStore().taskStore.findTasks().where((task) => task.assigneeId == user.id).map((task) {
      final res = GetAssignedTasksResponse_Task(
        id: task.id,
        name: task.name,
        description: task.notes,
        status: GRPCTypeConverter.taskStatusToGRPC(task.status),
        dueAt: task.dueDate == null ? null : Timestamp.fromDateTime(task.dueDate!),
        createdBy: task.createdBy,
        createdAt: task.creationDate == null ? null : Timestamp.fromDateTime(task.creationDate!),
        public: task.isPublicVisible,
        assignedUserId: task.assigneeId,
        subtasks: OfflineClientStore()
            .subtaskStore
            .findSubtasks(task.id)
            .map((subtask) => GetAssignedTasksResponse_Task_SubTask(
                  id: subtask.id,
                  name: subtask.name,
                  done: subtask.isDone,
                )),
      );
      final patient = OfflineClientStore().patientStore.findPatient(task.patientId);
      if (patient == null) {
        throw "Inconsistency error: patient with id ${task.patientId} not found";
      }
      res.patient = GetAssignedTasksResponse_Task_Patient(id: patient.id, humanReadableIdentifier: patient.name);
      return res;
    });

    final response = GetAssignedTasksResponse(tasks: tasks);

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetTasksByPatientSortedByStatusResponse> getTasksByPatientSortedByStatus(
      GetTasksByPatientSortedByStatusRequest request,
      {CallOptions? options}) {
    mapping(task) => GetTasksByPatientSortedByStatusResponse_Task(
          id: task.id,
          name: task.name,
          description: task.notes,
          dueAt: task.dueDate == null ? null : Timestamp.fromDateTime(task.dueDate!),
          createdBy: task.createdBy,
          createdAt: task.creationDate == null ? null : Timestamp.fromDateTime(task.creationDate!),
          public: task.isPublicVisible,
          assignedUserId: task.assigneeId,
          patientId: request.patientId,
          subtasks: OfflineClientStore()
              .subtaskStore
              .findSubtasks(task.id)
              .map((subtask) => GetTasksByPatientSortedByStatusResponse_Task_SubTask(
                    id: subtask.id,
                    name: subtask.name,
                    done: subtask.isDone,
                  )),
        );

    final tasks = OfflineClientStore().taskStore.findTasks(request.patientId);

    final response = GetTasksByPatientSortedByStatusResponse(
      done: tasks.where((element) => element.status == TaskStatus.done).map(mapping),
      inProgress: tasks.where((element) => element.status == TaskStatus.inProgress).map(mapping),
      todo: tasks.where((element) => element.status == TaskStatus.todo).map(mapping),
    );

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<CreateTaskResponse> createTask(CreateTaskRequest request, {CallOptions? options}) {
    final patient = OfflineClientStore().patientStore.findPatient(request.patientId);
    if (patient == null) {
      throw "Patient with id ${request.patientId} not found";
    }
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: request.name,
      notes: request.description,
      patientId: request.patientId,
      creationDate: DateTime.now(),
      createdBy: OfflineClientStore().userStore.users[0].id,
      dueDate: request.hasDueAt() ? request.dueAt.toDateTime() : null,
      status: GRPCTypeConverter.taskStatusFromGRPC(request.initialStatus),
      isPublicVisible: request.public,
      assigneeId: request.assignedUserId,
    );

    OfflineClientStore().taskStore.create(newTask);
    for (var subtask in request.subtasks) {
      OfflineClientStore().subtaskStore.create(Subtask(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            taskId: newTask.id,
            name: subtask.name,
            isDone: subtask.done,
          ));
    }

    final response = CreateTaskResponse()..id = newTask.id;

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<UpdateTaskResponse> updateTask(UpdateTaskRequest request, {CallOptions? options}) {
    final update = TaskUpdate(
      id: request.id,
      name: request.name,
      status: GRPCTypeConverter.taskStatusFromGRPC(request.status),
      isPublicVisible: request.public,
      notes: request.description,
      dueDate: request.hasDueAt() ? request.dueAt.toDateTime() : null,
    );

    OfflineClientStore().taskStore.update(update);

    final response = UpdateTaskResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<AssignTaskResponse> assignTask(AssignTaskRequest request, {CallOptions? options}) {
    OfflineClientStore().taskStore.assignUser(request.taskId, request.userId);
    final response = AssignTaskResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<UnassignTaskResponse> unassignTask(UnassignTaskRequest request, {CallOptions? options}) {
    OfflineClientStore().taskStore.unassignUser(request.taskId, request.userId);
    final response = UnassignTaskResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<RemoveTaskDueDateResponse> removeTaskDueDate(RemoveTaskDueDateRequest request,
      {CallOptions? options}) {
    OfflineClientStore().taskStore.removeDueDate(request.taskId);
    final response = RemoveTaskDueDateResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<DeleteTaskResponse> deleteTask(DeleteTaskRequest request, {CallOptions? options}) {
    OfflineClientStore().taskStore.delete(request.id);

    final response = DeleteTaskResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<CreateSubtaskResponse> createSubtask(CreateSubtaskRequest request, {CallOptions? options}) {
    final task = OfflineClientStore().taskStore.findTask(request.taskId);
    if (task == null) {
      throw "Task with id ${request.taskId} not found";
    }
    final subtask = Subtask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        taskId: request.taskId,
        name: request.subtask.name,
        isDone: request.subtask.done);

    OfflineClientStore().subtaskStore.create(subtask);
    final response = CreateSubtaskResponse()..subtaskId = subtask.id;
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<UpdateSubtaskResponse> updateSubtask(UpdateSubtaskRequest request, {CallOptions? options}) {
    final requestSubtask = request.subtask;
    final update = SubtaskUpdate(
      id: request.subtaskId,
      isDone: requestSubtask.hasDone() ? requestSubtask.done : null,
      name: requestSubtask.hasName() ? requestSubtask.name : null,
    );
    OfflineClientStore().subtaskStore.update(update);

    final response = UpdateSubtaskResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<DeleteSubtaskResponse> deleteSubtask(DeleteSubtaskRequest request, {CallOptions? options}) {
    OfflineClientStore().subtaskStore.delete(request.subtaskId);

    final response = DeleteSubtaskResponse();
    return MockResponseFuture.value(response);
  }
}
