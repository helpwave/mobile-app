// TODO extend this or move it to the auth-service in helpwave_services
import 'package:helpwave_service/auth.dart';

/// The class for storing an managing the user
class AuthService {
  static final AuthService _authService = AuthService._ensureInitialized();
  String userId = "";
  Identity? identity; // TODO shouldn't be optional or use a isInitialized

  AuthService._ensureInitialized();

  factory AuthService() => _authService;
}
