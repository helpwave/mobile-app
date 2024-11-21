import 'copy_with_interface.dart';
import 'identified_object.dart';

abstract class CRUDObject<IdentifierType, DataType, CreateType, UpdateType> extends IdentifiedObject<IdentifierType>
    implements CopyWithInterface<DataType, UpdateType> {
  CRUDObject({super.id});

  DataType create(IdentifierType id);
}
