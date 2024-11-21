import 'package:helpwave_service/property.dart';
import 'package:helpwave_service/util.dart';

/// The Controller for managing [Property]s in a Ward
class PropertyController extends LoadController<String, Property, Property, PropertyUpdate, PropertyService> {
  PropertyController({String? id, Property? property})
      : super(id: id, initialData: property, service: PropertyService());

  @override
  Property defaultData() => Property.empty();
}
