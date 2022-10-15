import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/main.dart';
import 'package:helpwave/services/language_model.dart';
import 'package:provider/provider.dart';

class SettingLanguageSelectionPage extends StatelessWidget {
  const SettingLanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageModel>(
        builder: (_, LanguageModel languageNotifier, __) {
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
                    languageNotifier.language = languages[index]["Shortname"]!,
                  },
                  title: Text(languages[index]["Name"]!),
                );
              }),
        ),
      );
    });
  }
}
