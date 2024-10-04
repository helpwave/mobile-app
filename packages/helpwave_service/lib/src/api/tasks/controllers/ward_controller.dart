import 'dart:async';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_util/loading.dart';

/// The Controller for managing a [WardMinimal]
///
/// Providing a [wardId] means loading and synchronising the [WardMinimal]s with
/// the backend while no [wardId] or a empty [String] means that the [WardMinimal] is
/// only used locally
class WardController extends LoadingChangeNotifier {
  /// The [WardMinimal]
  WardMinimal? _ward;

  WardMinimal get ward {
    return _ward ?? WardMinimal(id: "", name: "");
  }

  set ward(WardMinimal value) {
    _ward = value;
    notifyListeners();
  }

  bool get isCreating => wardId == null || wardId!.isEmpty;

  String? wardId;

  WardController({this.wardId = "", WardMinimal? ward}) {
    assert(ward == null || ward.id == wardId);
    if (ward != null) {
      _ward = ward;
      wardId = ward.id;
    }
    if (!isCreating) {
      load();
    }
  }

  /// Loads the [WardMinimal]s
  Future<void> load() async {
    if (isCreating) {
      return;
    }
    loadOp() async {
      ward = await WardService().get(id: wardId!);
    }

    loadHandler(future: loadOp());
  }

  /// Delete the [WardMinimal] by the id
  Future<void> delete() async {
    assert(!isCreating, "deleteById should not be used when creating a completely new Subtask list");
    deleteOp() async {
      await WardService().delete(id: ward.id);
    }

    loadHandler(future: deleteOp());
  }

  /// Add the [WardMinimal]
  Future<void> create(WardMinimal ward) async {
    assert(isCreating);
    createOp() async {
      await WardService().create(ward: ward).then((value) {
        wardId = value.id;
        ward = value;
      });
    }

    loadHandler(future: createOp());
  }

  Future<void> update({String? name}) async {
    if (isCreating) {
      ward.name = name ?? ward.name;
      notifyListeners();
      return;
    }
    updateOp() async {
      assert(!ward.isCreating, "To update a ward on the server the ward must have an id");
      await WardService().update(id: ward.id, name: name);
      ward.name = name ?? ward.name;
      notifyListeners();
    }

    loadHandler(future: updateOp());
  }
}
