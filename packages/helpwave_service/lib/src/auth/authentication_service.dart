import 'package:url_launcher/url_launcher.dart';
import 'package:openid_client/openid_client_io.dart';

class AuthenticationService {
  static final _authenticationService = AuthenticationService._internal();

  AuthenticationService._internal();

  factory AuthenticationService() => _authenticationService;

  urlLauncher(Uri url) async {
    await launchUrl(url, mode: LaunchMode.inAppWebView);
  }

  authenticate(
    String discoveryUrl,
    String redirectUrl, {
    String clientId = "425f8b8d-c786-4ff7-b2bf-e52f505fb588",
    List<String> scopes = const [
      "openid",
      "offline_access",
      "email",
      "nickname",
      "name",
      "organizations"
    ],
  }) async {
    // TODO check whether thee is still an active token and use it instead of a new sign in
    var issuer = await Issuer.discover(Uri.parse(discoveryUrl));

    print(issuer.metadata.tokenEndpointAuthMethodsSupported);
    var client =
        Client(issuer, clientId); // TODO re-add client secret
    print(client.issuer.metadata.tokenEndpointAuthMethodsSupported);
    var authenticator = Authenticator(
      client,
      scopes: scopes,
      urlLancher: (String url) => urlLauncher(Uri.parse(url)),
    );

    Credential? c;
    // starts the authentication
    try {
      c = await authenticator.authorize();
    } catch (e) {
      print(e);
    } finally {
      closeInAppWebView();
    }
    //print(c);

    // TODO save necessary information, so that all logins are simplified until token is expired
    //print(c.getUserInfo());
    // TODO return whether client successfully authenticated
    return c?.getUserInfo();
  }
// TODO method for checking the validity of the current token

// TODO method for revoking the current token

// TODO methods for making requests with token or ways to access the saved tokens
}
