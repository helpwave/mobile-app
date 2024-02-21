/// The minimum number of characters for a password
const minimumPasswordCharacters = 6;

/// Whether the development mode should be enabled
///
/// Shortens the login
const bool devMode = false;

/// The API for testing
const String stagingAPIURL = "staging.api.helpwave.de";

/// The API for production
const String productionAPIURL = "api.helpwave.de";

/// The API to be used
const String usedAPIURL = devMode ? stagingAPIURL : productionAPIURL;
