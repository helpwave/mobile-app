import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helpwave_service/src/auth/identity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:openid_client/openid_client_io.dart';

class AuthenticationError extends Error {
  final String message;

  AuthenticationError(this.message);

  @override
  String toString() {
    return 'AuthenticationError: $message';
  }
}

class AuthenticationService {
  static final _authenticationService = AuthenticationService._internal();

  AuthenticationService._internal();

  factory AuthenticationService() => _authenticationService;

  Future<void> urlLauncher(Uri url) async {
    await launchUrl(url, mode: LaunchMode.inAppWebView);
  }

  Future<Identity> authenticate({
    required BuildContext context,
    String discoveryUrl = "https://auth.helpwave.de",
    String redirectUrl = "http://localhost:3000/",
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
    var client = Client(issuer, clientId);

    var authenticator = Authenticator(
      client,
      scopes: scopes,
      urlLancher: (url) => urlLauncher(Uri.parse(url)),
    );

    Credential? credential;
    // starts the authentication
    try {
      credential = await authenticator.authorize();
    } catch (e) {
      print(e);
      throw AuthenticationError("Failed to receive Credentials");
    } finally {
      await closeInAppWebView();
    }

    UserInfo userInfo = await credential.getUserInfo();

    return Identity(
      credential: credential,
      id: userInfo.subject,
      email: userInfo.email ?? "",
      name: userInfo.name ?? "",
      nickName: userInfo.nickname ?? "",
      organizations: /* TODO userInfo.getTyped("organizations") ?? */ [],
    );
  }

  // TODO method for checking the validity of the current token

  // TODO method for revoking the current token

  // TODO methods for making requests with token or ways to access the saved tokens
}
