import 'package:helpwave_util/loading.dart';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_service/util.dart';
import 'package:helpwave_service/user.dart';

/// The Controller for managing a [TaskWithPatient]
class TaskController extends LoadingChangeNotifier {
  /// The current [Task]
  TaskWithPatient _task;

  TaskController(this._task) {
      load();
  }

  TaskWithPatient get task => _task;

  set task(TaskWithPatient value) {
    _task = value;
    notifyListeners();
  }

  PatientMinimal get patient => task.patient;

  User? _assignee;

  User? get assignee => _assignee;

  bool get isCreating => _task.isCreating;

  /// Whether the [Task] object can be used to create a [Task]
  ///
  /// Create is only possible when a [Patient] is assigned to the [Task]
  bool get isReadyForCreate => !task.patient.isCreating;

  /// A function to load the [Task]
  load() async {
    loadTask() async {
      if (_task.isCreating) {
        return;
      }
      await TaskService().getTask(id: task.id).then((value) async {
        task = value;
        if (task.hasAssignee) {
          await UserService().getUser(id: task.assigneeId!).then((value) => _assignee = value);
        }
      });
    }

    loadHandler(future: loadTask());
  }

  /// Changes the assigned [User]
  Future<void> changeAssignee(User? user) async {
    if (isCreating) {
      task.assigneeId = user?.id;
      _assignee = user;
      notifyListeners();
      return;
    }
    changeAssigneeFuture() async {
      await TaskService().changeAssignee(taskId: task.id!, userId: user?.id).then((value) {
        task.assigneeId = user?.id;
        _assignee = user;
      });
    }

    await loadHandler(future: changeAssigneeFuture());
  }

  Future<void> changeName(String name) async {
    if (isCreating) {
      task = TaskWithPatient.fromTaskAndPatient(task: task.copyWith(name: name), patient: task.patient);
      notifyListeners();
      return;
    }
    updateName() async {
      await TaskService().updateTask(taskId: task.id!, name: name).then(
          (_) => task = TaskWithPatient.fromTaskAndPatient(task: task.copyWith(name: name), patient: task.patient));
    }

    loadHandler(future: updateName());
  }

  Future<void> changeIsPublic(bool isPublic) async {
    if (isCreating) {
      task = TaskWithPatient.fromTaskAndPatient(task: task.copyWith(isPublicVisible: isPublic), patient: task.patient);
      notifyListeners();
      return;
    }
    updateIsPublic() async {
      await TaskService().updateTask(taskId: task.id!, isPublic: isPublic).then((_) => task =
          TaskWithPatient.fromTaskAndPatient(task: task.copyWith(isPublicVisible: isPublic), patient: task.patient));
    }

    loadHandler(future: updateIsPublic());
  }

  Future<void> changeNotes(String notes) async {
    if (isCreating) {
      task = TaskWithPatient.fromTaskAndPatient(task: task.copyWith(notes: notes), patient: task.patient);
      notifyListeners();
      return;
    }
    updateNotes() async {
      await TaskService().updateTask(taskId: task.id!, notes: notes).then(
          (_) => task = TaskWithPatient.fromTaskAndPatient(task: task.copyWith(notes: notes), patient: task.patient));
    }

    loadHandler(future: updateNotes());
  }

  Future<void> changeDueDate(DateTime? dueDate) async {
    if (isCreating) {
      task = TaskWithPatient.fromTaskAndPatient(task: task.copyWith(dueDate: dueDate), patient: task.patient);
      notifyListeners();
      return;
    }
    updateDueDate() async {
      await TaskService().updateTask(taskId: task.id!, dueDate: dueDate).then((_) =>
          task = TaskWithPatient.fromTaskAndPatient(task: task.copyWith(dueDate: dueDate), patient: task.patient));
    }

    removeDueDate() async {
      await TaskService().removeDueDate(taskId: task.id!).then((_) =>
          task = TaskWithPatient.fromTaskAndPatient(task: task.copyWith(dueDate: dueDate), patient: task.patient));
    }

    loadHandler(future: dueDate == null ? removeDueDate() : updateDueDate());
  }

  /// Only usable when creating a [Task]
  Future<void> changePatient(PatientMinimal patient) async {
    assert(isCreating, "Only use TaskController.changePatient, when you create a new task.");
    assert(!patient.isCreating, "The patient you are trying to attach the Task to must exist");
    task = TaskWithPatient.fromTaskAndPatient(task: task.copyWith(patientId: patient.id), patient: patient);
    notifyListeners();
  }

  /// Creates the Task and returns
  Future<bool> create() async {
    assert(isReadyForCreate, "A the patient must be set to create a task");
    createTask() async {
      await TaskService().createTask(task).then((value) {
        task.copyWith(id: value);
      });
    }

    return loadHandler(future: createTask());
  }
}
