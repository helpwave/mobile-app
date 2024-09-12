import 'package:helpwave_service/src/api/tasks/data_types/task.dart' as task_lib;
import 'package:helpwave_proto_dart/services/tasks_svc/v1/types.pbenum.dart' as proto;

class GRPCTypeConverter {
  static proto.TaskStatus taskStatusToGRPC(task_lib.TaskStatus status) {
    switch (status) {
      case task_lib.TaskStatus.todo:
        return proto.TaskStatus.TASK_STATUS_TODO;
      case task_lib.TaskStatus.inProgress:
        return proto.TaskStatus.TASK_STATUS_IN_PROGRESS;
      case task_lib.TaskStatus.done:
        return proto.TaskStatus.TASK_STATUS_DONE;
      case task_lib.TaskStatus.unspecified:
        return proto.TaskStatus.TASK_STATUS_UNSPECIFIED;
    }
  }

  static task_lib.TaskStatus taskStatusFromGRPC(proto.TaskStatus status) {
    switch (status) {
      case proto.TaskStatus.TASK_STATUS_TODO:
        return task_lib.TaskStatus.todo;
      case proto.TaskStatus.TASK_STATUS_IN_PROGRESS:
        return task_lib.TaskStatus.inProgress;
      case proto.TaskStatus.TASK_STATUS_DONE:
        return task_lib.TaskStatus.done;
      default:
        return task_lib.TaskStatus.unspecified;
    }
  }
}
