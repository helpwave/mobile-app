import 'dart:async';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_util/loading.dart';

/// The Controller for managing [Room]s in a [Ward]
///
/// Providing a [wardId] means loading and synchronising the [Room]s with
/// the backend while no [wardId] or a empty [String] means that the [Room]s are
/// only used locally
class RoomsController extends LoadingChangeNotifier {
  /// The [Room]s
  List<RoomWithBedWithMinimalPatient> _rooms = [];

  List<RoomWithBedWithMinimalPatient> get rooms => [..._rooms];

  set rooms(List<RoomWithBedWithMinimalPatient> value) {
    _rooms = value;
    notifyListeners();
  }

  bool get isCreating => wardId == null || wardId!.isEmpty;

  String? wardId;

  RoomsController({this.wardId = "", List<Subtask>? rooms}) {
    if (!isCreating) {
      load();
    }
  }

  /// Loads the [Room]s
  Future<void> load() async {
    if (isCreating) {
      return;
    }
    loadOp() async {
      rooms = await RoomService().getRooms(wardId: wardId!);
    }

    loadHandler(future: loadOp());
  }

  /// Delete the [Room] by its index.dart in the list
  Future<void> deleteByIndex(int index) async {
    assert(index < 0 || index >= rooms.length);
    if (isCreating) {
      _rooms.removeAt(index);
      notifyListeners();
      return;
    }
    await delete(rooms[index].id);
  }

  /// Delete the [Room] by the id
  Future<void> delete(String id) async {
    assert(!isCreating, "deleteById should not be used when creating a completely new Subtask list");
    deleteOp() async {
      await RoomService().delete(id: id).then((value) {
        if (value) {
          int index = _rooms.indexWhere((element) => element.id == id);
          if (index != -1) {
            _rooms.removeAt(index);
          }
        }
      });
    }

    loadHandler(future: deleteOp());
  }

  /// Add the [Room]
  Future<void> create(RoomWithBedWithMinimalPatient room) async {
    if (isCreating) {
      _rooms.add(room);
      notifyListeners();
      return;
    }
    createOp() async {
      await RoomService().createRoom(wardId: wardId!, name: room.name).then((value) {
        _rooms.add(room);
      });
    }

    loadHandler(future: createOp());
  }

  Future<void> update({required RoomWithBedWithMinimalPatient room, int? index}) async {
    if (isCreating) {
      assert(
        index != null && index >= 0 && index < rooms.length,
        "When creating a room list and updating a room, a index.dart for the room must be provided",
      );
      rooms[index!] = room;
      return;
    }
    updateOp() async {
      assert(!room.isCreating, "To update a room on the server the room must have an id");
      await RoomService().update(id: room.id, name: room.name);
      int index = rooms.indexWhere((element) => element.id == room.id);
      if (index != -1) {
        rooms[index] = room;
      }
    }

    loadHandler(future: updateOp());
  }
}
