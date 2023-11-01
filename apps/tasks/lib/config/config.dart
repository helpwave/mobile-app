/// The minimum number of characters for a password
const minimumPasswordCharacters = 6;

const bool DEV_MODE = false;
const String STAGING_API_URL = "staging.api.helpwave.de";
const String PRODUCTION_API_URL = "api.helpwave.de";
const String USED_API_URL = DEV_MODE ? STAGING_API_URL : PRODUCTION_API_URL;
