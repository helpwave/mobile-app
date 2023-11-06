import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasks/config/config.dart';

/// A readonly class for getting the CurrentWard information
class CurrentWardInformation {
  /// The identifier of the ward
  final String _wardId;

  /// The identifier of the organization
  final String _organizationId;

  String get wardId => _wardId;

  String get organizationId => _organizationId;

  CurrentWardInformation(this._wardId, this._organizationId);
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
      return CurrentWardInformation(wardId, organizationId);
    }
    return null;
  }
}

/// Service for the [CurrentWardInformation]
///
/// Changes the [CurrentWardInformation] globally
class CurrentWardService extends Listenable {
  /// Whether this Controller has been initialized
  bool _isInitialized = false;

  /// A storage for the current ward
  final _CurrentWardPreferences _preferences = _CurrentWardPreferences();

  /// The current ward information
  CurrentWardInformation? _currentWard;

  /// Whether this Controller has been initialized
  bool get isInitialized => _isInitialized;

  /// Listeners
  final List<VoidCallback> _listeners = [];

  CurrentWardService._initialize() {
    if (!DEV_MODE) {
      load();
    }
  }

  static final CurrentWardService _currentWardService = CurrentWardService._initialize();

  factory CurrentWardService() => _currentWardService;

  set currentWard(CurrentWardInformation? currentWard) {
    if (!DEV_MODE) {
      if (currentWard == null) {
        _preferences.clear();
      } else {
        _preferences.setInformation(currentWard: currentWard);
      }
    }
    _currentWard = currentWard;
    _isInitialized = _currentWard != null;
    notifyListeners();
  }

  CurrentWardInformation? get currentWard => _currentWard;

  /// Load the preferences with the [ThemePreferences]
  Future<void> load() async {
    _currentWard = await _preferences.getInformation();
    if (_currentWard != null) {
      _isInitialized = true;
    }
    notifyListeners();
  }

  /// Clears the [CurrentWardInformation]
  void clear() {
    _isInitialized = false;
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

  CurrentWardController() {
    service.addListener(notifyListeners);
    if (!service.isInitialized) {
      load();
    }
  }

  set currentWard(CurrentWardInformation? currentWard) {
    service.currentWard = currentWard;
  }

  CurrentWardInformation? get currentWard => service.currentWard;

  /// Load the preferences with the [ThemePreferences]
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
