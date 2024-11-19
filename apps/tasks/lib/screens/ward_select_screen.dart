import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/auth.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_service/user.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/content_selection.dart';
import 'package:helpwave_widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tasks/screens/settings_screen.dart';

/// A Screen to select the current [OrganizationService] and [Ward]
class WardSelectScreen extends StatefulWidget {
  const WardSelectScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WardSelectScreen();
}

class _WardSelectScreen extends State<WardSelectScreen> {
  Organization? organization;
  WardMinimal? ward;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization.selectWard),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          ForwardNavigationTile(
            title:organization?.longName ?? context.localization.none,
            subtitle: context.localization.organization,
            onTap: () => Navigator.push<Organization?>(
              context,
              MaterialPageRoute(
                builder: (context) => ListSearch<Organization>(
                  title: context.localization.organization,
                  asyncItems: (_) async {
                    List<Organization> organizations = await OrganizationService().getOrganizationsForUser();
                    return organizations;
                  },
                  elementToString: (Organization t) => t.longName,
                ),
              ),
            ).then((value) {
              if (value != null) {
                setState(() {
                  // check if ward is changed
                  if (value.id != organization?.id) {
                    ward = null;
                  }
                  organization = value;
                });
              }
            }),
          ),
          ForwardNavigationTile(
            title: ward?.name ?? context.localization.none,
            subtitle: context.localization.ward,
            onTap: organization == null
                ? null
                : () => Navigator.push<WardMinimal?>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListSearch<WardMinimal>(
                          title: context.localization.ward,
                          asyncItems: (_) async =>
                              await WardService().getWards(organizationId: organization!.id),
                          elementToString: (WardMinimal ward) => ward.name,
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          ward = value;
                        });
                      }
                    }),
          ),
          Consumer<CurrentWardController>(
            builder: (context, currentWardService, __) => TextButton(
              style: buttonStyleBig,
              onPressed: () {
                if (ward == null || organization == null) {
                  return;
                }
                currentWardService.currentWard = CurrentWardInformation(ward!, organization!);
              },
              child: Text(context.localization.switch_),
            ),
          ),
        ],
      ),
    );
  }
}
