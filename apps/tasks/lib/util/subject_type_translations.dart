import 'package:flutter/cupertino.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/property.dart';

String propertySubjectTypeTranslations(BuildContext context, PropertySubjectType subjectType) {
  switch(subjectType){
    case PropertySubjectType.patient:
      return context.localization!.patient;
    case PropertySubjectType.task:
      return context.localization!.task;
  }
}
