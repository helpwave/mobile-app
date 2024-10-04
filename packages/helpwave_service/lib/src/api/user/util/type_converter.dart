import 'package:helpwave_service/src/api/user/data_types/invitation.dart' as user_lib;
import 'package:helpwave_proto_dart/services/user_svc/v1/organization_svc.pbenum.dart' as proto;

class UserGRPCTypeConverter {
  static proto.InvitationState invitationStateToGRPC(user_lib.InvitationState status) {
    switch (status) {
      case user_lib.InvitationState.unspecified:
        return proto.InvitationState.INVITATION_STATE_UNSPECIFIED;
      case user_lib.InvitationState.pending:
        return proto.InvitationState.INVITATION_STATE_PENDING;
      case user_lib.InvitationState.accepted:
        return proto.InvitationState.INVITATION_STATE_ACCEPTED;
      case user_lib.InvitationState.rejected:
        return proto.InvitationState.INVITATION_STATE_REJECTED;
      case user_lib.InvitationState.revoked:
        return proto.InvitationState.INVITATION_STATE_REVOKED;
    }
  }

  static user_lib.InvitationState invitationStateFromGRPC(proto.InvitationState status) {
    switch (status) {
      case proto.InvitationState.INVITATION_STATE_PENDING:
        return user_lib.InvitationState.pending;
      case proto.InvitationState.INVITATION_STATE_ACCEPTED:
        return user_lib.InvitationState.accepted;
      case proto.InvitationState.INVITATION_STATE_REJECTED:
        return user_lib.InvitationState.rejected;
      case proto.InvitationState.INVITATION_STATE_REVOKED:
        return user_lib.InvitationState.revoked;
      default:
        return user_lib.InvitationState.unspecified;
    }
  }
}
