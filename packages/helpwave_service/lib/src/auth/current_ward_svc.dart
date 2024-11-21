import 'package:flutter/foundation.dart';
import 'package:helpwave_service/src/api/offline/offline_client_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helpwave_service/src/api/tasks/index.dart';
import 'package:helpwave_service/src/api/user/index.dart';

/// A readonly class for getting the CurrentWard information
class CurrentWardInformation {
  /// The identifier of the ward
  final WardMinimal ward;

  /// The identifier of the organization
  final Organization organization;

  String get wardId => ward.id; // Id can be null

  String get wardName => ward.name;

  String get organizationId => organization.id ?? ""; // Id can be null

  String get organizationName => "${organization.longName} (${organization.shortName})";

  bool get isEmpty => wardId == "" || organizationId == ""; // TODO the ids are null and would throw an error

  bool get hasFullInformation => ward.name != "" && organization.longName != "";

  CurrentWardInformation(this.ward, this.organization);

  CurrentWardInformation copyWith({
    WardMinimal? ward,
    Organization? organization,
  }) {
    return CurrentWardInformation(
      ward ?? this.ward,
      organization ?? this.organization,
    );
  }

  @override
  String toString() {
    return "CurrentWardInformation: {ward: ${ward.toString()}, organization: ${organization.toString()}";
  }
}

// TODO consider other storage alternatives
/// Service for reading and writing the [CurrentWard] Preference
class _CurrentWardPreferences {
  /// Key of the Shared Preference for the current ward
  final String sharedPreferencesCurrentWardKey = "current_ward";

  /// Key of the Shared Preference for the current organization
  final String sharedPreferencesCurrentOrganizationKey = "current_ward_organization";

  /// Clears the shared preferences
  clear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(sharedPreferencesCurrentWardKey);
    sharedPreferences.remove(sharedPreferencesCurrentOrganizationKey);
  }

  /// Puts the new current ward to the shared preferences
  setInformation({required CurrentWardInformation currentWard}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(sharedPreferencesCurrentWardKey, currentWard.wardId);
    sharedPreferences.setString(sharedPreferencesCurrentOrganizationKey, currentWard.organizationId);
  }

  /// Reads the current ward from the shared preferences
  Future<CurrentWardInformation?> getInformation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? wardId = sharedPreferences.getString(sharedPreferencesCurrentWardKey);
    String? organizationId = sharedPreferences.getString(sharedPreferencesCurrentOrganizationKey);
    if (wardId != null && organizationId != null) {
      return CurrentWardInformation(
        WardMinimal(id: wardId, name: ""),
        Organization.empty(id: organizationId),
      );
    }
    return null;
  }
}

/// Service for the [CurrentWardInformation]
///
/// Changes the [CurrentWardInformation] globally
class CurrentWardService extends Listenable {
  bool _devMode = false; // TODO remove

  bool get devMode => _devMode;

  set devMode(bool value) {
    _devMode = value;
    if (UserAPIServiceClients().offlineMode) {
      Ward firstWard = OfflineClientStore().wardStore.wards[0];
      Organization firstOrganization = OfflineClientStore().organizationStore.organizations[0];
      currentWard = CurrentWardInformation(firstWard, firstOrganization);
    }
  }

  /// A storage for the current ward
  final _CurrentWardPreferences _preferences = _CurrentWardPreferences();

  /// The current ward information
  CurrentWardInformation? _currentWard;

  /// Whether this Controller has been initialized
  bool get isInitialized => currentWard != null && !currentWard!.isEmpty;

  /// Whether all information are loaded
  bool get isLoaded => currentWard != null && currentWard!.hasFullInformation;

  /// Listeners
  final List<VoidCallback> _listeners = [];

  CurrentWardService._initialize() {
    load();
  }

  static final CurrentWardService _currentWardService = CurrentWardService._initialize();

  factory CurrentWardService() => _currentWardService;

  set currentWard(CurrentWardInformation? currentWard) {
    if (!devMode) {
      if (currentWard == null) {
        _preferences.clear();
      } else {
        _preferences.setInformation(currentWard: currentWard);
      }
    }
    _currentWard = currentWard;
    if (!isLoaded) {
      fetch();
    }
    if (kDebugMode) {
      // TODO use logger
      print(currentWard);
    }
    notifyListeners();
  }

  CurrentWardInformation? get currentWard => _currentWard;

  /// Load the preferences with the [_CurrentWardPreferences]
  Future<void> load() async {
    await _preferences.getInformation().then((value) {
      if (!devMode) {
        currentWard = value;
      }
    });
  }

  Future<void> fakeLogin() async {
    try {
      Organization organization = (await OrganizationService().getOrganizationsForUser())[0];
      WardMinimal ward = (await WardService().getWards(organizationId: organization.id))[0];
      currentWard = CurrentWardInformation(ward, organization);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Fetch [Ward] and [Organization] from backend
  Future<void> fetch() async {
    if (!isInitialized) {
      return;
    }
    Organization organization = await OrganizationService().get(currentWard!.organizationId);
    WardMinimal ward = await WardService().get(id: currentWard!.wardId);
    _currentWard = CurrentWardInformation(ward, organization);
    notifyListeners();
  }

  /// Clears the [CurrentWardInformation]
  void clear() {
    currentWard = null;
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }
}

/// Controller for the [CurrentWardInformation]
///
/// Notifies about changes to the [CurrentWardInformation]
class CurrentWardController extends ChangeNotifier {
  CurrentWardService service = CurrentWardService();

  /// Whether this Controller has been initialized
  bool get isInitialized => service.isInitialized;

  CurrentWardController({bool devMode = false}) {
    service.devMode = devMode;
    service.addListener(notifyListeners);
    if (!service.isInitialized) {
      load();
    }
  }

  set currentWard(CurrentWardInformation? currentWard) {
    service.currentWard = currentWard;
  }

  CurrentWardInformation? get currentWard => service.currentWard;

  /// Load the information
  Future<void> load() async {
    service.load();
  }

  @override
  void dispose() {
    service.removeListener(notifyListeners);
    super.dispose();
  }

  /// Clears the [CurrentWardInformation]
  void clear() {
    service.clear();
  }
}
