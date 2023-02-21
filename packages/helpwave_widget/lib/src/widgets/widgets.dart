import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

/// A Card to Display a ListTile mainly used to Simplify wrapping a ListTile in a Card
class ListTileCard extends StatelessWidget {
  /// The margin of the Card
  final EdgeInsetsGeometry margin;

  /// The [BorderRadius] of the Card
  final BorderRadius borderRadius;

  /// The Title Widget of the ListTile
  final Widget? title;

  /// Text to display in Title as a [Text] Widget
  ///
  /// Overwritten by [title]
  final String titleText;

  /// OnTap Function of the Card
  final void Function()? onTap;

  /// The trailing Widget of the ListTile
  final Widget? trailing;

  /// The leading Widget of the ListTile
  final Widget? leading;

  /// Padding Inside the ListTile
  final EdgeInsetsGeometry contentPadding;

  /// The shape of the
  final ShapeBorder? shape;

  const ListTileCard({
    super.key,
    this.margin = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(borderRadiusMedium)),
    this.title,
    this.titleText = "Title Text",
    this.onTap,
    this.trailing,
    this.leading,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: distanceSmall),
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shape ?? RoundedRectangleBorder(borderRadius: borderRadius),
      margin: margin,
      child: ListTile(
        shape: shape ?? RoundedRectangleBorder(borderRadius: borderRadius),
        contentPadding: contentPadding,
        title: title ?? Text(titleText),
        onTap: onTap,
        leading: leading,
        trailing: trailing,
      ),
    );
  }
}
