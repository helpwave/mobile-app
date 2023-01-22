import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:helpwave/enums/blood_type.dart';
import 'package:helpwave/enums/dosage.dart';
import 'package:helpwave/enums/rhesus_factor.dart';
import 'package:helpwave/enums/severity.dart';
import 'package:helpwave/services/patient_persistence.dart';

part 'patient_data.g.dart';

/// The Data-Class containing all relevant data for a patient
///
/// After changing this file run "flutter pub run build_runner build --delete-conflicting-outputs"
@JsonSerializable()
class PatientData {
  String? name;
  String? language;
  DateTime? birthDate;
  bool? isOrganDonor;
  String? weight;
  String? height;
  BloodType bloodType;
  RhesusFactor rhesusFactor;
  Map<String, Dosage> medication;
  Map<String, Severity> allergies;

  PatientData({
    this.name,
    this.language,
    this.birthDate,
    this.isOrganDonor,
    this.weight,
    this.height,
    this.bloodType = BloodType.none,
    this.rhesusFactor = RhesusFactor.none,
    this.medication = const {},
    this.allergies = const {},
  }) {
    Map<String, Dosage> tmpMedication = <String, Dosage>{};
    tmpMedication.addAll(medication);
    medication = tmpMedication;
    Map<String, Severity> tmpAllergies = <String, Severity>{};
    tmpAllergies.addAll(allergies);
    allergies = tmpAllergies;
  }

  String serialize() {
    return jsonEncode(toJson());
  }

  static PatientData deserialize(String jsonString) {
    return jsonDecode(jsonString);
  }

  @override
  String toString() {
    return serialize();
  }

  factory PatientData.fromJson(Map<String, dynamic> json) =>
      _$PatientDataFromJson(json);

  Map<String, dynamic> toJson() => _$PatientDataToJson(this);

  /// Convenience function
  save() => PatientPersistenceService().save(this);
}
