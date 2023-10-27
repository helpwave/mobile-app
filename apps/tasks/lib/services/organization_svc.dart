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

  /// Loads the members of an [Organization] as [User]s
  Future<List<User>> getMembersByOrganization(String organizationId) async {
    GetMembersByOrganizationRequest request = GetMembersByOrganizationRequest(id: organizationId);
    GetMembersByOrganizationResponse response = await organizationService.getMembersByOrganization(request,
        options: CallOptions(metadata: GRPCClientService().getUserServiceMetaData(organizationId: organizationId)));

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
