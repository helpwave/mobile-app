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

  RoomWithBed({required this.id, required this.name, required this.bed});
}

class RoomWithBedFlat {
  RoomMinimal room;
  BedMinimal bed;

  RoomWithBedFlat({
    required this.room,
    required this.bed,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is RoomWithBedFlat) {
      return room.id == other.room.id &&
          room.name == other.room.name &&
          bed.id == other.bed.id &&
          bed.name == other.bed.name;
    }

    return false;
  }

  @override
  String toString() {
    return "RoomWithBedFlat {room: {id: ${room.id}, name: ${room.name}}, bed: {id: ${bed.id}, name: ${bed.name}}}";
  }

  @override
  int get hashCode => room.id.hashCode + bed.id.hashCode;
}

class RoomWithBedWithMinimalPatient extends RoomMinimal {
  List<BedWithMinimalPatient> beds;

  RoomWithBedWithMinimalPatient({
    required super.id,
    required super.name,
    required this.beds,
  });
}
