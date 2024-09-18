import 'package:flutter/cupertino.dart';
import '../../loading.dart';

/// A [ChangeNotifier] that manages a [LoadingState] to indicate to components what state they should show
class LoadingChangeNotifier extends ChangeNotifier {
  /// The [LoadingState] of the Controller
  LoadingState _state = LoadingState.initializing;

  /// The [LoadingState] of the Controller
  LoadingState get state => _state;

  /// The Error, when the Controller is [LoadingState.error]
  Object? error;

  /// Function
  changeState(LoadingState value) {
    _state = value;
    notifyListeners();
  }

  LoadingChangeNotifier();

  Future<bool> loadHandler({
    required Future<void> future,
    Future<bool> Function(Object? error, StackTrace stackTrace)? errorHandler,
  }) async {
    bool success = false;
    defaultErrorHandler(errorObj, _) async {
      error = errorObj.toString();
      return false;
    }

    changeState(LoadingState.loading);
    await future.then((_) {
      changeState(LoadingState.loaded);
      success = true;
    }).onError((error, stackTrace) async {
      if (errorHandler != null) {
        try {
          bool isHandled = await errorHandler(error, stackTrace);
          if (isHandled) {
            return;
          }
        } catch (_) {}
      } else {
        defaultErrorHandler(error, stackTrace);
      }

      changeState(LoadingState.error);
    });
    return success;
  }
}
