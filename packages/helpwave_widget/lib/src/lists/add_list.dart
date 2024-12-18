import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/shapes.dart';

/// The default add icon for the [AddList]
class _DefaultAddButton extends StatelessWidget {
  final Function() onClick;

  const _DefaultAddButton({required this.onClick});

  @override
  Widget build(BuildContext context) {
    const double subtaskAddIconSize = 21;
    return Circle(
      color: context.theme.colorScheme.primary,
      diameter: subtaskAddIconSize,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: subtaskAddIconSize,
        onPressed: onClick,
        icon: Icon(
          Icons.add_rounded,
          color: context.theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}

/// A [Widget] for displaying a [List] and offering an row with a title and an add button
class AddList<T> extends StatelessWidget {
  /// The items to be mapped
  final List<T> items;

  /// The builder function for the items of the list
  final Widget Function(BuildContext, int, T) itemBuilder;

  /// The [title] of the the list
  final Widget title;

  /// The function to call when pressing the add button
  final Function() onAdd;

  /// The maximum height of the list
  final double maxHeight;

  /// The builder function for a custom add Button that isn't the [_DefaultAddButton]
  final Widget Function(BuildContext, Function())? addButtonBuilder;

  const AddList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.title,
    required this.onAdd,
    this.maxHeight = double.infinity,
    this.addButtonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            title,
            addButtonBuilder != null ? addButtonBuilder!(context, onAdd) : _DefaultAddButton(onClick: onAdd),
          ],
        ),
        const SizedBox(height: distanceSmall),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            children: items.indexed.map((e) => itemBuilder(context, e.$1, e.$2)).toList(),
          ),
        ),
      ],
    );
  }
}
