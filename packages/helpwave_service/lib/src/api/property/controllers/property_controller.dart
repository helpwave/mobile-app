import 'package:helpwave_service/property.dart';
import 'package:helpwave_util/loading.dart';

/// The Controller for managing [Property]s in a Ward
class PropertyController extends LoadingChangeNotifier {
  /// The current [Property]
  Property _property = Property(
    name: "Property Name",
    subjectType: PropertySubjectType.patient,
    fieldType: PropertyFieldType.multiSelect,
    selectData: PropertySelectData(
      options: [
        PropertySelectOption(name: "Option 1"),
        PropertySelectOption(name: "Option 2"),
        PropertySelectOption(name: "Option 3"),
      ],
      isAllowingFreeText: true
    )
  );

  /// The current [Property]
  Property get property => _property;

  set property(Property value) {
    _property = value;
    changeState(LoadingState.loaded);
  }

  /// Is the current [Property] already saved on the server or are we creating?
  get isCreating => _property.isCreating;

  PropertyController({String? id, Property? property}) {
    assert(id == null || property == null || id == property.id);
    if (property != null) {
      _property = property;
    } else {
      _property = _property.copyWith(PropertyUpdate(id: id));
    }
    load();
  }

  /// A function to load the [Property]
  Future<void> load() async {
    loadProperty() async {
      if (isCreating) {
        return;
      }
      _property = await PropertyService().get(property.id!);
    }

    loadHandler(
      future: loadProperty(),
    );
  }

  /// Change the notes of the [Property]
  Future<void> update(PropertyUpdate update) async {
    updateNotes() async {
      if (isCreating) {
        _property = property.copyWith(update);
        return;
      }
      await PropertyService().update(property.id!, update).then((hasSuccess) {
        _property = property.copyWith(update);
      });
    }

    loadHandler(future: updateNotes());
  }

  /// Creates the [Property]
  Future<void> create() async {
    assert(property.isCreating, "Only use create when the Property is creating");
    createProperty() async {
      await PropertyService().create(property).then((newProperty) {
        property = newProperty;
      });
    }

    loadHandler(future: createProperty());
  }
}
