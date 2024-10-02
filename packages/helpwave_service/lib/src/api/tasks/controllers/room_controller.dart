import 'dart:async';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_util/loading.dart';

/// The Controller for managing a [Room]
///
/// Providing a [roomId] means loading and synchronising the [Room]s with
/// the backend while no [roomId] or a empty [String] means that the [Room] is
/// only used locally
class RoomController extends LoadingChangeNotifier {
  /// The [Room]
  RoomMinimal? _room;

  RoomMinimal get room {
    // TODO find a better solution here
    return _room ?? RoomMinimal(id: "", name: "");
  }

  set room(RoomMinimal value) {
    _room = value;
    notifyListeners();
  }

  bool get isCreating => roomId == null || roomId!.isEmpty;

  String? roomId;

  RoomController({this.roomId = "", RoomMinimal? room}) {
    assert(room == null || room.id == roomId);
    if (room != null) {
      _room = room;
      roomId = room.id;
    }
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
      room = await RoomService().get(roomId: roomId!);
    }

    loadHandler(future: loadOp());
  }

  /// Delete the [Room] by the id
  Future<void> delete() async {
    assert(!isCreating, "deleteById should not be used when creating a completely new Subtask list");
    deleteOp() async {
      await RoomService().delete(id: room.id);
    }

    loadHandler(future: deleteOp());
  }

  /// Add the [Room]
  Future<void> create(RoomMinimal room) async {
    assert(isCreating);
    createOp() async {
      await RoomService().createRoom(wardId: roomId!, name: room.name).then((value) {
        roomId = value.id;
        room = value;
      });
    }

    loadHandler(future: createOp());
  }

  Future<void> update({String? name}) async {
    if (isCreating) {
      room.name = name ?? room.name;
      notifyListeners();
      return;
    }
    updateOp() async {
      assert(!room.isCreating, "To update a room on the server the room must have an id");
      await RoomService().update(id: room.id, name: name);
      room.name = name ?? room.name;
      notifyListeners();
    }

    loadHandler(future: updateOp());
  }
}
