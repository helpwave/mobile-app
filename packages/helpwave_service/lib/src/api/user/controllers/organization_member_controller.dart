import 'package:helpwave_service/src/api/user/data_types/invitation.dart';
import 'package:helpwave_util/loading.dart';
import '../../../../user.dart';

/// The Controller for managing a [Organization]'s [User]s
class OrganizationMemberController extends LoadingChangeNotifier {
  /// The id of the [Organization]
  final String organizationId;

  /// The current [User]s
  List<User> _members = [];

  /// The current [User]s
  List<User> get members => _members;

  set members(List<User> value) {
    _members = value;
    changeState(LoadingState.loaded);
  }

  /// The current [Invitation]s
  List<Invitation> _invitations = [];

  /// The current [Invitation]s
  List<Invitation> get invitations => _invitations;

  set invitations(List<Invitation> value) {
    _invitations = value;
    changeState(LoadingState.loaded);
  }

  OrganizationMemberController(this.organizationId) {
    load();
  }

  /// A function to load the [Organization]
  Future<void> load() async {
    loadMembers() async {
      _members = await OrganizationService().getMembersByOrganization(organizationId);
      _invitations = await OrganizationService().getInvitationsByOrganization(organizationId: organizationId);
      changeState(LoadingState.loaded);
    }

    loadHandler(
      future: loadMembers(),
    );
  }

  Future<void> inviteMember({required String organizationId, required String email}) async {
    inviteMember() async {
      await OrganizationService().inviteMember(organizationId: organizationId, email: email).then((value) =>
        load()
      );
    }

    loadHandler(
      future: inviteMember(),
    );
  }

  Future<void> removeMember({required String organizationId, required String userId}) async {
    remove() async {
      await OrganizationService().removeMember(organizationId: organizationId, userId: userId).then((value) =>
          load()
      );
    }

    loadHandler(
      future: remove(),
    );
  }

  Future<void> revokeInvitation({required String invitationId}) async {
    revokeInvite() async {
      await OrganizationService().revokeInvitation(invitationId: invitationId).then((value) =>
          invitations = invitations.where((element) => element.id != invitationId).toList()
      );
    }

    loadHandler(
      future: revokeInvite(),
    );
  }
}
