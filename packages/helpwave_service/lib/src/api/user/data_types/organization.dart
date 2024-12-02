import 'package:helpwave_service/src/config.dart';
import 'package:helpwave_service/util.dart';

class OrganizationDetails implements CopyWithInterface<OrganizationDetails, OrganizationUpdate> {
  String avatarURL;
  String email;
  bool isPersonal;
  bool isVerified;

  OrganizationDetails({
    required this.email,
    required this.avatarURL,
    required this.isPersonal,
    required this.isVerified,
  });

  factory OrganizationDetails.empty() => OrganizationDetails(
        email: "test@helpwave.de",
        avatarURL: avatarFallBackURL,
        isPersonal: false,
        isVerified: false,
      );

  @override
  OrganizationDetails copyWith(OrganizationUpdate? update) {
    return OrganizationDetails(
      email: update?.email ?? email,
      avatarURL: update?.avatarURL ?? avatarURL,
      isPersonal: update?.isPersonal ?? isPersonal,
      isVerified: update?.isVerified ?? isVerified,
    );
  }
}

class OrganizationUpdate {
  String? id;
  String? shortName;
  String? longName;
  bool? isPersonal;
  bool? isVerified;
  String? avatarURL;
  String? email;

  OrganizationUpdate({
    this.id,
    this.shortName,
    this.longName,
    this.isPersonal,
    this.isVerified,
    this.avatarURL,
    this.email,
  });
}

/// data class for [Organization]
class Organization extends IdentifiedObject<String>
    implements CRUDObject<String, Organization, Organization, OrganizationUpdate> {
  String shortName;
  String longName;
  OrganizationDetails? details;

  bool get hasDetails => details != null;

  Organization({super.id, required this.shortName, required this.longName, this.details});

  factory Organization.empty({String? id, bool hasEmptyDetails = true}) => Organization(
        id: id,
        shortName: "ORG",
        longName: "Organization Name",
        details: hasEmptyDetails ? OrganizationDetails.empty() : null,
      );

  @override
  Organization create(String id) => copyWith(OrganizationUpdate(id: id));

  @override
  Organization copyWith(OrganizationUpdate? update) {
    return Organization(
        id: update?.id ?? id,
        shortName: update?.shortName ?? shortName,
        longName: update?.longName ?? longName,
        details: details?.copyWith(update));
  }

  String get combinedName => "$longName ($shortName)";

  @override
  String toString() {
    return "$runtimeType{id: $id, name: $longName, shortName: $shortName}";
  }
}
