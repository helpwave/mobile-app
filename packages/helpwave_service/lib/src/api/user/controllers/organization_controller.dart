import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/src/util/index.dart';
import '../../../../user.dart';

/// The Controller for managing a [Organization]
class OrganizationController
    extends LoadController<String, Organization, Organization, OrganizationUpdate, OrganizationService> {
  OrganizationController({String? id, Organization? initialData})
      : super(id: id, initialData: initialData, service: OrganizationService());

  @override
  Future<void> update(OrganizationUpdate? update) async {
    updateOp() async {
      if (isCreating) {
        changeData(data.copyWith(update));
        return;
      }
      await service.update(data.id!, update).then((value) {
        changeData(data.copyWith(update));
      });
      bool affectsCurrentWardService = update?.shortName != null || update?.longName != null;

      if (affectsCurrentWardService && CurrentWardService().currentWard?.organizationId == data.id) {
        CurrentWardService().currentWard = CurrentWardService().currentWard!.copyWith(
              organization: CurrentWardService().currentWard!.organization.copyWith(OrganizationUpdate(
                    shortName: update?.shortName,
                    longName: update?.longName,
                  )),
            );
      }
    }

    loadHandler(
      future: updateOp(),
    );
  }

  @override
  Organization defaultData() => Organization.empty();
}
