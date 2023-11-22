import 'package:flutter/material.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:tasks/services/user_service.dart';
import '../dataclasses/user.dart';

/// The Controller for managing a [User]
class UserController extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState _state = LoadingState.initializing;

  /// The current [User], may or may not be loaded depending on the [_state]
  User _user;

  /// The error message to show should only be used when [state] == [LoadingState.error]
  String errorMessage = "";

  /// Saves whether we are currently creating of a Task or already have them
  bool _isCreating = false;

  UserController(this._user) {
    _isCreating = _user.isCreating;
    if (!_isCreating) {
      load();
    }
  }

  LoadingState get state => _state;

  set state(LoadingState value) {
    _state = value;
    notifyListeners();
  }

  User get user => _user;

  set user(User user) {
    _user = user;
    _state = LoadingState.loaded;
    notifyListeners();
  }

  // Used to trigger the notify call without having to copy or save the Task locally
  updateUser(void Function(User user) transformer) {
    transformer(user);
    state = LoadingState.loaded;
  }

  get isCreating => _isCreating;

  /// A function to load the [User]
  load() async {
    state = LoadingState.loading;
    await UserService().getUser(id: user.id).then((value) {user = value;}).catchError((error, stackTrace) {
      errorMessage = error.toString();
      state = LoadingState.error;
    });
  }
}
