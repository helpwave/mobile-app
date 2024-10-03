import 'package:helpwave_service/src/api/tasks/data_types/bed.dart';

/// data class for [Room]
class RoomMinimal {
  String id;
  String name;

  RoomMinimal({
    required this.id,
    required this.name,
  });

  bool get isCreating => id == "";
}

class RoomWithWardId extends RoomMinimal {
  String wardId;

  RoomWithWardId({required super.id, required super.name, required this.wardId});
}

class RoomWithBeds {
  String id;
  String name;
  List<BedMinimal> beds;

  RoomWithBeds({required this.id, required this.name, required this.beds});
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
  List<Bed> beds;

  RoomWithBedWithMinimalPatient({
    required super.id,
    required super.name,
    required this.beds,
  });
}
