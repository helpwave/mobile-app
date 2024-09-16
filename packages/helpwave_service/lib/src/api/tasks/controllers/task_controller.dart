import 'package:helpwave_util/loading.dart';
import 'package:helpwave_service/src/api/tasks/index.dart';

/// The Controller for managing a [TaskWithPatient]
class TaskController extends LoadingChangeNotifier {
  /// The current [Task]
  TaskWithPatient _task;

  TaskController(this._task) {
    if (!_task.isCreating) {
      load();
    }
  }

  TaskWithPatient get task => _task;


  set task(TaskWithPatient value) {
    _task = value;
    notifyListeners();
  }

  PatientMinimal get patient => task.patient;

  bool get isCreating => _task.isCreating;

  /// Whether the [Task] object can be used to create a [Task]
  ///
  /// Create is only possible when a [Patient] is assigned to the [Task]
  bool get isReadyForCreate => !task.patient.isCreating;

  /// A function to load the [Task]
  load() async {
    loadTask() async {
      await TaskService().getTask(id: task.id).then((value) {
        task = value;
      });
    }
    loadHandler(future: loadTask());
  }

  /// Changes the assigned [User]
  ///
  /// Without a backend request as we expect this to be done in the [AssigneeSelectController]
  Future<void> changeAssignee(String assigneeId) async {
    String? old = task.assigneeId;
    updateTask(
      (task) {
        task.assigneeId = assigneeId;
      },
      (task) {
        task.assigneeId = old;
      },
    );
  }

  Future<void> changeName(String name) async {
    String oldName = task.name;
    updateTask(
      (task) {
        task.name = name;
      },
      (task) {
        task.name = oldName;
      },
    );
  }

  Future<void> changeIsPublic(bool isPublic) async {
    bool old = task.isPublicVisible;
    updateTask(
      (task) {
        task.isPublicVisible = isPublic;
      },
      (task) {
        task.isPublicVisible = old;
      },
    );
  }

  Future<void> changeNotes(String notes) async {
    String oldNotes = notes;
    updateTask(
      (task) {
        task.notes = notes;
      },
      (task) {
        task.notes = oldNotes;
      },
    );
  }

  Future<void> changeDueDate(DateTime? dueDate) async {
    DateTime? old = task.dueDate;
    updateTask(
          (task) {
        task.dueDate = dueDate;
      },
          (task) {
        task.dueDate = old;
      },
    );
  }

  /// Only usable when creating
  Future<void> changePatient(PatientMinimal patient) async {
    assert(isCreating, "Only use TaskController.changePatient, when you create a new task.");
    task = TaskWithPatient.fromTaskAndPatient(task: task.copyWith(patientId: patient.id), patient: patient);
    notifyListeners();
  }

  /// Creates the Task and returns
  Future<bool> create() async {
    assert(!isReadyForCreate, "A the patient must be set to create a task");
    state = LoadingState.loading;
    return await TaskService().createTask(task).then((value) {
      task.copyWith(id: value);
      state = LoadingState.loaded;
      return true;
    }).catchError((error, stackTrace) {
      errorMessage = error.toString();
      state = LoadingState.error;
      return false;
    });
  }
}
