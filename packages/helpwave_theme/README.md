## Features

This package provides a dark and light theme and additional constants regarding the style of an app.

It also provides a service to easily change and save the Thememode

## Getting started

Install this package

## Usage

```dart
ChangeNotifierProvider(
  create: (BuildContext context) => ThemeModel(),
  child: Consumer<ThemeModel>(
    builder: (BuildContext context, ThemeModel value, Widget? child) {
      return MaterialApp(
        title: 'helpwave tasks',
        themeMode: themeNotifier.themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const Scaffold(),
      );
    },
  ),
);
```

## Additional information

