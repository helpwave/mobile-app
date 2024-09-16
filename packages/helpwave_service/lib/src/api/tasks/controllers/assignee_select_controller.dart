import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/src/api/user/index.dart';
import 'package:helpwave_util/loading.dart';
import 'package:helpwave_service/tasks.dart';

/// The Controller for selecting a [User] as the assignee of a [Task]
class AssigneeSelectController extends LoadingChangeNotifier {
  /// The selected [User] identifier
  String? _selected;

  String? get selected => _selected;

  User? get selectedUser => _users.firstWhere((user) => user.id == selected);

  /// The currently loaded user
  List<User> _users = [];

  /// The currently loaded users
  List<User> get users => _users;

  /// The identifier of the current [Task] it determines whether
  /// changes are pushed to the server
  String? _taskId;

  /// Whether the object is
  bool get isCreating => _taskId == null && _taskId!.isNotEmpty; // TODO remove .isNotEmpty when semantic is changed

  AssigneeSelectController({String? selected, String? taskId}) {
    _selected = selected;
    _taskId = taskId;
    load();
  }

  /// Loads the users
  Future<void> load() async {
    loadUsersFuture() async {
      String? currentOrganization = CurrentWardService().currentWard?.organizationId;
      if (currentOrganization == null) {
        // TODO throw a better error here
        throw "Organization Id not set in CurrentWardService while trying to load in AssigneeSelectController";
      }
      _users = await OrganizationService().getMembersByOrganization(currentOrganization);
    }

    await loadHandler(future: loadUsersFuture());
  }

  /// Change the assignee
  Future<void> changeAssignee(String id) async {
    changeAssigneeFuture() async {
      if (!isCreating) {
        await TaskService().assignToUser(taskId: _taskId!, userId: id).then((value) => _selected = id);
      } else {
        _selected = id;
      }
    }

    await loadHandler(future: changeAssigneeFuture());
  }
}
