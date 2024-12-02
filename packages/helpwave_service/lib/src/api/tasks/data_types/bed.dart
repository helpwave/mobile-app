import 'package:helpwave_service/src/api/tasks/index.dart';

/// Data class for a [Bed]
class BedMinimal {
  String id;
  String name;

  BedMinimal({
    required this.id,
    required this.name,
  });

  bool get isCreating => id == "";
}

class Bed extends BedMinimal {
  PatientMinimal? patient;
  String roomId;

  Bed({
    required super.id,
    required super.name,
    required this.roomId,
    this.patient,
  });
}
