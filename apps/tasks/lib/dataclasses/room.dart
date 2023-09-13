import 'package:tasks/dataclasses/bed.dart';

/// data class for [Room]
class RoomMinimal {
  String id;
  String name;

  RoomMinimal({
    required this.id,
    required this.name,
  });
}

class RoomWithBed {
  String id;
  String name;
  List<BedMinimal> bed;

  RoomWithBed({
    required this.id,
    required this.name,
    required this.bed
  });
}
