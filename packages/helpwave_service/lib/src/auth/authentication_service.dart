import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  AuthenticationIdentityError(String message) : super("AuthenticationIdentityError", message);
}

/// The Service for authenticating a user against our user management system
///
/// A successful authentication provides a [Identity]
class AuthenticationService {
  final idTokenStorageKey = "auth-id-token";
  final accessStorageKey = "auth-access-token";
  final refreshStorageKey = "auth-refresh-token";
  final expiresStorageKey = "auth-expires-at";
  final storage = const FlutterSecureStorage();
  String discoveryUrl = "https://auth.helpwave.de";
  String clientId = "425f8b8d-c786-4ff7-b2bf-e52f505fb588";
  List<String> scopes = const ["openid", "offline_access", "email", "nickname", "name", "organizations"];

  // Singleton
  static final _authenticationService = AuthenticationService._internal();

  // private constructor for Singleton
  AuthenticationService._internal();

  factory AuthenticationService() => _authenticationService;

  /// Launches the provided URL
  Future<void> _urlLauncher(Uri url) async {
    await launchUrl(url, mode: LaunchMode.inAppWebView);
  }

  Future<Client> getClient() async {
    var issuer = await Issuer.discover(Uri.parse(discoveryUrl));
    Client client = Client(issuer, clientId);
    return client;
  }

  /// The method for letting the user authenticate themself against our user management system
  ///
  /// Returns the [Identity] of the user or throws either a [AuthenticationError] or [AuthenticationIdentityError]
  Future<Identity> tryTokenThenLogin() async {
    Identity? identityFromTokens = await tokenLogin();
    // TODO properly verify expiry of token

    if (identityFromTokens != null) {
      return identityFromTokens;
    } else {
      return await webLogin();
    }
  }

  /// Login with the tokens
  Future<Identity?> tokenLogin() async {
    Client client = await getClient();
    Credential? credential = await _fromTokens(client);
    if (credential == null) {
      return null;
    }
    UserInfo userInfo = await credential.getUserInfo();
    return _toIdentity(credential, userInfo);
  }

  /// Login with the in app view to create new tokens
  Future<Identity> webLogin() async {
    Client client = await getClient();
    Authenticator authenticator = Authenticator(
      client,
      scopes: scopes,
      urlLancher: (url) => _urlLauncher(Uri.parse(url)),
    );
    Credential? credential;
    // starts the authentication
    try {
      credential = await authenticator.authorize();
      await closeInAppWebView();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw AuthenticationError("Failed to receive Credentials");
    }

    TokenResponse tokenResponse = await credential.getTokenResponse();
    await storage.write(key: idTokenStorageKey, value: credential.idToken.toCompactSerialization());
    await storage.write(key: accessStorageKey, value: tokenResponse.accessToken);
    await storage.write(key: refreshStorageKey, value: credential.refreshToken);
    await storage.write(key: expiresStorageKey, value: (tokenResponse.expiresAt ?? DateTime.now()).toIso8601String());

    // try to obtain and parse the user information
    UserInfo userInfo = await credential.getUserInfo();
    return _toIdentity(credential, userInfo);
  }

  /// Check whether all necessary tokens are available
  ///
  /// A precondition for [tokenLogin]
  Future<bool> hasSavedToken() async {
    String? idToken = await storage.read(key: idTokenStorageKey);
    String? accessToken = await storage.read(key: accessStorageKey);
    String? refreshToken = await storage.read(key: refreshStorageKey);
    String? expiresAt = await storage.read(key: expiresStorageKey);
    return idToken != null && accessToken != null && refreshToken != null && expiresAt != null;
  }

  /// Creates a [Credential] form the token data
  Future<Credential?> _fromTokens(Client client) async {
    String? idToken = await storage.read(key: idTokenStorageKey);
    String? accessToken = await storage.read(key: accessStorageKey);
    String? refreshToken = await storage.read(key: refreshStorageKey);
    String? expiresAt = await storage.read(key: expiresStorageKey);
    if (idToken != null && accessToken != null && refreshToken != null && expiresAt != null) {
      return client.createCredential(
        idToken: idToken,
        refreshToken: refreshToken,
        accessToken: accessToken,
        expiresAt: DateTime.parse(expiresAt),
      );
    }
    return null;
  }

  /// Maps [Credential] information and [UserInfo] to a [Identity]
  Identity _toIdentity(Credential credential, UserInfo userInfo) {
    try {
      return Identity(
        credential: credential,
        idToken: credential.idToken.toCompactSerialization(),
        id: userInfo.subject,
        email: userInfo.email!,
        name: userInfo.name!,
        nickName: userInfo.nickname!,
        organizations: userInfo.getTypedList<String>("organizations") ?? [],
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw AuthenticationIdentityError("Could not get the full user information");
    }
  }

  /// Revokes the current token
  revoke() {
    // TODO method for revoking the current token on the serverside
    storage.delete(key: idTokenStorageKey);
    storage.delete(key: accessStorageKey);
    storage.delete(key: refreshStorageKey);
  }

// TODO method for checking the validity of the current token
}
