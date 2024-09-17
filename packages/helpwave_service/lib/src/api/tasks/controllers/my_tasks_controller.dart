import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_util/loading.dart';

/// The Controller for [Task]s of the current [User]
class AssignedTasksController extends LoadingChangeNotifier {
  /// The currently loaded [Task]s
  List<TaskWithPatient> _tasks = [];

  /// The currently loaded [Task]s
  List<TaskWithPatient> get tasks => _tasks;

  /// The loaded [Task]s which have [TaskStatus.todo]
  List<TaskWithPatient> get todo => _tasks.where((element) => element.status == TaskStatus.todo).toList();

  /// The loaded [Task]s which have [TaskStatus.inProgress]
  List<TaskWithPatient> get inProgress => _tasks.where((element) => element.status == TaskStatus.inProgress).toList();

  /// The loaded [Task]s which have [TaskStatus.done]
  List<TaskWithPatient> get done => _tasks.where((element) => element.status == TaskStatus.done).toList();

  AssignedTasksController() {
    load();
  }

  /// Loads the [Task]s
  Future<void> load() async {
    loadTasksFuture() async {
      _tasks = await TaskService().getAssignedTasks();
    }

    loadHandler(future: loadTasksFuture());
  }
}
