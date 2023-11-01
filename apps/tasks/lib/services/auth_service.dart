import 'package:helpwave_service/auth.dart';
import 'package:tasks/config/config.dart';

/// The class for storing an managing the user
class AuthService {
  Identity? _identity;
  bool _hasTriedTokens = false;

  static final AuthService _authService = AuthService._ensureInitialized();

  AuthService._ensureInitialized() {
    _hasTriedTokens = DEV_MODE;
  }

  factory AuthService() => _authService;

  Identity? get identity => _identity;

  bool get isInitialized => _identity != null;

  bool get hasTriedTokens => _hasTriedTokens;

  Future<void> tokenLogin() async {
    if (!DEV_MODE) {
      _identity = await AuthenticationService().tokenLogin();
    } else {
      _identity = Identity.defaultIdentity();
    }
    _hasTriedTokens = true;
  }

  Future<void> webLogin() async {
    if (!DEV_MODE) {
      _identity = await AuthenticationService().webLogin();
    }
  }

  /// Logs a User out and removes all stored information
  logout() {
    _identity = DEV_MODE ? Identity.defaultIdentity() : null;
    _hasTriedTokens = true;
    AuthenticationService().revoke();
  }
}
