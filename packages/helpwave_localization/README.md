<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Internationalization package.

## Features

Extends the BuildContext to easily access the translations

## Getting started

1. Update `lib/l10n/*.arb` files with your translations
2. run `flutter gen-l10n`


## Usage

1. `import 'package:helpwave_localization/localization.dart';`
2. use `context.localization?.<textId>` or `AppLocalization.of(context)?.<textId>`

#### Thememodel
```dart
ChangeNotifierProvider(
  create: (_) => LanguageModel(),
  child: Consumer<LanguageModel>(
  builder: (BuildContext context, LanguageModel languageNotifier, _) {
    return MaterialApp(
      title: "title"
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: getSupportedLocals(),
      locale: Locale(languageNotifier.language),
      home: Scaffold
    )
  }
);
```

## Additional information

If you want to add translations you will have to edit the translations in the [l10n folder](./lib/l10n) 
and for adding a language you will additionally have to add it to the [config](./lib/src/config/language.dart).
