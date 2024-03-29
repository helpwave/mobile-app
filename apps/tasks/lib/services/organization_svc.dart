import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/proto/services/user_svc/v1/organization_svc.pbgrpc.dart';
import 'package:tasks/dataclasses/organization.dart';
import 'package:tasks/dataclasses/user.dart';
import 'package:tasks/services/grpc_client_svc.dart';

/// The GRPC Service for [Organization]s
///
/// Provides queries and requests that load or alter [Organization] objects on the server
/// The server is defined in the underlying [GRPCClientService]
class OrganizationService {
  /// The GRPC ServiceClient which handles GRPC
  OrganizationServiceClient organizationService = GRPCClientService.getOrganizationServiceClient;

  /// Load a Organization by its identifier
  Future<Organization> getOrganization({required String id}) async {
    GetOrganizationRequest request = GetOrganizationRequest(id: id);
    GetOrganizationResponse response = await organizationService.getOrganization(
      request,
      options: CallOptions(metadata: GRPCClientService().getUserServiceMetaData(organizationId: id)),
    );

    // TODO use full information of request
    Organization organization = Organization(
      id: response.id,
      name: response.longName,
      shortName: response.shortName,
    );
    return organization;
  }

  /// Loads all Organizations for the current [User]
  Future<List<Organization>> getOrganizationsForUser() async {
    GetOrganizationsForUserRequest request = GetOrganizationsForUserRequest();
    GetOrganizationsForUserResponse response = await organizationService.getOrganizationsForUser(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getUserServiceMetaData(
          organizationId: GRPCClientService().fallbackOrganizationId,
        ),
      ),
    );

    List<Organization> organizations = response.organizations
        // TODO use full information of request
        .map((organization) => Organization(
              id: organization.id,
              name: organization.longName,
              shortName: organization.shortName,
            ))
        .toList();
    return organizations;
  }

  /// Loads the members of an [Organization] as [User]s
  Future<List<User>> getMembersByOrganization(String organizationId) async {
    GetMembersByOrganizationRequest request = GetMembersByOrganizationRequest(id: organizationId);
    GetMembersByOrganizationResponse response = await organizationService.getMembersByOrganization(
      request,
      options: CallOptions(
        metadata: GRPCClientService().getUserServiceMetaData(organizationId: organizationId),
      ),
    );

    List<User> users = response.members
        .map((member) => User(
              id: member.userId,
              name: member.nickname, // TODO replace this
              nickName: member.nickname,
              profile: Uri.parse(member.avatarUrl),
            ))
        .toList();
    return users;
  }
}
