import 'package:flutter/cupertino.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:tasks/dataclasses/subtask.dart';
import 'package:tasks/dataclasses/task.dart';
import '../dataclasses/patient.dart';

/// The Controller for [Task]s of the current [User]
class MyTasksController extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState state = LoadingState.initializing;

  /// The currently loaded tasks
  List<TaskWithPatient> _tasks = [];

  /// The currently loaded tasks
  List<TaskWithPatient> get tasks => _tasks;

  /// The loaded tasks which have [TaskStatus.todo]
  List<TaskWithPatient> get todo => _tasks.where((element) => element.status == TaskStatus.todo).toList();

  /// The loaded tasks which have [TaskStatus.inProgress]
  List<TaskWithPatient> get inProgress => _tasks.where((element) => element.status == TaskStatus.inProgress).toList();

  /// The loaded tasks which have [TaskStatus.done]
  List<TaskWithPatient> get done => _tasks.where((element) => element.status == TaskStatus.done).toList();

  MyTasksController() {
    load();
  }

  /// Loads the tasks
  Future<void> load() async {
    if (state == LoadingState.initializing) {
      state = LoadingState.loading;
      notifyListeners();
    }

    // TODO make grpc request here
    PatientMinimal patient = PatientMinimal(
      id: 'patient 1',
      name: "Victoria Schäfer",
    );
    await Future.delayed(const Duration(seconds: 2));
    _tasks = [
      TaskWithPatient(
        id: "task1",
        name: "Task name - 1",
        assignee: "",
        notes: "Some text describing the task",
        dueDate: DateTime.now().add(const Duration(days: 20)),
        status: TaskStatus.inProgress,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1"),
          SubTask(id: "subtask 2", name: "Subtask 2"),
        ],
        patient: patient,
      ),
      TaskWithPatient(
        id: "task2",
        name: "Task name - 2",
        assignee: "",
        notes: "Some text describing the task with an very very very long text",
        dueDate: DateTime.now().add(const Duration(hours: 10)),
        status: TaskStatus.done,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1", isDone: true),
          SubTask(id: "subtask 2", name: "Subtask 2"),
        ],
        patient: patient,
      ),
      TaskWithPatient(
        id: "task3",
        name: "Task name - 3",
        assignee: "",
        notes: "Some text describing the task",
        dueDate: DateTime.now().add(const Duration(hours: 1)),
        status: TaskStatus.todo,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1"),
          SubTask(id: "subtask 2", name: "Subtask 2", isDone: true),
        ],
        patient: patient,
      ),
      TaskWithPatient(
        id: "task4",
        name: "Task name - 4",
        assignee: "",
        notes: "Some text describing the task",
        dueDate: DateTime.now().subtract(const Duration(days: 20)),
        status: TaskStatus.inProgress,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1"),
          SubTask(id: "subtask 2", name: "Subtask 2", isDone: true),
          SubTask(id: "subtask 3", name: "Subtask 3", isDone: true),
        ],
        patient: patient,
      ),
      TaskWithPatient(
        id: "task5",
        name: "Task name - 5",
        assignee: "",
        notes: "Some text describing the task",
        status: TaskStatus.inProgress,
        subtasks: [
          SubTask(id: "subtask 1", name: "Subtask 1"),
          SubTask(id: "subtask 2", name: "Subtask 2", isDone: true),
          SubTask(id: "subtask 3", name: "Subtask 3", isDone: true),
        ],
        patient: patient,
      )
    ];
    state = LoadingState.loaded;
    notifyListeners();
  }
}
