import '../data_types/invitation.dart';

class InvitationOfflineService {
  List<Invitation> invitations = [];

  Invitation? find(String id) {
    int index = invitations.indexWhere((org) => org.id == id);
    if (index == -1) {
      return null;
    }
    return invitations[index];
  }

  List<Invitation> findInvitations() {
    return invitations;
  }

  void create(Invitation invitation) {
    invitations.add(invitation);
  }

  void changeState(String invitationId, InvitationState state) {
    bool found = false;
    invitations = invitations.map((invite) {
      if (invite.id == invitationId) {
        found = true;
        return invite.copyWith(state: state);
      }
      return invite;
    }).toList();

    if (!found) {
      throw Exception("ChangeState: Could not find invitation with id $invitationId");
    }
  }

  void delete(String invitationId) {
    invitations.removeWhere((org) => org.id == invitationId);
  }
}
