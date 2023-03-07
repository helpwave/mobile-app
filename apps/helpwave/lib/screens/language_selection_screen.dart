import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_localization/localization_model.dart';

/// Screen for displaying language option and changing to the selected one
class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> languages = getSupportedLocalsMap();
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
