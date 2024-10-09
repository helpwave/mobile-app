import 'package:helpwave_proto_dart/services/property_svc/v1/types.pbenum.dart' as proto;
import 'package:helpwave_service/property.dart';

class PropertyGRPCTypeConverter {
  static proto.SubjectType subjectTypeToGRPC(PropertySubjectType subjectType) {
    switch (subjectType) {
      case PropertySubjectType.patient:
        return proto.SubjectType.SUBJECT_TYPE_PATIENT;
      case PropertySubjectType.task:
        return proto.SubjectType.SUBJECT_TYPE_TASK;
    }
  }

  static PropertySubjectType subjectTypeFromGRPC(proto.SubjectType subjectType) {
    switch (subjectType) {
      case proto.SubjectType.SUBJECT_TYPE_PATIENT:
        return PropertySubjectType.patient;
      case proto.SubjectType.SUBJECT_TYPE_TASK:
        return PropertySubjectType.task;
      default:
        throw "SubjectType unspecified is not allowed";
    }
  }

  static proto.FieldType fieldTypeToGRPC(PropertyFieldType fieldType) {
    switch (fieldType) {
      case PropertyFieldType.text:
        return proto.FieldType.FIELD_TYPE_TEXT;
      case PropertyFieldType.number:
        return proto.FieldType.FIELD_TYPE_NUMBER;
      case PropertyFieldType.bool:
        return proto.FieldType.FIELD_TYPE_CHECKBOX;
      case PropertyFieldType.date:
        return proto.FieldType.FIELD_TYPE_DATE;
      case PropertyFieldType.dateTime:
        return proto.FieldType.FIELD_TYPE_DATE_TIME;
      case PropertyFieldType.singleSelect:
        return proto.FieldType.FIELD_TYPE_SELECT;
      case PropertyFieldType.multiSelect:
        return proto.FieldType.FIELD_TYPE_MULTI_SELECT;
    }
  }

  static PropertyFieldType fieldTypeFromGRPC(proto.FieldType fieldType) {
    switch (fieldType) {
      case proto.FieldType.FIELD_TYPE_TEXT:
        return PropertyFieldType.text;
      case proto.FieldType.FIELD_TYPE_NUMBER:
        return PropertyFieldType.number;
      case proto.FieldType.FIELD_TYPE_CHECKBOX:
        return PropertyFieldType.bool;
      case proto.FieldType.FIELD_TYPE_DATE:
        return PropertyFieldType.date;
      case proto.FieldType.FIELD_TYPE_DATE_TIME:
        return PropertyFieldType.dateTime;
      case proto.FieldType.FIELD_TYPE_SELECT:
        return PropertyFieldType.singleSelect;
      case proto.FieldType.FIELD_TYPE_MULTI_SELECT:
        return PropertyFieldType.multiSelect;
      default:
        throw "FieldType unspecified is not allowed";
    }
  }
}
