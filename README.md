# helpwave mobile-app
The official repository for helpwave mobile apps for android and ios

This project is tested with [BrowserStack](https://www.browserstack.com).

# [Projects](apps/)
- **[helpwave tasks](/apps/tasks)** the planning app for healthcare professionals
- **[helpwave impulse](/apps/impulse)** the app for playfully improving your well-being 

# [Packages](packages/)
- **[helpwave_localization](/packages/helpwave_localization)** the localization of all apps
- **[helpwave_service](/packages/helpwave_service)** the services used by the apps
- **[helpwave_theme](/packages/helpwave_theme)** the theme used by all apps
- **[helpwave_widget](/packages/helpwave_widget)** the reusable widgets shared between all apps

# Getting Started
1. install [Flutter](https://docs.flutter.dev/get-started/install) version >=3.13 and [melos](https://melos.invertase.dev/getting-started) (`dart pub global activate melos`)
2. run `melos bootstrap`
3. run `melos run intl`
4. navigate to `/apps/<project>`
5. run application in emulator `flutter run`
