import 'package:helpwave_service/src/api/property/data_types/field_type.dart';
import 'package:helpwave_service/src/api/property/data_types/select_data.dart';
import 'package:helpwave_service/src/api/property/data_types/subject_type.dart';
import 'package:helpwave_service/src/api/util/copy_with_interface.dart';
import 'package:helpwave_service/src/api/util/identified_object.dart';

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
    this.selectData,
    this.alwaysIncludeForViewSource,
    this.removeSetId,
    this.removeAlwaysIncludeForViewSource,
  });
}

class Property extends IdentifiedObject<String> implements CopyWithInterface<Property, PropertyUpdate> {
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
    required this.isArchived,
    this.setId,
    this.selectData,
    this.alwaysIncludeForViewSource,
  }) : assert(!(fieldType == PropertyFieldType.singleSelect || fieldType == PropertyFieldType.multiSelect) ||
            selectData != null);

  @override
  copyWith(PropertyUpdate update) {
    return Property(
      id: update.id ?? id,
      name: update.name ?? name,
      description: update.description ?? description,
      subjectType: update.subjectType ?? subjectType,
      fieldType: update.fieldType ?? fieldType,
      isArchived: update.isArchived ?? isArchived,
      setId: (update.removeSetId ?? false) ? null : update.setId ?? setId,
      selectData: update.selectData ?? selectData,
      alwaysIncludeForViewSource: (update.removeAlwaysIncludeForViewSource ?? false)
          ? null
          : update.alwaysIncludeForViewSource ?? alwaysIncludeForViewSource,
    );
  }
}
