import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/dialog.dart';

import '../screens/landing_screen.dart';

/// A Card to display the [User] information
class UserCard extends StatelessWidget {
  /// Border radius of the [UserCard]
  final double borderRadius;

  const UserCard({
    super.key,
    this.borderRadius = borderRadiusMedium,
  });

  // TODO fetch real User Information from AuthService
  getUser() {
    return {
      'displayName': 'Max',
      'fullName': 'Max Mustermann',
      'email': 'max.musterman@dev.helpwave.de',
    };
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> user = getUser();
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AcceptDialog(
            content: Text(context.localization!.logoutInformation),
            yesText: context.localization!.logout,
            titleText: "${context.localization!.logoutInformation}?",
          ),
        ).then((value) {
          if (value != null && value) {
            Navigator.pop(context);
            // TODO logout user in [AuthService]
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LandingScreen()),
            );
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          contentPadding: const EdgeInsets.all(paddingSmall),
          // TODO replace with actual Avatar
          leading: CircleAvatar(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 1),
                  colors: <Color>[
                    Color(0xff1f005c),
                    Color(0xff5b0060),
                    Color(0xff870160),
                    Color(0xffac255e),
                    Color(0xffca485c),
                    Color(0xffe16b5c),
                    Color(0xfff39060),
                    Color(0xffffb56b),
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
            ),
          ),
          title: Text(
            user['displayName']!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user['fullName']!,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                user['email']!,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
