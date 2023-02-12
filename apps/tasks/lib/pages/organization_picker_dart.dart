import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:tasks/pages/home_page.dart';

/// Page for Picking the Organizations the us
class OrganizationPickerPage extends StatefulWidget {
  const OrganizationPickerPage({super.key});

  @override
  State<StatefulWidget> createState() => _OrganizationPickerPageState();
}

class _OrganizationPickerPageState extends State<OrganizationPickerPage> {
  Future<List<Map<String, String>>> getMyOrganizations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {"name": "Ward 1"},
      {"name": "Ward 2"},
      {"name": "Ward 3"}
    ];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.titleLarge!;
    return Scaffold(
      appBar: AppBar(title: Text(context.localization!.selectOrganizations)),
      body: FutureBuilder(
        future: getMyOrganizations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return LoadErrorWidget(
              iconColor: Theme.of(context).colorScheme.primary,
              errorText: context.localization!.errorOnLoad,
            );
          }
          if (!snapshot.hasData) {
            return LoadingSpinner(
              text: context.localization!.loading,
              color: Theme.of(context).colorScheme.primary,
            );
          }
          List<Widget> children = [];
          if (snapshot.data!.isNotEmpty) {
            children.addAll(snapshot.data!.map(
              (organization) => ListTileCard(
                titleText: organization["name"]!,
                margin: const EdgeInsets.only(top: distanceSmall),
                trailing: const Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
                  // TODO set current organization
                },
              ),
            ));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(distanceDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.localization!.myOrganizations, style: titleStyle),
                  const SizedBox(height: distanceSmall),
                  ...children,
                  const SizedBox(height: distanceBig),
                  Text(context.localization!.askForInvite, style: Theme.of(context).textTheme.titleMedium,),
                  const SizedBox(height: distanceSmall),
                  Center(
                    child: TextButton(
                      // TODO ad something to indicate reloading e.g. loading Spinner for at least 0.5 sec
                      onPressed: () => setState(() {}),
                      child: Text(context.localization!.refresh),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
