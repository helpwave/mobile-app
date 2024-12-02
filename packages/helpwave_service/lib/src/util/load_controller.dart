import 'package:helpwave_service/src/util/crud_service_interface.dart';
import 'package:helpwave_service/src/util/identified_object.dart';
import 'package:helpwave_util/loading.dart';
import 'crud_object_interface.dart';

abstract class LoadController<
    IdentifierType,
    DataType extends CRUDObject<IdentifierType, DataType, CreateType, UpdateType>,
    CreateType,
    UpdateType,
    ServiceType extends CRUDInterface<IdentifierType, DataType, DataType, UpdateType>> extends LoadingChangeNotifier {
  late final ServiceType service;
  late DataType _data; // Default value

  DataType get data => _data;

  set data(DataType value) => changeData(value);

  bool get isCreating => data.isCreating;

  /// A handler for changing the data that allows not notifying observers
  ///
  /// This is useful in case the change is handled inside the [loadHandler] as it automatically
  void changeData(DataType value, {isNotifying = true}) {
    _data = value;
    if (isNotifying) {
      changeState(LoadingState.loaded);
    }
  }

  LoadController({IdentifierType? id, DataType? initialData, required this.service}) {
    assert(initialData == null || id == initialData.id, "The id and initial data id must be the same or not provided");
    if (initialData != null) {
      _data = data;
    } else if (id != null) {
      _data = defaultData().create(id);
    }
    load();
  }

  /// The default value for the DataType
  DataType defaultData(); // This cannot be abstracted as we cannot know a constructor for the DataType

  /// Creates the [DataType]
  Future<void> create() async {
    assert(data.isCreating, "Only call $runtimeType.create when managing a new object.");

    createOp() async {
      await service.create(data).then((value) {
        _data = value;
      });
    }

    loadHandler(future: createOp());
  }

  /// A function to load the [DataType]
  Future<void> load() async {
    loadOp() async {
      if (isCreating) {
        return;
      }
      _data = await service.get(data.id as IdentifierType);
    }

    loadHandler(
      future: loadOp(),
    );
  }

  /// Updates the [DataType]
  Future<void> update(UpdateType? update) async {
    updateOp() async {
      if (isCreating) {
        _data = data.copyWith(update);
        return;
      }
      await service.update(data.id as IdentifierType, update).then((value) {
        if(value){
          _data = data.copyWith(update);
        }
      });
    }

    loadHandler(future: updateOp());
  }

  /// Deletes the [DataType] and makes this controller unusable until restore is called
  Future<void> delete() async {
    assert(!data.isCreating, "Only call $runtimeType.delete when managing an existing object.");

    deleteOp() async {
      // Due to the genericity a cast is better
      await service.delete(data.id as IdentifierType).then((_) {});
    }

    loadHandler(future: deleteOp());
  }

/*
  /// Restores the [DataType] after deletion
  Future<void> restore() async {
    assert(!data.isCreating, "Only call $runtimeType.restore when managing an existing object.");

    restoreOp() async {
      await Service().restore(data.id).then((bool) {});
    }

    loadHandler(future: restoreOp());
  }
  */
}
