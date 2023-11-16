import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:helpwave_service/src/auth/identity.dart';
import 'package:jose/jose.dart';
import 'package:logger/logger.dart';
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
  /// Storage key for the id token
  final idTokenStorageKey = "auth-id-token";

  /// Storage key for the access token
  final accessStorageKey = "auth-access-token";

  /// Storage key for the refresh token
  final refreshStorageKey = "auth-refresh-token";

  /// Storage key for the expiry date of the tokens
  final expiresStorageKey = "auth-expires-at";

  /// The storage in which to save the tokens
  final storage = const FlutterSecureStorage();

  /// A Logger for logging
  final Logger _logger = Logger();

  /// The url used to discover the service
  ///
  /// May be changed by reassignment
  String discoveryUrl = "https://auth.helpwave.de";

  /// The client identifier used for establishing a authentication connection
  String clientId = "425f8b8d-c786-4ff7-b2bf-e52f505fb588";

  /// The scopes the return id token should contain
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

  /// The [Client] used for communication with the auth provider
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
      return await login();
    }
  }

  /// Login with the tokens
  Future<Identity?> tokenLogin() async {
    if (!await validate()) {
      return null;
    }
    Client client = await getClient();
    Credential? credential = await _fromTokens(client);
    if (credential == null) {
      return null;
    }
    UserInfo userInfo;
    try {
      userInfo = await credential.getUserInfo();
    } catch (e) {
      return null;
    }

    return _toIdentity(credential, userInfo);
  }

  /// Login with the in app view to create new tokens
  Future<Identity> login() async {
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
        _logger.e(e);
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
    List<String?> values = await Future.wait([
      storage.read(key: idTokenStorageKey),
      storage.read(key: accessStorageKey),
      storage.read(key: refreshStorageKey),
      storage.read(key: expiresStorageKey)
    ]);
    String? idToken = values[0];
    String? accessToken = values[1];
    String? refreshToken = values[2];
    String? expiresAt = values[3];
    return idToken != null && accessToken != null && refreshToken != null && expiresAt != null;
  }

  /// Creates a [Credential] form the token data
  Future<Credential?> _fromTokens(Client client) async {
    List<String?> values = await Future.wait([
      storage.read(key: idTokenStorageKey),
      storage.read(key: accessStorageKey),
      storage.read(key: refreshStorageKey),
      storage.read(key: expiresStorageKey)
    ]);
    String? idToken = values[0];
    String? accessToken = values[1];
    String? refreshToken = values[2];
    String? expiresAt = values[3];
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
        _logger.e(e);
      }
      throw AuthenticationIdentityError("Could not get the full user information");
    }
  }

  Future<void> clearFromStorage() async {
    await storage.delete(key: idTokenStorageKey);
    await storage.delete(key: accessStorageKey);
    await storage.delete(key: refreshStorageKey);
    await storage.delete(key: expiresStorageKey);
  }

  /// Revokes the current token
  Future<void> revoke() async {
    Identity? identity = await tokenLogin();
    if (identity != null) {
      // TODO revoke the credential server sided
      // await identity.credential?.revoke();
    }
    await clearFromStorage();
  }

  /// Validate the saved token
  Future<bool> validate() async {
    Client client = await getClient();
    Credential? credential = await _fromTokens(client);
    if (credential == null) {
      return false;
    }

    TokenResponse tokenResponse;
    try {
      tokenResponse = await credential.getTokenResponse();
    } catch (e) {
      if (kDebugMode) {
        _logger.e(e);
      }
      return false;
    }
    if (tokenResponse.expiresAt == null) {
      return false;
    }

    // check expiry
    if (tokenResponse.expiresAt!.compareTo(DateTime.now()) < 0) {
      return false;
    }

    var keyStore = JsonWebKeyStore();
    var jwksUri = client.issuer.metadata.jwksUri;
    if (jwksUri != null) {
      keyStore.addKeySetUrl(jwksUri);
    }
    if (!await credential.idToken.verify(
      keyStore,
      allowedArguments: client.issuer.metadata.idTokenSigningAlgValuesSupported,
    )) {
      return false;
    }
    return true;
  }
}
