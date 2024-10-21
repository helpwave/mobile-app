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
        idToken: "eyJzdWIiOiIxODE1OTcxMy01ZDRlLTRhZDUtOTRhZC1mYmI2YmIxNDc5ODQiLCJlbWFpbCI6Im1heC5tdXN0ZXJtYW5uQGhlbHB"
            "3YXZlLmRlIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsIm5hbWUiOiJNYXggTXVzdGVybWFubiIsInByZWZlcnJlZF91c2Vybm"
            "FtZSI6Im1heC5tdXN0ZXJtYW5uIiwiZ2l2ZW5fbmFtZSI6Ik1heCIsImZhbWlseV9uYW1lIjoiTXVzdGVybWFubiIsIm9yZ2FuaXphdG"
            "lvbiI6eyJpZCI6IjNiMjVjNmY1LTQ3MDUtNDA3NC05ZmM2LWE1MGMyOGViYTQwNiIsIm5hbWUiOiJoZWxwd2F2ZSB0ZXN0In19",
        // TODO add a default here
        id: "bb560b25-45b6-4a84-87f1-408e8c32dec8",
        name: "Max Mustermann",
        nickName: "Max M.",
        email: "max.mustermann@helpwave.de",
        organizations: ['bb560b25-45b6-4a84-87f1-408e8c32dec8']);
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
