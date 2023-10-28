import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:openid_client/openid_client_io.dart';

class AuthenticationService {
  static final _authenticationService = AuthenticationService._internal();

  AuthenticationService._internal();

  factory AuthenticationService() => _authenticationService;

  Future<void> urlLauncher(Uri url) async {
    await launchUrl(url, mode: LaunchMode.inAppWebView);
  }

  Future<UserInfo?> authenticate({
    required BuildContext context,
    required void Function() callback,
    String discoveryUrl = "https://auth.helpwave.de",
    String redirectUrl = "http://localhost:3000/",
    String clientId = "425f8b8d-c786-4ff7-b2bf-e52f505fb588",
    List<String> scopes = const ["openid", "offline_access", "email", "nickname", "name", "organizations"],
  }) async {
    // TODO check whether thee is still an active token and use it instead of a new sign in
    var issuer = await Issuer.discover(Uri.parse(discoveryUrl));
    var client = Client(issuer, clientId);

    var authenticator = Authenticator(
      client,
      scopes: scopes,
      urlLancher: (url) => urlLauncher(Uri.parse(url)),
    );

    Credential? c;
    // starts the authentication
    try {
      c = await authenticator.authorize();
    } catch (e) {
      print(e);
    } finally {
      bool temp = await supportsCloseForLaunchMode(LaunchMode.inAppWebView);
      print(temp);
      await closeInAppWebView();
    }

    print("after");
    // TODO save necessary information, so that all logins are simplified until token is expired

    // TODO return whether client successfully authenticated
    return c?.getUserInfo();
  }
// TODO method for checking the validity of the current token

// TODO method for revoking the current token

// TODO methods for making requests with token or ways to access the saved tokens
}
