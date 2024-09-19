import 'package:helpwave_service/auth.dart';
import 'package:helpwave_util/loading.dart';
import '../../../../user.dart';

/// The Controller for managing a [Organization]
class OrganizationController extends LoadingChangeNotifier {
  /// The current [Organization]
  Organization _organization;

  /// The current [Organization]
  Organization get organization => _organization;

  set organization(Organization value) {
    _organization = value;
    changeState(LoadingState.loaded);
  }

  OrganizationController(this._organization) {
    load();
  }

  /// A function to load the [Organization]
  Future<void> load() async {
    loadOrganization() async {
      organization = await OrganizationService().getOrganization(id: organization.id);
    }

    loadHandler(
      future: loadOrganization(),
    );
  }

  Future<void> update({
    String? shortName,
    String? longName,
    String? email,
    bool? isPersonal,
    String? avatarUrl,
  }) async {
    changeOrganization() async {
      await OrganizationService().update(
        id: organization.id,
        longName: longName,
        shortName: shortName,
        isPersonal: isPersonal,
        email: email,
        avatarUrl: avatarUrl,
      );
      organization = organization.copyWith(
        longName: longName,
        shortName: shortName,
        isPersonal: isPersonal,
        email: email,
        avatarURL: avatarUrl,
      );

      bool affectsCurrentWardService = shortName != null || longName != null;

      if (affectsCurrentWardService && CurrentWardService().currentWard?.organizationId == organization.id) {
        CurrentWardService().currentWard = CurrentWardService().currentWard!.copyWith(
              organization: CurrentWardService().currentWard!.organization.copyWith(
                    shortName: shortName,
                    longName: longName,
                  ),
            );
      }
    }

    loadHandler(
      future: changeOrganization(),
    );
  }

  Future<void> delete() async {
    deleteOrganization() async {
      await OrganizationService().delete(organization.id).then((_) {
        // TODO do something here
      });
    }

    loadHandler(future: deleteOrganization());
  }

// TODO create method and isCreating handling
}
