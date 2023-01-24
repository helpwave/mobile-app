import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave/config/language.dart';
import 'package:helpwave/services/language_model.dart';

/// Page for displaying language option and changing to the selected one
class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageModel>(builder: (_, LanguageModel languageNotifier, __) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.localization!.selectLanguage),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: languages.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return RadioListTile(
                value: languages[index],
                onChanged: (Map<String, String>? language) => languageNotifier.setLanguage(language!["Local"]!),
                title: Text(languages[index]["Name"]!),
                groupValue: languages.firstWhere((language) => language["Name"] == languageNotifier.name),
              );
            },
          ),
        ),
      );
    });
  }
}
