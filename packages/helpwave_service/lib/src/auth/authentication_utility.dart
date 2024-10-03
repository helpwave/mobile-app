import 'package:helpwave_service/auth.dart';

class AuthenticationUtility {
  static Map<String, String> get authMetaData {
    UserSessionService sessionService = UserSessionService();
    if (sessionService.isLoggedIn) {
      return {
        "Authorization": "Bearer ${sessionService.identity?.idToken}",
      };
    }
    // Maybe throw a error instead
    return {};
  }

  static String? get fallbackOrganizationId =>
      // Maybe throw a error instead for the last case
      CurrentWardService().currentWard?.organizationId ?? UserSessionService().identity?.firstOrganization;
}
