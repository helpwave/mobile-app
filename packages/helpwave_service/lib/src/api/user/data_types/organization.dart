import 'package:helpwave_service/src/api/util/identified_object.dart';

class OrganizationMinimal extends IdentifiedObject {
  String shortName;
  String longName;

  OrganizationMinimal({
    super.id,
    required this.shortName,
    required this.longName,
  });

  OrganizationMinimal copyWith({
    String? id,
    String? shortName,
    String? longName,
  }) {
    return OrganizationMinimal(
      id: id ?? this.id,
      shortName: shortName ?? this.shortName,
      longName: longName ?? this.longName,
    );
  }
}

/// data class for [Organization]
class Organization extends OrganizationMinimal {
  String avatarURL;
  String email;
  bool isPersonal;
  bool isVerified;

  Organization({
    super.id,
    required super.shortName,
    required super.longName,
    required this.avatarURL,
    required this.email,
    required this.isPersonal,
    required this.isVerified,
  });

  factory Organization.empty(String? id) => Organization(
        id: id ?? "",
        shortName: "",
        longName: "",
        avatarURL: "",
        email: "",
        isPersonal: false,
        isVerified: false,
      );

  @override
  Organization copyWith({
    String? id,
    String? shortName,
    String? longName,
    String? avatarURL,
    String? email,
    bool? isPersonal,
    bool? isVerified,
  }) {
    return Organization(
      id: id ?? this.id,
      shortName: shortName ?? this.shortName,
      longName: longName ?? this.longName,
      avatarURL: avatarURL ?? this.avatarURL,
      email: email ?? this.email,
      isPersonal: isPersonal ?? this.isPersonal,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  String get combinedName => "$longName ($shortName)";

  @override
  String toString() {
    return "$runtimeType{id: $id, name: $longName, shortName: $shortName}";
  }
}
