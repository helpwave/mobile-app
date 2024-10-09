import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/google/protobuf/timestamp.pb.dart';
import 'package:helpwave_proto_dart/services/property_svc/v1/property_value_svc.pbgrpc.dart';
import 'package:helpwave_proto_dart/services/property_svc/v1/types.pb.dart';
import 'package:helpwave_service/src/api/property/property_api_service_clients.dart';
import 'package:helpwave_service/src/api/property/util/type_converter.dart';
import '../../../../property.dart';

/// The GRPC Service for [AttachedProperty]s
///
/// Provides queries and requests that load or alter [AttachedProperty] objects on the server
/// The server is defined in the underlying [PropertyAPIServiceClients]
class PropertyValueService {
  /// The GRPC ServiceClient which handles GRPC
  PropertyValueServiceClient service = PropertyAPIServiceClients().propertyValueServiceClient;

  Future<List<DisplayableAttachedProperty>> get(String id, PropertySubjectType subjectType) async {
    GetAttachedPropertyValuesRequest request = GetAttachedPropertyValuesRequest();
    switch (subjectType) {
      case PropertySubjectType.patient:
        request.patientMatcher = PatientPropertyMatcher(patientId: id);
        break;
      case PropertySubjectType.task:
        request.taskMatcher = TaskPropertyMatcher(wardId: id);
        break;
    }

    GetAttachedPropertyValuesResponse response = await service.getAttachedPropertyValues(
      request,
      options: CallOptions(metadata: PropertyAPIServiceClients().getMetaData()),
    );

    return response.values
        .map((value) => DisplayableAttachedProperty(
              propertyId: value.propertyId,
              subjectId: id,
              subjectType: subjectType,
              name: value.name,
              description: value.description,
              isArchived: value.isArchived,
              fieldType: PropertyGRPCTypeConverter.fieldTypeFromGRPC(value.fieldType),
              value: PropertyValue(
                  text: value.hasTextValue() ? value.textValue : null,
                  number: value.hasNumberValue() ? value.numberValue : null,
                  boolValue: value.hasBoolValue() ? value.boolValue : null,
                  date: value.hasDateValue() ? value.dateValue.date.toDateTime() : null,
                  dateTime: value.hasDateTimeValue() ? value.dateTimeValue.toDateTime() : null,
                  singleSelect: value.hasSelectValue()
                      ? PropertySelectOption(
                          id: value.selectValue.id,
                          name: value.selectValue.name,
                          description: value.selectValue.description)
                      : null,
                  multiSelect: value.multiSelectValue.selectValues
                      .map((select) =>
                          PropertySelectOption(id: select.id, name: select.name, description: select.description))
                      .toList()),
            ))
        .toList();
  }

  Future<AttachedProperty> attachProperty({
    required AttachedProperty property,
    PropertyValueUpdate update = const PropertyValueUpdate(),
  }) async {
    AttachPropertyValueRequest request = AttachPropertyValueRequest(
      propertyId: property.propertyId,
      subjectId: property.subjectId,
      textValue: update.text,
      numberValue: update.number,
      boolValue: update.boolValue,
      dateValue: update.date != null ? Date(date: Timestamp.fromDateTime(update.date!)) : null,
      dateTimeValue: update.dateTime != null ? Timestamp.fromDateTime(update.date!) : null,
      selectValue: update.singleSelect?.id,
      multiSelectValue: update.multiSelect != null
          ? AttachPropertyValueRequest_MultiSelectValue(
              selectValues: update.multiSelect!.upsert.map((e) => e.id!),
              removeSelectValues: update.multiSelect!.remove)
          : null,
    );

    AttachPropertyValueResponse response = await service.attachPropertyValue(
      request,
      options: CallOptions(metadata: PropertyAPIServiceClients().getMetaData()),
    );

    return property.copyWith(AttachedPropertyUpdate(id: response.propertyValueId, value: update));
  }
}
