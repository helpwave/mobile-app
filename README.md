# helpwave app
The official helpwave mobile app for android and ios

# Install and Run
1. Install [Flutter](https://docs.flutter.dev/get-started/install) version >=3.3
1. `flutter run` 
    - **requires** connected mobile device, emulator or flutter web enabled (not supported by this project) or use of [Android Studio](https://developer.android.com/studio)
    
# Android and iOS builds
## Android
- `flutter build appbundle` results in .aab
- `flutter build apk --split-per-abi` results in .apk
- further information [here](https://docs.flutter.dev/deployment/android)

## iOS
- `flutter build ipa` results in .ipa
- further inforamtion [here](https://docs.flutter.dev/deployment/ios) 
