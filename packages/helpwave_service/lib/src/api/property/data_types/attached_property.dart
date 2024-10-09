import 'package:helpwave_service/src/api/util/copy_with_interface.dart';
import 'index.dart';

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
}

class AttachedPropertyUpdate {
  final String? propertyId;
  final String? subjectId;
  final PropertyValue? value;

  const AttachedPropertyUpdate({
    this.propertyId,
    this.subjectId,
    this.value,
  });
}

/// The type for attaching a property
class AttachedProperty implements CopyWithInterface<AttachedProperty, AttachedPropertyUpdate> {
  final String propertyId;
  final String subjectId;
  final PropertyValue value;

  AttachedProperty({required this.propertyId, required this.subjectId, this.value = const PropertyValue()});

  @override
  AttachedProperty copyWith(AttachedPropertyUpdate update) {
    return AttachedProperty(
      propertyId: update.propertyId ?? propertyId,
      subjectId: update.subjectId ?? subjectId,
      value: update.value ?? value,
    );
  }
}
