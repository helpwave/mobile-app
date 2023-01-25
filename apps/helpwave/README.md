# Install and Run
1. Follow [Getting Started](../../README.md)
   `dart pub global activate melos`
Alternative:
1. `flutter pub get` in project folder
2. `flutter run` 
    - **requires** connected mobile device, emulator or flutter web enabled (not supported by this project) or use of [Android Studio](https://developer.android.com/studio)
    
# Android and iOS builds
## Android
- `flutter build appbundle` results in .aab
- `flutter build apk --split-per-abi` results in .apk
- further information [here](https://docs.flutter.dev/deployment/android)

## iOS
- `flutter build ipa` results in .ipa
- further inforamtion [here](https://docs.flutter.dev/deployment/ios) 

# Packages and Commands
## internationalizaion
- edit files `/l10n/*.arb`
- run `flutter gen-l10n`
- use `import 'package:flutter_gen/gen_l10n/app_localizations.dart';` and `AppLocalizations.of(context)!.<name of textID>`
