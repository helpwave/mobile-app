import 'package:helpwave_service/auth.dart';
import 'package:tasks/config/config.dart';

/// The class for storing an managing the user session
class UserSessionService {
  /// The [Identity] of the user
  Identity? _identity;

  /// Whether the stored tokens have already been used for authentication
  bool _hasTriedTokens = false;

  static final UserSessionService _authService = UserSessionService._ensureInitialized();

  UserSessionService._ensureInitialized() {
    _hasTriedTokens = DEV_MODE;
  }

  factory UserSessionService() => _authService;

  Identity? get identity => _identity;

  bool get isLoggedIn => _identity != null;

  bool get hasTriedTokens => _hasTriedTokens;

  /// Logs a User in by using the stored tokens
  ///
  /// Sets the [hasTriedTokens] to true
  Future<void> tokenLogin() async {
    if (!DEV_MODE) {
      _identity = await AuthenticationService().tokenLogin();
    } else {
      _identity = Identity.defaultIdentity();
    }
    _hasTriedTokens = true;
  }

  /// Logs a User in by a in app web view
  Future<void> login() async {
    if (!DEV_MODE) {
      _identity = await AuthenticationService().login();
    }
  }

  /// Logs a User out and removes all stored information
  logout() {
    _identity = DEV_MODE ? Identity.defaultIdentity() : null;
    _hasTriedTokens = true;
    AuthenticationService().revoke();
  }
}
