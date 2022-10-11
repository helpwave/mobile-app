import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/main.dart';

class SettingListView extends StatelessWidget {
  const SettingListView({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> languages = {"English": "en", "Deutsch": "de"};

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.selectLanguage),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: languages.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () => {
                  MyApp.of(context)?.setLocale(
                      Locale(languages.values.elementAt(index), "")),
                  Navigator.pop(context)
                },
                title: Text(languages.keys.elementAt(index)),
              );
            }),
      ),
    );
  }
}
