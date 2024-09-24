import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/user_svc/v1/organization_svc.pbgrpc.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/src/api/user/data_types/invitation.dart' as invitation;
import 'package:helpwave_service/src/api/user/user_api_service_clients.dart';
import 'package:helpwave_service/src/api/user/util/type_converter.dart';
import '../data_types/index.dart';

/// The GRPC Service for [Organization]s
///
/// Provides queries and requests that load or alter [Organization] objects on the server
/// The server is defined in the underlying [UserAPIServiceClients]
class OrganizationService {
  /// The GRPC ServiceClient which handles GRPC
  OrganizationServiceClient organizationService = UserAPIServiceClients().organizationServiceClient;

  /// Load a Organization by its identifier
  Future<Organization> getOrganization({required String id}) async {
    GetOrganizationRequest request = GetOrganizationRequest(id: id);
    GetOrganizationResponse response = await organizationService.getOrganization(
      request,
      options: CallOptions(metadata: UserAPIServiceClients().getMetaData(organizationId: id)),
    );

    Organization organization = Organization(
        id: response.id,
        longName: response.longName,
        shortName: response.shortName,
        avatarURL: response.avatarUrl,
        email: response.contactEmail,
        isVerified: true,
        isPersonal: response.isPersonal);
    return organization;
  }

  /// Loads all Organizations for the current [User]
  Future<List<Organization>> getOrganizationsForUser() async {
    GetOrganizationsForUserRequest request = GetOrganizationsForUserRequest();
    GetOrganizationsForUserResponse response = await organizationService.getOrganizationsForUser(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(
          organizationId: AuthenticationUtility.fallbackOrganizationId,
        ),
      ),
    );

    List<Organization> organizations = response.organizations
        .map((organization) => Organization(
            id: organization.id,
            longName: organization.longName,
            shortName: organization.shortName,
            avatarURL: organization.avatarUrl,
            email: organization.contactEmail,
            isVerified: true,
            isPersonal: organization.isPersonal))
        .toList();
    return organizations;
  }

  Future<void> update({
    required String id,
    String? shortName,
    String? longName,
    String? email,
    bool? isPersonal,
    String? avatarUrl,
  }) async {
    UpdateOrganizationRequest request = UpdateOrganizationRequest(
      id: id,
      longName: longName,
      shortName: shortName,
      isPersonal: isPersonal,
      contactEmail: email,
      avatarUrl: avatarUrl,
    );
    await organizationService.updateOrganization(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(organizationId: id),
      ),
    );
  }

  Future<void> delete(String id) async {
    DeleteOrganizationRequest request = DeleteOrganizationRequest(id: id);
    await organizationService.deleteOrganization(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(organizationId: id),
      ),
    );
  }

  /// Loads the members of an [Organization] as [User]s
  Future<List<User>> getMembersByOrganization(String organizationId) async {
    GetMembersByOrganizationRequest request = GetMembersByOrganizationRequest(id: organizationId);
    GetMembersByOrganizationResponse response = await organizationService.getMembersByOrganization(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(organizationId: organizationId),
      ),
    );

    List<User> users = response.members
        .map((member) => User(
              id: member.userId,
              name: member.nickname,
              // TODO replace this
              nickName: member.nickname,
              email: member.email,
              profileUrl: Uri.parse(member.avatarUrl),
            ))
        .toList();
    return users;
  }

  Future<void> addMember({required String organizationId, required String userId}) async {
    AddMemberRequest request = AddMemberRequest(id: organizationId, userId: userId);
    await organizationService.addMember(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(organizationId: organizationId),
      ),
    );
  }

  Future<void> removeMember({required String organizationId, required String userId}) async {
    RemoveMemberRequest request = RemoveMemberRequest(id: organizationId, userId: userId);
    await organizationService.removeMember(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(organizationId: organizationId),
      ),
    );
  }

  Future<invitation.Invitation> inviteMember({required String organizationId, required String email}) async {
    InviteMemberRequest request = InviteMemberRequest(organizationId: organizationId, email: email);
    InviteMemberResponse response = await organizationService.inviteMember(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(organizationId: organizationId),
      ),
    );

    return invitation.Invitation(
      id: response.id,
      organizationId: organizationId,
      email: email,
      state: invitation.InvitationState.pending,
    );
  }

  Future<List<invitation.Invitation>> getInvitationsByOrganization({
    required String organizationId,
    invitation.InvitationState? state,
  }) async {
    GetInvitationsByOrganizationRequest request = GetInvitationsByOrganizationRequest(
      organizationId: organizationId,
      state: state == null ? null : UserGRPCTypeConverter.invitationStateToGRPC(state),
    );

    GetInvitationsByOrganizationResponse response = await organizationService.getInvitationsByOrganization(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(organizationId: organizationId),
      ),
    );

    return response.invitations.map((invite) => invitation.Invitation(
      id: invite.id,
      organizationId: organizationId,
      email: invite.email,
      state: UserGRPCTypeConverter.invitationStateFromGRPC(invite.state),
    )).toList();
  }

  Future<List<invitation.Invitation>> getInvitationsByUser({
    required String organizationId,
    invitation.InvitationState? state,
  }) async {
    GetInvitationsByUserRequest request = GetInvitationsByUserRequest(
      state: state == null ? null : UserGRPCTypeConverter.invitationStateToGRPC(state),
    );

    GetInvitationsByUserResponse response = await organizationService.getInvitationsByUser(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(organizationId: organizationId),
      ),
    );

    return response.invitations.map((invite) => invitation.Invitation(
      id: invite.id,
      organizationId: organizationId,
      email: invite.email,
      state: UserGRPCTypeConverter.invitationStateFromGRPC(invite.state),
    )).toList();
  }

  Future<void> acceptInvitation({required String invitationId}) async {
    AcceptInvitationRequest request = AcceptInvitationRequest(invitationId: invitationId);
    await organizationService.acceptInvitation(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(organizationId: CurrentWardService().currentWard!.organizationId),
      ),
    );
  }

  Future<void> declineInvitation({required String invitationId}) async {
    DeclineInvitationRequest request = DeclineInvitationRequest(invitationId: invitationId);
    await organizationService.declineInvitation(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(organizationId: CurrentWardService().currentWard!.organizationId),
      ),
    );
  }

  Future<void> revokeInvitation({required String invitationId}) async {
    RevokeInvitationRequest request = RevokeInvitationRequest(invitationId: invitationId);
    await organizationService.revokeInvitation(
      request,
      options: CallOptions(
        metadata: UserAPIServiceClients().getMetaData(organizationId: CurrentWardService().currentWard!.organizationId),
      ),
    );
  }
}
