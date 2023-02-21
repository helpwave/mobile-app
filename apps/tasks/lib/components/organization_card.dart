import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

/// A Card to Display a organization
class OrganizationCard extends StatelessWidget {
  // TODO replace type with organization data class
  /// The [Organization] to display
  final Map<String, String> organization;

  /// The margin of the Card
  final EdgeInsetsGeometry margin;

  /// The [BorderRadius] of the Card
  final BorderRadius borderRadius;

  /// Whether the user is in the organization
  final bool isInOrganization;

  const OrganizationCard({
    super.key,
    required this.organization,
    this.margin = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(borderRadiusMedium)),
    this.isInOrganization = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      margin: margin,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        contentPadding: const EdgeInsets.symmetric(horizontal: distanceSmall),
        title: Text(organization["name"]!),
        // TODO open WardView here
        onTap: () => {},
        /* Navigator.of(context).push(MaterialPageRoute(builder: (context) => WardView(),),), */
        trailing: Icon(isInOrganization ? Icons.arrow_forward_rounded: Icons.swap_horiz_outlined),
      ),
    );
  }
}
