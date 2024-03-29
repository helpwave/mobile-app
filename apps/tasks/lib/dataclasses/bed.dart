import 'package:tasks/dataclasses/patient.dart';

/// data class for [Bed]
class BedMinimal {
  String id;
  String name;

  BedMinimal({
    required this.id,
    required this.name,
  });
}

class BedWithMinimalPatient extends BedMinimal{
  PatientMinimal? patient;

  BedWithMinimalPatient({
    required super.id,
    required super.name,
    required this.patient,
  });
}
