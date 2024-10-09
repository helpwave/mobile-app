import 'package:helpwave_util/lists.dart';

import '../../util/copy_with_interface.dart';
import '../../util/identified_object.dart';

class PropertySelectOptionUpdate {
  final String? id;
  final String? name;
  final String? description;
  final bool? isCustom;

  PropertySelectOptionUpdate({this.id, this.name, this.description, this.isCustom});
}

class PropertySelectOption extends IdentifiedObject<String>
    implements CopyWithInterface<PropertySelectOption, PropertySelectOptionUpdate> {
  final String name;
  final String description;
  final bool isCustom;

  PropertySelectOption({
    super.id,
    required this.name,
    this.description = "",
    this.isCustom = false,
  });

  @override
  copyWith(PropertySelectOptionUpdate? update) {
    return PropertySelectOption(
      id: update?.id ?? id,
      name: update?.name ?? name,
      description: update?.description ?? description,
      isCustom: update?.isCustom ?? isCustom,
    );
  }
}

typedef PropertySelectDataUpdate = ({
  bool? isAllowingFreeText,
  List<String>? removeOptions,
  List<PropertySelectOption>? upsert,
  List<PropertySelectOption>? options
});

class PropertySelectData implements CopyWithInterface<PropertySelectData, PropertySelectDataUpdate> {
  final bool isAllowingFreeText;
  final List<PropertySelectOption> options;

  PropertySelectData({this.isAllowingFreeText = false, this.options = const []});

  @override
  PropertySelectData copyWith(PropertySelectDataUpdate? update) {
    assert(
      update?.options == null || (update?.upsert == null && update?.removeOptions == null),
      "Only provide either the upsert/remove or only the option overwrite",
    );
    return PropertySelectData(
      isAllowingFreeText: update?.isAllowingFreeText ?? isAllowingFreeText,
      options: update?.options ??
          options
              .upsert(update!.upsert!, (a) => a.id!)
              .where((element) => !update.removeOptions!.any((id) => id == element.id))
              .toList(),
    );
  }
}
