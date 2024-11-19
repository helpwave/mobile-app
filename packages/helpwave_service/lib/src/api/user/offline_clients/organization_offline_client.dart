import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/user_svc/v1/organization_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/offline/offline_client_store.dart';
import 'package:helpwave_service/src/api/offline/util.dart';
import 'package:helpwave_service/src/api/user/util/type_converter.dart';
import 'package:helpwave_service/user.dart';
import '../data_types/invitation.dart' as invite_types;

class OrganizationUpdate {
  String id;
  String? shortName;
  String? longName;
  String? email;
  bool? isPersonal;
  String? avatarURL;

  OrganizationUpdate({
    required this.id,
    this.shortName,
    this.longName,
    this.email,
    this.isPersonal,
    this.avatarURL,
  });
}

class OrganizationOfflineService {
  List<Organization> organizations = [];

  Organization? find(String id) {
    int index = organizations.indexWhere((org) => org.id == id);
    if (index == -1) {
      return null;
    }
    return organizations[index];
  }

  List<Organization> findOrganizations() {
    return organizations;
  }

  void create(Organization organization) {
    organizations.add(organization);
  }

  void update(OrganizationUpdate organizationUpdate) {
    bool found = false;
    organizations = organizations.map((org) {
      if (org.id == organizationUpdate.id) {
        found = true;
        return org.copyWith(
            shortName: organizationUpdate.shortName,
            longName: organizationUpdate.longName,
            avatarURL: organizationUpdate.avatarURL,
            email: organizationUpdate.email,
            isPersonal: organizationUpdate.isPersonal);
      }
      return org;
    }).toList();

    if (!found) {
      throw Exception("UpdateOrganization: Could not find organization with id ${organizationUpdate.id}");
    }
  }

  void delete(String organizationId) {
    organizations.removeWhere((org) => org.id == organizationId);
    // Assuming WardOfflineService handles related deletions (Wards, etc.)
    // WardOfflineService.deleteByOrganization(organizationId);
  }
}

class OrganizationOfflineClient extends OrganizationServiceClient {
  OrganizationOfflineClient(super.channel);

  @override
  ResponseFuture<CreateOrganizationResponse> createOrganization(CreateOrganizationRequest request,
      {CallOptions? options}) {
    final newOrganization = Organization(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      shortName: request.shortName,
      longName: request.longName,
      avatarURL: 'https://helpwave.de/favicon.ico',
      email: request.contactEmail,
      isPersonal: request.isPersonal,
      isVerified: true,
    );

    OfflineClientStore().organizationStore.create(newOrganization);

    return MockResponseFuture.value(CreateOrganizationResponse()..id = newOrganization.id);
  }

  @override
  ResponseFuture<GetOrganizationResponse> getOrganization(GetOrganizationRequest request, {CallOptions? options}) {
    final organization = OfflineClientStore().organizationStore.find(request.id);

    if (organization == null) {
      throw Exception("GetOrganization: Could not find organization with id ${request.id}");
    }

    final members =
        OfflineClientStore().userStore.findUsers().map((user) => GetOrganizationMember()..userId = user.id).toList();

    return MockResponseFuture.value(GetOrganizationResponse()
      ..id = organization.id
      ..shortName = organization.shortName
      ..longName = organization.longName
      ..avatarUrl = organization.avatarURL
      ..contactEmail = organization.email
      ..isPersonal = organization.isPersonal
      ..members.addAll(members));
  }

  @override
  ResponseFuture<GetOrganizationsByUserResponse> getOrganizationsByUser(GetOrganizationsByUserRequest request,
      {CallOptions? options}) {
    final organizations = OfflineClientStore().organizationStore.findOrganizations().map((org) {
      final members = OfflineClientStore()
          .userStore
          .findUsers()
          .map((user) => GetOrganizationsByUserResponse_Organization_Member()..userId = user.id)
          .toList();

      return GetOrganizationsByUserResponse_Organization()
        ..id = org.id
        ..shortName = org.shortName
        ..longName = org.longName
        ..contactEmail = org.email
        ..avatarUrl = org.avatarURL
        ..members.addAll(members)
        ..isPersonal = org.isPersonal;
    }).toList();

    return MockResponseFuture.value(GetOrganizationsByUserResponse()..organizations.addAll(organizations));
  }

  @override
  ResponseFuture<GetOrganizationsForUserResponse> getOrganizationsForUser(GetOrganizationsForUserRequest request,
      {CallOptions? options}) {
    final organizations = OfflineClientStore().organizationStore.findOrganizations().map((org) {
      final members = OfflineClientStore()
          .userStore
          .findUsers()
          .map((user) => GetOrganizationsForUserResponse_Organization_Member()..userId = user.id)
          .toList();

      return GetOrganizationsForUserResponse_Organization()
        ..id = org.id
        ..shortName = org.shortName
        ..longName = org.longName
        ..contactEmail = org.email
        ..avatarUrl = org.avatarURL
        ..members.addAll(members)
        ..isPersonal = org.isPersonal;
    }).toList();

    return MockResponseFuture.value(GetOrganizationsForUserResponse()..organizations.addAll(organizations));
  }

  @override
  ResponseFuture<UpdateOrganizationResponse> updateOrganization(UpdateOrganizationRequest request,
      {CallOptions? options}) {
    final update = OrganizationUpdate(
      id: request.id,
      shortName: request.hasShortName() ? request.shortName : null,
      longName: request.hasLongName() ? request.longName : null,
      email: request.hasContactEmail() ? request.contactEmail : null,
      avatarURL: request.hasAvatarUrl() ? request.avatarUrl : null,
      isPersonal: request.hasIsPersonal() ? request.isPersonal : null,
    );

    try {
      OfflineClientStore().organizationStore.update(update);
      return MockResponseFuture.value(UpdateOrganizationResponse());
    } catch (e) {
      return MockResponseFuture.error(e);
    }
  }

  @override
  ResponseFuture<DeleteOrganizationResponse> deleteOrganization(DeleteOrganizationRequest request,
      {CallOptions? options}) {
    try {
      OfflineClientStore().organizationStore.delete(request.id);
      return MockResponseFuture.value(DeleteOrganizationResponse());
    } catch (e) {
      return MockResponseFuture.error(e);
    }
  }

  // Other missing methods

  @override
  ResponseFuture<GetMembersByOrganizationResponse> getMembersByOrganization(GetMembersByOrganizationRequest request,
      {CallOptions? options}) {
    final organization = OfflineClientStore().organizationStore.find(request.id);

    if (organization == null) {
      throw Exception("GetMembersByOrganization: Could not find organization with id ${request.id}");
    }

    final members = OfflineClientStore()
        .userStore
        .findUsers()
        .map((user) => GetMembersByOrganizationResponse_Member()
          ..userId = user.id
          ..email = user.email
          ..nickname = user.nickName
          ..avatarUrl = user.profileUrl.toString())
        .toList();

    return MockResponseFuture.value(GetMembersByOrganizationResponse()..members.addAll(members));
  }

  @override
  ResponseFuture<GetInvitationsByOrganizationResponse> getInvitationsByOrganization(
      GetInvitationsByOrganizationRequest request,
      {CallOptions? options}) {
    List<invite_types.Invitation> invitations = OfflineClientStore()
        .invitationStore
        .invitations
        .where((element) => element.organizationId == request.organizationId)
        .toList();
    if (request.hasState()) {
      final invitationState = UserGRPCTypeConverter.invitationStateFromGRPC(request.state);
      invitations = invitations.where((element) => element.state == invitationState).toList();
    }

    final response = GetInvitationsByOrganizationResponse(
        invitations: invitations.map((invitation) => GetInvitationsByOrganizationResponse_Invitation(
              id: invitation.id,
              organizationId: invitation.organizationId,
              email: invitation.email,
              state: UserGRPCTypeConverter.invitationStateToGRPC(invitation.state),
            )));

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<GetInvitationsByUserResponse> getInvitationsByUser(GetInvitationsByUserRequest request,
      {CallOptions? options}) {
    final user = OfflineClientStore().userStore.users[0];
    List<invite_types.Invitation> invitations =
        OfflineClientStore().invitationStore.invitations.where((element) => element.organizationId == user.id).toList();
    if (request.hasState()) {
      final invitationState = UserGRPCTypeConverter.invitationStateFromGRPC(request.state);
      invitations = invitations.where((element) => element.state == invitationState).toList();
    }

    final response = GetInvitationsByUserResponse(invitations: invitations.map((invitation) {
      final invite = GetInvitationsByUserResponse_Invitation(
        id: invitation.id,
        email: invitation.email,
        state: UserGRPCTypeConverter.invitationStateToGRPC(invitation.state),
      );
      final organization = OfflineClientStore().organizationStore.find(invitation.organizationId)!;
      invite.organization = GetInvitationsByUserResponse_Invitation_Organization(
        id: organization.id,
        longName: organization.longName,
        avatarUrl: organization.avatarURL,
      );
      return invite;
    }));

    return MockResponseFuture.value(response);
  }

  @override
  ResponseFuture<InviteMemberResponse> inviteMember(InviteMemberRequest request, {CallOptions? options}) {
    assert(OfflineClientStore().userStore.users.indexWhere((element) => element.email == request.email) != -1);
    assert(OfflineClientStore().invitationStore.invitations.indexWhere(
            (element) => element.organizationId == request.organizationId && element.email == request.email) == -1);

    final invite = invite_types.Invitation(
      id: DateTime.now().toString(),
      organizationId: request.organizationId,
      email: request.email,
      state: invite_types.InvitationState.pending,
    );

    return MockResponseFuture.value(InviteMemberResponse(id: invite.id));
  }

  @override
  ResponseFuture<RevokeInvitationResponse> revokeInvitation(RevokeInvitationRequest request, {CallOptions? options}) {
    final invite  = OfflineClientStore().invitationStore.find(request.invitationId);

    if(invite == null){
      throw "Invitation with id ${request.invitationId} not found";
    }
    if(invite_types.InvitationState.pending != invite.state){
      throw "Only pending Invitations can be revoked";
    }
    OfflineClientStore().invitationStore.changeState(request.invitationId, invite_types.InvitationState.accepted);

    return MockResponseFuture.value(RevokeInvitationResponse());
  }

  @override
  ResponseFuture<AcceptInvitationResponse> acceptInvitation(AcceptInvitationRequest request, {CallOptions? options}) {
    final invite  = OfflineClientStore().invitationStore.find(request.invitationId);

    if(invite == null){
      throw "Invitation with id ${request.invitationId} not found";
    }
    if(invite_types.InvitationState.pending != invite.state){
      throw "Only pending Invitations can be accepted";
    }
    OfflineClientStore().invitationStore.changeState(request.invitationId, invite_types.InvitationState.accepted);

    return MockResponseFuture.value(AcceptInvitationResponse());
  }

  @override
  ResponseFuture<DeclineInvitationResponse> declineInvitation(DeclineInvitationRequest request,
      {CallOptions? options}) {
    final invite  = OfflineClientStore().invitationStore.find(request.invitationId);

    if(invite == null){
      throw "Invitation with id ${request.invitationId} not found";
    }
    if(invite_types.InvitationState.pending != invite.state){
      throw "Only pending Invitations can be de";
    }
    OfflineClientStore().invitationStore.changeState(request.invitationId, invite_types.InvitationState.accepted);

    return MockResponseFuture.value(DeclineInvitationResponse());
  }

  @override
  ResponseFuture<AddMemberResponse> addMember(AddMemberRequest request, {CallOptions? options}) {
    return MockResponseFuture.value(AddMemberResponse());
  }

  @override
  ResponseFuture<RemoveMemberResponse> removeMember(RemoveMemberRequest request, {CallOptions? options}) {
    return MockResponseFuture.value(RemoveMemberResponse());
  }
}
