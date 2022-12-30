// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PatientData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientData _$PatientDataFromJson(Map<String, dynamic> json) => PatientData(
      name: json['name'] as String?,
      language: json['language'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      isOrganDonor: json['isOrganDonor'] as bool?,
      weight: json['weight'] as String?,
      height: json['height'] as String?,
      bloodType: $enumDecodeNullable(_$BloodTypeEnumMap, json['bloodType']) ??
          BloodType.none,
      rhesusFactor:
          $enumDecodeNullable(_$RhesusFactorEnumMap, json['rhesusFactor']) ??
              RhesusFactor.none,
      medication: (json['medication'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, $enumDecode(_$DosageEnumMap, e)),
          ) ??
          const {},
      allergies: (json['allergies'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, $enumDecode(_$SeverityEnumMap, e)),
          ) ??
          const {},
    );

Map<String, dynamic> _$PatientDataToJson(PatientData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'language': instance.language,
      'birthDate': instance.birthDate?.toIso8601String(),
      'isOrganDonor': instance.isOrganDonor,
      'weight': instance.weight,
      'height': instance.height,
      'bloodType': _$BloodTypeEnumMap[instance.bloodType]!,
      'rhesusFactor': _$RhesusFactorEnumMap[instance.rhesusFactor]!,
      'medication':
          instance.medication.map((k, e) => MapEntry(k, _$DosageEnumMap[e]!)),
      'allergies':
          instance.allergies.map((k, e) => MapEntry(k, _$SeverityEnumMap[e]!)),
    };

const _$BloodTypeEnumMap = {
  BloodType.none: 'none',
  BloodType.a: 'a',
  BloodType.b: 'b',
  BloodType.ab: 'ab',
  BloodType.o: 'o',
};

const _$RhesusFactorEnumMap = {
  RhesusFactor.none: 'none',
  RhesusFactor.rhPlus: 'rhPlus',
  RhesusFactor.rhMinus: 'rhMinus',
};

const _$DosageEnumMap = {
  Dosage.monthly: 'monthly',
  Dosage.weekly: 'weekly',
  Dosage.weekly2Times: 'weekly2Times',
  Dosage.weekly4Times: 'weekly4Times',
  Dosage.daily: 'daily',
  Dosage.daily2Times: 'daily2Times',
  Dosage.daily3Times: 'daily3Times',
  Dosage.daily5Times: 'daily5Times',
};

const _$SeverityEnumMap = {
  Severity.light: 'light',
  Severity.severe: 'severe',
};
