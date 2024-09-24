import '../../../../user.dart';

enum InvitationState {
  unspecified,
  pending,
  accepted,
  rejected,
  revoked,
}

class Invitation {
  String id;
  InvitationState state;

  /// The email of the invited [User]
  String email;

  /// The identifier of the [Organization] to which the user is invited
  String organizationId;

  /// The [Organization]
  Organization? organization;

  Invitation({
    required this.id,
    required this.organizationId,
    required this.email,
    required this.state,
    this.organization
  }) : assert(organization == null || organizationId == organization.id);

  // CopyWith method
  Invitation copyWith({
    String? id,
    InvitationState? state,
    String? email,
    String? organizationId,
    Organization? organization,
  }) {
    return Invitation(
      id: id ?? this.id,
      state: state ?? this.state,
      email: email ?? this.email,
      organizationId: organizationId ?? this.organizationId,
      organization: organization ?? this.organization,
    );
  }
}
