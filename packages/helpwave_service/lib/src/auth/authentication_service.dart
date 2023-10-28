import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helpwave_service/src/auth/identity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:openid_client/openid_client_io.dart';

/// A [Error] with a message
class ErrorWithNameAndMessage extends Error {
  /// The name of the error to discern its type
  final String name;

  /// The error message
  final String message;

  ErrorWithNameAndMessage(this.name, this.message);

  @override
  String toString() {
    return '$name: $message';
  }
}

/// A [Error] when the Authentication workflow fails
class AuthenticationError extends ErrorWithNameAndMessage {
  AuthenticationError(String message) : super("AuthenticationError", message);
}

/// A Error when the [Identity] can't be extracted from the Authentication workflow
class AuthenticationIdentityError extends ErrorWithNameAndMessage {
  AuthenticationIdentityError(String message)
      : super("AuthenticationIdentityError", message);
}

/// The Service for authenticating a user against our user management system
///
/// A successful authentication provides a [Identity]
class AuthenticationService {
  // Singleton
  static final _authenticationService = AuthenticationService._internal();

  // private constructor for Singleton
  AuthenticationService._internal();

  factory AuthenticationService() => _authenticationService;

  /// Launches the provided URL
  Future<void> _urlLauncher(Uri url) async {
    await launchUrl(url, mode: LaunchMode.inAppWebView);
  }

  /// The method for letting the user authenticate themself against our user management system
  ///
  /// Returns the [Identity] of the user or throws either a [AuthenticationError] or [AuthenticationIdentityError]
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
      urlLancher: (url) => _urlLauncher(Uri.parse(url)),
    );

    Credential? credential;
    // starts the authentication
    try {
      credential = await authenticator.authorize();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw AuthenticationError("Failed to receive Credentials");
    } finally {
      await closeInAppWebView();
    }

    UserInfo userInfo = await credential.getUserInfo();
    try {
      return Identity(
        credential: credential,
        id: userInfo.subject,
        email: userInfo.email!,
        name: userInfo.name!,
        nickName: userInfo.nickname!,
        organizations: /* TODO userInfo.getTyped("organizations") ?? */ [],
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw AuthenticationIdentityError(
          "Could not get the full user information");
    }
  }

// TODO method for checking the validity of the current token

// TODO method for revoking the current token

// TODO methods for making requests with token or ways to access the saved tokens
}
