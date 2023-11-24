import 'package:flutter/foundation.dart';
import 'package:tasks/services/user_session_service.dart';

/// A Controller for providing and updating the current user session
class UserSessionController extends ChangeNotifier {
  /// The underlying [UserSessionService] to use
  final UserSessionService _service = UserSessionService();

  /// Whether the user is logged in
  get isLoggedIn => _service.isLoggedIn;

  /// Identity of the current user
  get identity => _service.identity;


  /// Whether the stored token have already been tried for authentication
  get hasTriedTokens => _service.hasTriedTokens;

  UserSessionController() {
    tokenLogin();
  }

  /// Tries to authenticate with stored tokens
  Future<void> tokenLogin() async {
    await Future.wait([
      _service.tokenLogin(),
      // So the loading on the LandingScreen doesn't just blink
      Future.delayed(const Duration(seconds: 1)),
    ]);
    notifyListeners();
  }

  /// Opens in app web view for the authentication
  Future<void> login() async {
    await _service.login();
    notifyListeners();
  }

  /// Logs a User out and removes all stored information
  logout() {
    _service.logout();
    notifyListeners();
  }
}
