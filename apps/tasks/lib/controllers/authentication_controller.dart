import 'package:flutter/foundation.dart';
import 'package:tasks/services/auth_service.dart';

/// A Controller for providing and updating the current authentication status
class AuthenticationController extends ChangeNotifier {
  final AuthService service = AuthService();

  get isInitialized => service.isInitialized;

  get hasTriedTokens => service.hasTriedTokens;

  AuthenticationController() {
    tokenLogin();
  }

  Future<void> tokenLogin() async {
    await Future.wait([
      service.tokenLogin(),
      // So the loading on the LandingScreen doesn't just blink
      Future.delayed(const Duration(seconds: 1)),
    ]);
    notifyListeners();
  }

  Future<void> webLogin() async {
    await service.webLogin();
    notifyListeners();
  }

  /// Logs a User out and removes all stored information
  logout() {
    service.logout();
    notifyListeners();
  }
}
