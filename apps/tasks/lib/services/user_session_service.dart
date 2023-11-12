import 'package:helpwave_service/auth.dart';
import 'package:tasks/config/config.dart';
import 'package:tasks/services/current_ward_svc.dart';

/// The class for storing an managing the user session
class UserSessionService {
  /// The [Identity] of the user
  Identity? _identity;

  /// Whether the stored tokens have already been used for authentication
  bool _hasTriedTokens = false;

  final AuthenticationService _authService = AuthenticationService();

  static final UserSessionService _userSessionService = UserSessionService._ensureInitialized();

  UserSessionService._ensureInitialized() {
    _hasTriedTokens = DEV_MODE;
  }

  factory UserSessionService() => _userSessionService;

  Identity? get identity => _identity;

  bool get isLoggedIn => _identity != null;

  bool get hasTriedTokens => _hasTriedTokens;

  /// Logs a User in by using the stored tokens
  ///
  /// Sets the [hasTriedTokens] to true
  Future<void> tokenLogin() async {
    if (!DEV_MODE) {
      _identity = await _authService.tokenLogin();
      // new login required thus delete all saved information
      if(_identity == null){
        _authService.clearFromStorage();
        CurrentWardService().clear();
      }
    } else {
      _identity = Identity.defaultIdentity();
    }
    _hasTriedTokens = true;
  }

  /// Logs a User in by a in app web view
  Future<void> login() async {
    if (!DEV_MODE) {
      _identity = await _authService.login();
    }
  }

  /// Logs a User out and removes all stored information
  logout() {
    _identity = DEV_MODE ? Identity.defaultIdentity() : null;
    _hasTriedTokens = true;
    _authService.revoke();
  }
}
