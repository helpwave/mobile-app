import 'package:openid_client/openid_client.dart';

/// The user from the identity provider
class Identity {
  // Maybe make this more abstract
  /// The openid_client credential to get a new id token or refetch the information
  Credential credential;

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

  Identity({
    required this.credential,
    required this.id,
    required this.email,
    required this.nickName,
    required this.name,
    required this.organizations,
  });
}
