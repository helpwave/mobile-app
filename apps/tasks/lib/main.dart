import 'package:flutter/material.dart';
import 'package:helpwave_localization/l10n/app_localizations.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_localization/localization_model.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageModel(),
        ),
      ],
      child: Consumer2<ThemeModel, LanguageModel>(
        builder:
        (_, ThemeModel themeNotifier, LanguageModel languageNotifier, __) {
          return MaterialApp(
            darkTheme: darkTheme,
            themeMode:  themeNotifier.isDark != null && themeNotifier.isDark != null
                ? ThemeMode.dark : ThemeMode.light,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: getSupportedLocals(),
            locale: Locale(languageNotifier.language),
            home: const MyHomePage(title: 'Flutter Demo Home Page'),
          );
        }
      )
    );

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
