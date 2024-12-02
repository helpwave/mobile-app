import 'package:flutter/cupertino.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/property.dart';

String propertyFieldTypeTranslations(BuildContext context, PropertyFieldType fieldType) {
  switch(fieldType){
    case PropertyFieldType.text:
      return context.localization.freeText;
    case PropertyFieldType.number:
      return context.localization.number;
    case PropertyFieldType.bool:
      return context.localization.checkBox;
    case PropertyFieldType.date:
      return context.localization.datePicker;
    case PropertyFieldType.dateTime:
      return context.localization.dateTimePicker;
    case PropertyFieldType.singleSelect:
      return context.localization.select;
    case PropertyFieldType.multiSelect:
      return context.localization.multiSelect;
  }
}
