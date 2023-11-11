import 'package:flutter/foundation.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:logger/logger.dart';
import 'package:tasks/dataclasses/task.dart';
import 'package:tasks/services/current_ward_svc.dart';
import 'package:tasks/services/organization_svc.dart';
import 'package:tasks/services/task_svc.dart';
import '../dataclasses/user.dart';

/// The Controller for selecting a [User] as the assignee of a [Task]
class AssigneeSelectController extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState _state = LoadingState.initializing;

  LoadingState get state => _state;

  set state(LoadingState value) {
    _state = value;
    notifyListeners();
  }

  /// The selected [User] identifier
  String? _selected;

  String? get selected => _selected;

  User? get selectedUser => _users.firstWhere((user) => user.id == selected);

  /// The currently loaded user
  List<User> _users = [];

  /// The currently loaded tasks
  List<User> get users => _users;

  /// The identifier of the current [Task] it determines whether
  /// changes are pushed to the server
  String? _taskId;

  AssigneeSelectController({String? selected, String? taskId}) {
    _selected = selected;
    _taskId = taskId;
    load();
  }

  final Logger _logger = Logger();

  /// Loads the tasks
  Future<void> load() async {
    state = LoadingState.loading;
    String? currentOrganization = CurrentWardService().currentWard?.organizationId;
    if(currentOrganization == null){
      if(kDebugMode){
        _logger.w("Organization Id not set in CurrentWardService while trying to load in AssigneeSelectController");
      }
      state = LoadingState.error;
      return;
    }

    _users = await OrganizationService().getMembersByOrganization(currentOrganization);
    state = LoadingState.loaded;
  }

  /// Change the assignee
  Future<void> changeAssignee(String id) async{
    if(_taskId != null && _taskId!.isNotEmpty){
      state = LoadingState.loading;
      await TaskService().assignToUser(taskId: _taskId!, userId: id);
    }
    _selected = id;
    state = LoadingState.loaded;
  }
}
