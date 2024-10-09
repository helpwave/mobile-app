import 'package:helpwave_service/src/api/util/copy_with_interface.dart';
import 'package:helpwave_service/src/api/util/identified_object.dart';
import 'package:helpwave_util/lists.dart';
import 'index.dart';

typedef MultiSelectUpdate = ({List<PropertySelectOption> upsert, List<String> remove});

class PropertyValueUpdate {
  final String? text;
  final double? number;
  final bool? boolValue;
  final DateTime? date;
  final DateTime? dateTime;
  final PropertySelectOption? singleSelect;
  final MultiSelectUpdate? multiSelect;
  final bool removeAll;

  const PropertyValueUpdate({
    this.text,
    this.number,
    this.boolValue,
    this.date,
    this.dateTime,
    this.singleSelect,
    this.multiSelect,
    this.removeAll = false
  });
}

class PropertyValue {
  final String? text;
  final double? number;
  final bool? boolValue;
  final DateTime? date;
  final DateTime? dateTime;
  final PropertySelectOption? singleSelect;
  final List<PropertySelectOption> multiSelect;

  const PropertyValue({
    this.text,
    this.number,
    this.boolValue,
    this.date,
    this.dateTime,
    this.singleSelect,
    this.multiSelect = const [],
  });

  PropertyValue copyWith(PropertyValueUpdate? update) {
    if (update?.removeAll ?? false) {
      return const PropertyValue();
    }

    return PropertyValue(
        text: update?.text ?? text,
        number: update?.number ?? number,
        boolValue: update?.boolValue ?? boolValue,
        date: update?.date ?? date,
        dateTime: update?.dateTime ?? dateTime,
        singleSelect: update?.singleSelect ?? singleSelect,
        multiSelect: update?.multiSelect != null ? multiSelect.upsert(update!.multiSelect!.upsert, (a) => a.id!).where((
            element) => !update.multiSelect!.remove.any((id) => element.id == id)).toList() : multiSelect
    );
  }
}

class AttachedPropertyUpdate {
  final String? id;
  final String? propertyId;
  final String? subjectId;
  final PropertyValueUpdate? value;

  const AttachedPropertyUpdate({
    this.id,
    this.propertyId,
    this.subjectId,
    this.value,
  });
}

/// The type for attaching a property
class AttachedProperty extends IdentifiedObject<String> implements CopyWithInterface<AttachedProperty, AttachedPropertyUpdate> {
  final String propertyId;
  final String subjectId;
  final PropertyValue value;

  AttachedProperty({super.id, required this.propertyId, required this.subjectId, this.value = const PropertyValue()});

  @override
  AttachedProperty copyWith(AttachedPropertyUpdate? update) {
    return AttachedProperty(
      id: update?.id ?? id,
      propertyId: update?.propertyId ?? propertyId,
      subjectId: update?.subjectId ?? subjectId,
      value: value.copyWith(update?.value),
    );
  }
}

class DisplayableAttachedProperty extends AttachedProperty {
  final String name;
  final String description;
  final PropertyFieldType fieldType;
  final PropertySubjectType subjectType;
  final bool isArchived;

  DisplayableAttachedProperty({
    required super.propertyId,
    required super.subjectId,
    super.value,
    required this.name,
    this.description = "",
    required this.fieldType,
    required this.subjectType,
    this.isArchived = false,
  });
}
