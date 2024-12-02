import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/tasks_svc/v1/task_template_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/tasks/data_types/index.dart';
import 'package:helpwave_service/src/api/tasks/tasks_api_service_clients.dart';

/// The Service for [TaskTemplate]s
///
/// Provides queries and requests that load or alter [TaskTemplate] objects on the server
/// The server is defined in the underlying [TasksAPIServiceClients]
class TaskTemplateService {
  /// The GRPC ServiceClient which handles GRPC
  TaskTemplateServiceClient taskTemplateService = TasksAPIServiceClients().taskTemplatesServiceClient;

  /// Loads a [TaskTemplate] by its identifier
  Future<TaskTemplate> get({required String id}) async {
    // TODO use a query here
    final templates = await getMany();
    return templates.firstWhere((element) => element.id == id);
  }

  /// Loads multiple [TaskTemplate]s which can be filtered by the methods parameters
  Future<List<TaskTemplate>> getMany({
    String? wardId,
    String? createdBy,
    bool privateOnly = false,
  }) async {
    GetAllTaskTemplatesRequest request = GetAllTaskTemplatesRequest(
      wardId: wardId,
      createdBy: createdBy,
      privateOnly: privateOnly,
    );
    GetAllTaskTemplatesResponse response = await taskTemplateService.getAllTaskTemplates(
      request,
      options: CallOptions(metadata: TasksAPIServiceClients().getMetaData()),
    );

    return response.templates
        .map((template) => TaskTemplate(
            id: template.id,
            name: template.name,
            description: template.description,
            wardId: wardId,
            createdBy: createdBy ?? template.createdBy,
            isPublicVisible: template.isPublic,
            subtasks: template.subtasks
                .map((subtask) => TaskTemplateSubtask(
                      id: subtask.id,
                      templateId: subtask.taskTemplateId,
                      name: subtask.name,
                    ))
                .toList()))
        .toList();
  }

  /// Method to create a [TaskTemplate]
  ///
  /// Note that the returned [TaskTemplate] does not have any [TaskTemplateSubtask]s as there identifiers are unknown
  /// after the request
  Future<TaskTemplate> create({required TaskTemplate template}) async {
    CreateTaskTemplateRequest request = CreateTaskTemplateRequest(
        name: template.name,
        description: template.description,
        wardId: template.wardId,
        subtasks: template.subtasks.map((subtask) => CreateTaskTemplateRequest_SubTask(name: subtask.name)));
    CreateTaskTemplateResponse response = await taskTemplateService.createTaskTemplate(
      request,
      options: CallOptions(
        metadata: TasksAPIServiceClients().getMetaData(),
      ),
    );

    return template.copyWith(id: response.id, subtasks: []);
  }

  /// Method to update a [TaskTemplate]
  Future<bool> update({
    required String id,
    String? name,
    String? description,
  }) async {
    UpdateTaskTemplateRequest request = UpdateTaskTemplateRequest(
      id: id,
      name: name,
      description: description,
    );

    await taskTemplateService.updateTaskTemplate(
      request,
      options: CallOptions(
        metadata: TasksAPIServiceClients().getMetaData(),
      ),
    );

    return true;
  }

  /// Method to update a [TaskTemplate]
  Future<bool> delete({required String id}) async {
    DeleteTaskTemplateRequest request = DeleteTaskTemplateRequest(id: id);

    await taskTemplateService.deleteTaskTemplate(
      request,
      options: CallOptions(
        metadata: TasksAPIServiceClients().getMetaData(),
      ),
    );

    return true;
  }

  /// Method to create a [TaskTemplateSubtask]
  Future<TaskTemplateSubtask> createSubtask({required TaskTemplateSubtask value}) async {
    CreateTaskTemplateSubTaskRequest request = CreateTaskTemplateSubTaskRequest(
      taskTemplateId: value.templateId,
      name: value.name,
    );
    CreateTaskTemplateSubTaskResponse response = await taskTemplateService.createTaskTemplateSubTask(
      request,
      options: CallOptions(
        metadata: TasksAPIServiceClients().getMetaData(),
      ),
    );

    return value.copyWith(id: response.id);
  }

  /// Method to update a [TaskTemplateSubtask]
  Future<bool> updateSubtask({
    required String id,
    String? name,
  }) async {
    UpdateTaskTemplateSubTaskRequest request = UpdateTaskTemplateSubTaskRequest(
      subtaskId: id,
      name: name,
    );

    await taskTemplateService.updateTaskTemplateSubTask(
      request,
      options: CallOptions(
        metadata: TasksAPIServiceClients().getMetaData(),
      ),
    );

    return true;
  }

  /// Method to update a [TaskTemplateSubtask]
  Future<bool> deleteSubtask({required String id}) async {
    DeleteTaskTemplateSubTaskRequest request = DeleteTaskTemplateSubTaskRequest(id: id);

    await taskTemplateService.deleteTaskTemplateSubTask(
      request,
      options: CallOptions(
        metadata: TasksAPIServiceClients().getMetaData(),
      ),
    );

    return true;
  }
}
