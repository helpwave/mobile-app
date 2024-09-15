import 'package:flutter/foundation.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/src/api/user/index.dart';
import 'package:helpwave_util/loading_state.dart';
import 'package:logger/logger.dart';
import 'package:helpwave_service/tasks.dart';

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

  /// Loads the tasks
  Future<void> load() async {
    state = LoadingState.loading;
    String? currentOrganization = CurrentWardService().currentWard?.organizationId;
    if(currentOrganization == null){
      if(kDebugMode){
        Logger().w("Organization Id not set in CurrentWardService"
            " while trying to load in AssigneeSelectController");
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
