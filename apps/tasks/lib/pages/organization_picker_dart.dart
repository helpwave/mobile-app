import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';

/// Page for Picking the Organizations the us
class OrganizationPickerPage extends StatelessWidget {
  const OrganizationPickerPage({super.key});

  Future<List<Map<String, String>>> getMyOrganizations() async {
    return [
      {"name": "Ward 1"},
      {"name": "Ward 2"},
      {"name": "Ward 3"}
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getMyOrganizations(),
        builder: (context, snapshot) {
          // TODO delete when required widgets are merged
          /*
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
          if (snapshot.data![0].isNotEmpty) {
            children.add(Text(context.localization!.myWards, style: titleStyle));
            children.addAll(snapshot.data![0].map(
              (organization) => OrganizationCard(
                organization: organization,
                margin: const EdgeInsets.only(top: distanceSmall),
                isInOrganization: true,
              ),
            ));
          }
          if (snapshot.data![1].isNotEmpty) {
            if (snapshot.data![0].isNotEmpty) {
              children.add(const SizedBox(height: distanceDefault));
            }
            children.add(Text(context.localization!.otherWards, style: titleStyle));
            children.addAll(snapshot.data![1].map(
              (organization) => Card(
                organization: organization,
                margin: const EdgeInsets.only(top: distanceSmall),
                isInOrganization: false,
              ),
            ));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(distanceDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          );*/
          return Container();
        },
      ),
    );
  }
}
