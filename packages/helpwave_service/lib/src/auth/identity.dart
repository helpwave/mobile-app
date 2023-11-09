import 'package:openid_client/openid_client.dart';

/// The user from the identity provider
class Identity {
  // Maybe make this more abstract
  /// The identifier token
  String idToken;

  /// The identifier of the [Identity]
  String id;

  /// The email of the [Identity]
  String email;

  /// The nickname of the [Identity]
  ///
  /// Most likely a informal or shortened version of the [name]
  String nickName;

  /// The full name of the [Identity]
  String name;

  /// The identifier of the organizations the user is part of
  List<String> organizations;

  /// The openid_client credential to get a new id token or refetch the information
  Credential? credential;

  String get firstOrganization => organizations.first;

  /// The default login data
  factory Identity.defaultIdentity() {
    return Identity(
        idToken:
            "eyJzdWIiOiIxODE1OTcxMy01ZDRlLTRhZDUtOTRhZC1mYmI2YmIxNDc5ODQiLCJuYW1lIjoiTWF4IE11c3Rlcm1hbm4iLCJuaWNrbmFt"
            "ZSI6Im1heC5tdXN0ZXJtYW5uIiwiZW1haWwiOiJtYXgubXVzdGVybWFubkBoZWxwd2F2ZS5kZSIsIm9yZ2FuaXphdGlvbnMiOlsiM2IyNWM2ZjUtNDcwNS00MDc0LTlmYzYtYTUwYzI4ZWJhNDA2Il19",
        // TODO add a default here
        id: "",
        name: "Max Mustermann",
        nickName: "Max M.",
        email: "max.mustermann@helpwave.de",
        organizations: ['3b25c6f5-4705-4074-9fc6-a50c28eba406']);
  }

  Identity({
    required this.idToken,
    required this.id,
    required this.email,
    required this.nickName,
    required this.name,
    required this.organizations,
    this.credential,
  });
}
