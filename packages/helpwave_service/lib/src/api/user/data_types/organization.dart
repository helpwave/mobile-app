class OrganizationMinimal {
  String id;
  String shortName;
  String longName;

  OrganizationMinimal({
    required this.id,
    required this.shortName,
    required this.longName,
  });
}

/// data class for [Organization]
class Organization extends OrganizationMinimal {
  String avatarURL;
  String email;
  bool isPersonal;
  bool isVerified;

  Organization({
    required super.id,
    required super.shortName,
    required super.longName,
    required this.avatarURL,
    required this.email,
    required this.isPersonal,
    required this.isVerified,
  });

  Organization copyWith({
    String? shortName,
    String? longName,
    String? avatarURL,
    String? email,
    bool? isPersonal,
    bool? isVerified,
  }) {
    return Organization(
      id: id,
      // `id` is not changeable
      shortName: shortName ?? this.shortName,
      longName: longName ?? this.longName,
      avatarURL: avatarURL ?? this.avatarURL,
      email: email ?? this.email,
      isPersonal: isPersonal ?? this.isPersonal,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  String toString() {
    return "{id: $id, name: $longName, shortName: $shortName}";
  }
}
