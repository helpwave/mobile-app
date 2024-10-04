import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/task_template_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/offline/offline_client_store.dart';
import 'package:helpwave_service/src/api/offline/util.dart';
import 'package:helpwave_service/src/api/tasks/data_types/index.dart';

class TaskTemplateUpdate {
  String id;
  String? name;
  String? description;

  TaskTemplateUpdate({required this.id, this.name, this.description});
}

class TaskSubtaskTemplateUpdate {
  String id;
  String? name;

  TaskSubtaskTemplateUpdate({required this.id, this.name});
}

class TaskTemplateOfflineService {
  List<TaskTemplate> taskTemplates = [];

  TaskTemplate? findTaskTemplate(String id) {
    int index = taskTemplates.indexWhere((value) => value.id == id);
    if (index == -1) {
      return null;
    }
    return taskTemplates[index];
  }

  List<TaskTemplate> findTaskTemplates([String? wardId]) {
    if (wardId == null) {
      return taskTemplates;
    }
    return taskTemplates.where((value) => value.wardId == wardId).toList();
  }

  void create(TaskTemplate taskTemplate) {
    taskTemplates.add(taskTemplate);
  }

  void update(TaskTemplateUpdate taskTemplateUpdate) {
    bool found = false;

    taskTemplates = taskTemplates.map((value) {
      if (value.id == taskTemplateUpdate.id) {
        found = true;
        return value.copyWith(
          name: taskTemplateUpdate.name,
          description: taskTemplateUpdate.description,
        );
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('UpdateTaskTemplate: Could not find task with id ${taskTemplateUpdate.id}');
    }
  }

  void delete(String taskId) {
    taskTemplates = taskTemplates.where((value) => value.id != taskId).toList();
    OfflineClientStore().taskTemplateSubtaskStore.findTemplateSubtasks(taskId).forEach((templateSubtask) {
      OfflineClientStore().taskTemplateSubtaskStore.delete(templateSubtask.id);
    });
  }
}

class TaskTemplateSubtaskOfflineService {
  List<Subtask> taskTemplateSubtasks = [];

  Subtask? findTemplateSubtask(String id) {
    int index = taskTemplateSubtasks.indexWhere((value) => value.id == id);
    if (index == -1) {
      return null;
    }
    return taskTemplateSubtasks[index];
  }

  List<Subtask> findTemplateSubtasks([String? taskTemplateId]) {
    if (taskTemplateId == null) {
      return taskTemplateSubtasks;
    }
    return taskTemplateSubtasks.where((value) => value.taskId == taskTemplateId).toList();
  }

  void create(Subtask templateSubtask) {
    taskTemplateSubtasks.add(templateSubtask);
  }

  void update(TaskSubtaskTemplateUpdate templateSubtaskUpdate) {
    bool found = false;

    taskTemplateSubtasks = taskTemplateSubtasks.map((value) {
      if (value.id == templateSubtaskUpdate.id) {
        found = true;
        return value.copyWith(name: templateSubtaskUpdate.name);
      }
      return value;
    }).toList();

    if (!found) {
      throw Exception('UpdateTemplateSubtask: Could not find templateSubtask with id ${templateSubtaskUpdate.id}');
    }
  }

  void delete(String templateSubtaskId) {
    taskTemplateSubtasks = taskTemplateSubtasks.where((value) => value.id != templateSubtaskId).toList();
  }
}

class TaskTemplateOfflineClient extends TaskTemplateServiceClient {
  TaskTemplateOfflineClient(super.channel);

  @override
  ResponseFuture<GetAllTaskTemplatesResponse> getAllTaskTemplates(GetAllTaskTemplatesRequest request,
      {CallOptions? options}) {
    final user = OfflineClientStore().userStore.users[0];
    final templates = OfflineClientStore().taskTemplateStore.taskTemplates.where((template) {
      if (request.hasWardId() && template.wardId != request.wardId) {
        return false;
      }
      if (request.hasCreatedBy() && template.createdBy != request.createdBy) {
        return false;
      }
      if (request.privateOnly && template.createdBy != user.id) {
        return false;
      }
      return true;
    });

    final response = GetAllTaskTemplatesResponse(
        templates: templates.map(
      (template) => GetAllTaskTemplatesResponse_TaskTemplate(
          id: template.id,
          name: template.name,
          createdBy: template.createdBy,
          description: template.description,
          isPublic: template.isPublicVisible,
          subtasks: OfflineClientStore()
              .taskTemplateSubtaskStore
              .findTemplateSubtasks(template.id)
              .map((taskTemplateSubtask) => GetAllTaskTemplatesResponse_TaskTemplate_SubTask(
                    id: taskTemplateSubtask.id,
                    name: taskTemplateSubtask.name,
                    taskTemplateId: taskTemplateSubtask.taskId,
                  ))),
    ));
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<CreateTaskTemplateResponse> createTaskTemplate(CreateTaskTemplateRequest request,
      {CallOptions? options}) {
    final newTaskTemplate = TaskTemplate(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: request.name,
      description: request.description,
      wardId: request.hasWardId() ? request.wardId : null,
      createdBy: OfflineClientStore().userStore.users[0].id,
    );

    OfflineClientStore().taskTemplateStore.create(newTaskTemplate);
    for (var templateSubtask in request.subtasks) {
      OfflineClientStore().taskTemplateSubtaskStore.create(Subtask(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            taskId: newTaskTemplate.id!,
            name: templateSubtask.name,
            isDone: false,
          ));
    }

    final response = CreateTaskTemplateResponse()..id = newTaskTemplate.id!;

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<UpdateTaskTemplateResponse> updateTaskTemplate(UpdateTaskTemplateRequest request,
      {CallOptions? options}) {
    final update = TaskTemplateUpdate(
      id: request.id,
      name: request.hasName() ? request.name : null,
    );

    OfflineClientStore().taskTemplateStore.update(update);

    final response = UpdateTaskTemplateResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<DeleteTaskTemplateResponse> deleteTaskTemplate(DeleteTaskTemplateRequest request,
      {CallOptions? options}) {
    OfflineClientStore().taskStore.delete(request.id);

    final response = DeleteTaskTemplateResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<CreateTaskTemplateSubTaskResponse> createTaskTemplateSubTask(CreateTaskTemplateSubTaskRequest request,
      {CallOptions? options}) {
    final task = OfflineClientStore().taskTemplateStore.findTaskTemplate(request.taskTemplateId);
    if (task == null) {
      throw "TaskTemplate with id ${request.taskTemplateId} not found";
    }
    final templateSubtask = Subtask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskId: request.taskTemplateId,
      name: request.name,
      isDone: false,
    );

    OfflineClientStore().taskTemplateSubtaskStore.create(templateSubtask);
    final response = CreateTaskTemplateSubTaskResponse()..id = templateSubtask.id;
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<UpdateTaskTemplateSubTaskResponse> updateTaskTemplateSubTask(UpdateTaskTemplateSubTaskRequest request, {CallOptions? options}) {
    final update = TaskSubtaskTemplateUpdate(
      id: request.subtaskId,
      name: request.hasName() ? request.name : null,
    );
    OfflineClientStore().taskTemplateSubtaskStore.update(update);

    final response = UpdateTaskTemplateSubTaskResponse();
    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<DeleteTaskTemplateSubTaskResponse> deleteTaskTemplateSubTask(DeleteTaskTemplateSubTaskRequest request, {CallOptions? options}) {
    OfflineClientStore().taskTemplateSubtaskStore.delete(request.id);

    final response = DeleteTaskTemplateSubTaskResponse();
    return MockResponseFuture.value(response);
  }
}
