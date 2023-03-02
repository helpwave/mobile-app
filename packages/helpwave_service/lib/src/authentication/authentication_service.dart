import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AuthenticationService {
  static final _authenticationService = AuthenticationService._internal();

  AuthenticationService._internal();

  factory AuthenticationService() => _authenticationService;

  urlLauncher(String url) async {
    await launchUrlString(url, mode: LaunchMode.inAppWebView);
  }

  authenticate(Uri uri, String clientId, int port, List<String> scopes) async {
    // TODO check whether thee is still an active token and use it instead of a new sign in
    Issuer issuer = await Issuer.discover(uri);
    Client client = Client(issuer, clientId);

    Authenticator authenticator = Authenticator(
      client,
      scopes: scopes,
      port: port,
      urlLancher: urlLauncher,
    );

    Credential credential = await authenticator.authorize();
    closeInAppWebView();
    // TODO save necessary information, so that all logins are simplified until token is expired

    // TODO return whether client successfully authenticated
    return (await credential.getUserInfo()).zoneinfo;
  }
// TODO method for checking the validity of the current token

// TODO method for revoking the current token

// TODO methods for making requests with token or ways to access the saved tokens
}
