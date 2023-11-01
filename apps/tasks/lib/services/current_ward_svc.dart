import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A readonly class for getting the CurrentWard information
class CurrentWardInformation {
  final String _wardId;
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

  clear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(sharedPreferencesCurrentWardKey);
    sharedPreferences.remove(sharedPreferencesCurrentOrganizationKey);
  }

  setInformation({required CurrentWardInformation currentWard}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(sharedPreferencesCurrentWardKey, currentWard.wardId);
    sharedPreferences.setString(sharedPreferencesCurrentOrganizationKey, currentWard.organizationId);
  }

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

/// Model for the Color Theme
///
/// Notifies about changes in light or dark theme preference
class CurrentWardService extends ChangeNotifier {
  bool _isInitialized = false;
  final _CurrentWardPreferences _preferences = _CurrentWardPreferences();
  CurrentWardInformation? _currentWard;

  bool get isInitialized => _isInitialized;

  CurrentWardService() {
    load();
  }

  set currentWard(CurrentWardInformation? currentWard) {
    if (currentWard == null) {
      _preferences.clear();
      _isInitialized = false;
    } else {
      _preferences.setInformation(currentWard: currentWard);
      _isInitialized = true;
    }
    _currentWard = currentWard;
    notifyListeners();
  }

  CurrentWardInformation? get currentWard => _currentWard;

  /// Load the preferences with the [ThemePreferences]
  Future<void> load() async {
    _currentWard = await _preferences.getInformation();
    if(_currentWard != null){
      _isInitialized = true;
    }
    notifyListeners();
  }

  /// Clears the [CurrentWardInformation]
  void clear(){
    _isInitialized = false;
    currentWard = null;
  }
}
