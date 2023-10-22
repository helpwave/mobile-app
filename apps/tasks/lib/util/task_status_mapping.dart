import 'package:tasks/dataclasses/task.dart' as task_lib;
import 'package:helpwave_proto_dart/proto/services/task_svc/v1/task_svc.pbenum.dart'
    as proto;

Map<proto.TaskStatus, task_lib.TaskStatus> taskStatusMapping = {
  proto.TaskStatus.TASK_STATUS_TODO: task_lib.TaskStatus.todo,
  proto.TaskStatus.TASK_STATUS_IN_PROGRESS: task_lib.TaskStatus.inProgress,
  proto.TaskStatus.TASK_STATUS_DONE: task_lib.TaskStatus.done,
  proto.TaskStatus.TASK_STATUS_UNSPECIFIED: task_lib.TaskStatus.unspecified,
};
