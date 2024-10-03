import 'dart:async';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_util/loading.dart';

/// The Controller for managing [Bed]s in a [Room]
///
/// Providing a [roomId] means loading and synchronising the [Bed]s with
/// the backend while no [roomId] or a empty [String] means that the [Bed]s are
/// only used locally
class BedsController extends LoadingChangeNotifier {
  /// The [Bed]s
  List<Bed> _beds = [];

  List<Bed> get beds => [..._beds];

  set beds(List<Bed> value) {
    _beds = value;
    notifyListeners();
  }

  bool get isCreating => roomId == null || roomId!.isEmpty;

  String? roomId;

  BedsController({this.roomId = "", List<Subtask>? beds}) {
    if (!isCreating) {
      load();
    }
  }

  /// Loads the [Bed]s
  Future<void> load() async {
    if (isCreating) {
      return;
    }
    loadBeds() async {
      beds = await BedService().getBedsByRoom(roomId: roomId!);
    }

    loadHandler(future: loadBeds());
  }

  /// Delete the [Bed] by its index in the list
  Future<void> deleteByIndex(int index) async {
    assert (index < 0 || index >= beds.length);
    if (isCreating) {
      _beds.removeAt(index);
      notifyListeners();
      return;
    }
    await delete(beds[index].id);
  }

  /// Delete the [Bed] by the id
  Future<void> delete(String id) async {
    assert(!isCreating, "deleteById should not be used when creating a completely new Subtask list");
    deleteOp() async {
      await BedService().delete(id: id).then((value) {
        if (value) {
          int index = _beds.indexWhere((element) => element.id == id);
          if (index != -1) {
            _beds.removeAt(index);
          }
        }
      });
    }

    loadHandler(future: deleteOp());
  }

  /// Add the [Bed]
  Future<void> create(Bed bed) async {
    if (isCreating) {
      _beds.add(bed);
      notifyListeners();
      return;
    }
    createSubtask() async {
      await BedService().create(roomId: roomId!, name: bed.name).then((value) {
        _beds.add(bed);
      });
    }

    loadHandler(future: createSubtask());
  }

  Future<void> update({required Bed bed, int? index}) async {
    if (isCreating) {
      assert(
      index != null && index >= 0 && index < beds.length,
      "When creating a bed list and updating a bed, a index for the bed must be provided",
      );
      beds[index!] = bed;
      return;
    }
    updateOp() async {
      assert(!bed.isCreating, "To update a bed on the server the bed must have an id");
      await BedService().update(id: bed.id, name: bed.name);
      int index = beds.indexWhere((element) => element.id == bed.id);
      if (index != -1) {
        beds[index] = bed;
      }
    }

    loadHandler(future: updateOp());
  }
}
