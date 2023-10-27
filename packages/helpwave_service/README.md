## Features

- introduction services for saving whether the user has seen an introduction

## Getting started

Add the package to your `pubspec.yaml`

## Usage

```dart
ChangeNotifierProvider(
  create: (BuildContext context) => IntroductionModel(),
  child: Consumer<IntroductionModel>(
    builder: (BuildContext context, IntroductionModel value, Widget? child) {
      if (!value.isInitialized) {
        return const ScreenWhileLoading();
      }
      if (value.hasSeenIntroduction) {
        return const AftherIntroductionScreen();
      }
      return const IntroductionScreen();
    },
  ),
);
```

## Additional information


