import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_widget/content_selection.dart';
import 'package:provider/provider.dart';
import 'package:tasks/dataclasses/organization.dart';
import 'package:tasks/screens/settings_screen.dart';
import 'package:tasks/services/current_ward_svc.dart';
import 'package:tasks/services/organization_svc.dart';
import 'package:tasks/services/ward_service.dart';
import '../dataclasses/ward.dart';

/// A Screen to select the current [Organization] and [Ward]
class WardSelectScreen extends StatefulWidget {
  const WardSelectScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WardSelectScreen();
}

class _WardSelectScreen extends State<WardSelectScreen> {
  String? organizationId;
  String? wardId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localization!.selectWard),
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
          ListTile(
            // TODO change to organization name
            title: Text(organizationId ?? context.localization!.none),
            subtitle: Text(context.localization!.organization),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.push<Organization?>(
              context,
              MaterialPageRoute(
                builder: (context) => ListSearch<Organization>(
                  title: context.localization!.organization,
                  asyncItems: (_) async {
                    List<Organization> organizations = await OrganizationService().getOrganizationsForUser();
                    return organizations;
                  },
                  elementToString: (Organization t) => t.name,
                ),
              ),
            ).then((value) {
              if (value != null) {
                setState(() {
                  // check if ward is changed
                  if (value.id != organizationId) {
                    wardId = null;
                  }
                  organizationId = value.id;
                });
              }
            }),
          ),
          ListTile(
            // TODO change to organization name
            title: Text(wardId ?? context.localization!.none),
            subtitle: Text(context.localization!.ward),
            trailing: const Icon(Icons.arrow_forward),
            onTap: organizationId == null
                ? null
                : () => Navigator.push<WardOverview?>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListSearch<WardOverview>(
                          title: context.localization!.ward,
                          asyncItems: (_) async {
                            List<WardOverview> organizations =
                                await WardService().getWardOverviews(organizationId: organizationId);
                            return organizations;
                          },
                          elementToString: (WardOverview ward) => ward.name,
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          wardId = value.id;
                        });
                      }
                    }),
          ),
          Consumer<CurrentWardController>(
            builder: (context, currentWardService, __) => TextButton(
              onPressed: () {
                if (wardId == null || organizationId == null) {
                  return;
                }
                currentWardService.currentWard = CurrentWardInformation(wardId!, organizationId!);
              },
              child: Text(context.localization!.switch_),
            ),
          ),
        ],
      ),
    );
  }
}
