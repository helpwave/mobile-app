import 'package:openid_client/openid_client.dart';

/// The user from the identity provider
class Identity {
  Credential credential;
  String id;
  String email;
  String nickName;
  String name;
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
