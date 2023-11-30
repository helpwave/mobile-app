/// The minimum number of characters for a password
const minimumPasswordCharacters = 6;

/// Whether the development mode should be enabled
///
/// Shortens the login
const bool DEV_MODE = false;

/// The API for testing
const String STAGING_API_URL = "staging.api.helpwave.de";

/// The API for production
const String PRODUCTION_API_URL = "api.helpwave.de";

/// The API to be used
const String USED_API_URL = DEV_MODE ? STAGING_API_URL : PRODUCTION_API_URL;
