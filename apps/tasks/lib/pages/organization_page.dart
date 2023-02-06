import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/loading.dart';
import 'package:tasks/components/organization_card.dart';

/// Page to display all Organizations a user is in or could join
class OrganizationPage extends StatelessWidget {
  const OrganizationPage({super.key});

  Future<List<Map<String, String>>> getMyOrganizations() async {
    return [
      {"name": "Ward 1", "id": "id1"},
      {"name": "Ward 2", "id": "id2"},
      {"name": "Ward 3", "id": "id3"}
    ];
  }

  Future<List<Map<String, String>>> getAllOrganizations() async {
    return await Future.delayed(
      const Duration(seconds: 1, milliseconds: 200),
      () => [
        {"name": "Ward 4", "id": "id4"},
        {"name": "Ward 5", "id": "id5"},
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.titleLarge!;
    // TODO remove scaffold later on
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: Future.wait([getMyOrganizations(), getAllOrganizations()]),
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
          if (snapshot.data![0].isNotEmpty) {
            children.add(Text(context.localization!.myOrganizations, style: titleStyle));
            children.addAll(snapshot.data![0].map(
              (organization) => OrganizationCard(
                organization: organization,
                margin: const EdgeInsets.symmetric(vertical: distanceDefault / 2),
                isInOrganization: true,
              ),
            ));
          }
          if (snapshot.data![1].isNotEmpty) {
            if (snapshot.data![0].isNotEmpty) {
              children.add(const SizedBox(height: distanceDefault));
            }
            children.add(Text(context.localization!.allOrganizations, style: titleStyle));
            children.addAll(snapshot.data![1].map(
              (organization) => OrganizationCard(
                organization: organization,
                margin: const EdgeInsets.symmetric(vertical: distanceDefault / 2),
                isInOrganization: false,
              ),
            ));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: distanceDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }
}
