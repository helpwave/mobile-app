import 'package:helpwave_service/src/api/property/data_types/field_type.dart';
import 'package:helpwave_service/src/api/property/data_types/select_data.dart';
import 'package:helpwave_service/src/api/property/data_types/subject_type.dart';
import 'package:helpwave_service/util.dart';


class PropertyUpdate {
  String? id;
  String? name;
  String? description;
  PropertySubjectType? subjectType;
  PropertyFieldType? fieldType;
  bool? isArchived;
  String? setId;
  PropertySelectDataUpdate? selectDataUpdate;
  bool? alwaysIncludeForViewSource;
  bool? removeSetId;
  bool? removeAlwaysIncludeForViewSource;

  PropertyUpdate({
    this.id,
    this.name,
    this.description,
    this.subjectType,
    this.fieldType,
    this.isArchived,
    this.setId,
    this.selectDataUpdate,
    this.alwaysIncludeForViewSource,
    this.removeSetId,
    this.removeAlwaysIncludeForViewSource,
  });
}

class Property extends CRUDObject<String, Property, Property, PropertyUpdate> {
  final String name;
  final String description;
  final PropertySubjectType subjectType;
  final PropertyFieldType fieldType;
  final bool isArchived;
  final String? setId;
  final PropertySelectData? selectData;
  final bool? alwaysIncludeForViewSource;

  bool get isSelectType => fieldType == PropertyFieldType.singleSelect || fieldType == PropertyFieldType.multiSelect;

  Property({
    super.id,
    required this.name,
    this.description = "",
    required this.subjectType,
    required this.fieldType,
    this.isArchived = false,
    this.setId,
    this.selectData,
    this.alwaysIncludeForViewSource,
  }) : assert(!(fieldType == PropertyFieldType.singleSelect || fieldType == PropertyFieldType.multiSelect) ||
            selectData != null);

  factory Property.empty() {
    return Property(
        name: "Property Name",
        subjectType: PropertySubjectType.patient,
        fieldType: PropertyFieldType.multiSelect,
        selectData: PropertySelectData(
            options: [
              PropertySelectOption(name: "Option 1"),
              PropertySelectOption(name: "Option 2"),
              PropertySelectOption(name: "Option 3"),
            ],
            isAllowingFreeText: true
        )
    );
  }

  @override
  copyWith(PropertyUpdate? update) {
    return Property(
      id: update?.id ?? id,
      name: update?.name ?? name,
      description: update?.description ?? description,
      subjectType: update?.subjectType ?? subjectType,
      fieldType: update?.fieldType ?? fieldType,
      isArchived: update?.isArchived ?? isArchived,
      setId: (update?.removeSetId ?? false) ? null : update?.setId ?? setId,
      selectData: selectData?.copyWith(update?.selectDataUpdate),
      alwaysIncludeForViewSource: (update?.removeAlwaysIncludeForViewSource ?? false)
          ? null
          : update?.alwaysIncludeForViewSource ?? alwaysIncludeForViewSource,
    );
  }

  @override
  Property create(String? id) {
    return copyWith(PropertyUpdate(id: id));
  }
}
