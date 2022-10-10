import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingListView extends StatelessWidget {
  const SettingListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> languages = ["German", "English (USA)"];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.language),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: languages.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () => {},
                title: Text(languages[index]),
              );
            }),
      ),
    );
  }
}
