import 'package:grpc/grpc.dart';
import 'package:helpwave_proto_dart/services/property_svc/v1/property_svc.pbgrpc.dart';
import 'package:helpwave_service/src/api/property/property_api_service_clients.dart';
import 'package:helpwave_service/src/api/util/crud_interface.dart';
import '../../../../property.dart';
import '../util/type_converter.dart';

/// The GRPC Service for [Property]s
///
/// Provides queries and requests that load or alter [Property] objects on the server
/// The server is defined in the underlying [PropertyAPIServiceClients]
class PropertyService implements CRUDInterface<Property, Property, PropertyUpdate>{
  /// The GRPC ServiceClient which handles GRPC
  PropertyServiceClient service = PropertyAPIServiceClients().propertyServiceClient;

  @override
  Future<Property> get(String id) async {
    GetPropertyRequest request = GetPropertyRequest(id: id);
    GetPropertyResponse response = await service.getProperty(
      request,
      options: CallOptions(metadata: PropertyAPIServiceClients().getMetaData()),
    );

    return Property(
        id: response.id,
        name: response.name,
        subjectType: PropertyGRPCTypeConverter.subjectTypeFromGRPC(response.subjectType),
        fieldType: PropertyGRPCTypeConverter.fieldTypeFromGRPC(response.fieldType),
        description: response.description,
        setId: response.hasSetId() ? response.setId : null,
        alwaysIncludeForViewSource:
            response.hasAlwaysIncludeForViewSource() ? response.alwaysIncludeForViewSource : null,
        isArchived: response.isArchived,
        selectData: response.hasSelectData() ? PropertySelectData() : null);
  }

  Future<List<Property>> getMany({PropertySubjectType? subjectType}) async {
    GetPropertiesRequest request = GetPropertiesRequest();
    if (subjectType != null) {
      request.subjectType = PropertyGRPCTypeConverter.subjectTypeToGRPC(subjectType);
    }
    GetPropertiesResponse response = await service.getProperties(
      request,
      options: CallOptions(metadata: PropertyAPIServiceClients().getMetaData()),
    );

    List<Property> beds = response.properties
        .map((value) => Property(
            id: value.id,
            name: value.name,
            subjectType: PropertyGRPCTypeConverter.subjectTypeFromGRPC(value.subjectType),
            fieldType: PropertyGRPCTypeConverter.fieldTypeFromGRPC(value.fieldType),
            description: value.description,
            setId: value.hasSetId() ? value.setId : null,
            isArchived: value.isArchived,
            selectData: value.hasSelectData() ? PropertySelectData() : null))
        .toList();

    return beds;
  }

  @override
  Future<Property> create(Property property) async {
    CreatePropertyRequest request = CreatePropertyRequest(
        name: property.name,
        description: property.description,
        setId: property.setId,
        subjectType: PropertyGRPCTypeConverter.subjectTypeToGRPC(property.subjectType),
        fieldType: PropertyGRPCTypeConverter.fieldTypeToGRPC(property.fieldType),
        selectData: property.isSelectType
            ? CreatePropertyRequest_SelectData(
                options: property.selectData!.options.map((option) => CreatePropertyRequest_SelectData_SelectOption(
                      name: option.name,
                      description: option.description,
                    )),
                allowFreetext: property.selectData!.isAllowingFreeText,
              )
            : null);
    CreatePropertyResponse response = await service.createProperty(
      request,
      options: CallOptions(metadata: PropertyAPIServiceClients().getMetaData()),
    );

    return property.copyWith(PropertyUpdate(id: response.propertyId,));
  }

  @override
  Future<bool> update(String id, PropertyUpdate update) async {
    UpdatePropertyRequest request = UpdatePropertyRequest(id: id, name: name);
    await service.updateBed(
      request,
      options: CallOptions(metadata: PropertyAPIServiceClients().getMetaData()),
    );
  }

  @override
  Future<bool> delete(String id) {
    throw UnimplementedError("The Deletion of Properties is currently not allowed");
  }
}
