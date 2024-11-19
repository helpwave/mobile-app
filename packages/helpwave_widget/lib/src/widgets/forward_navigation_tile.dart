import 'package:flutter/material.dart';
import 'package:helpwave_theme/util.dart';

class ForwardNavigationTile extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final String title;
  final String? subtitle;
  final void Function()? onTap;
  final String? trailingText;

  const ForwardNavigationTile({
    super.key,
    this.icon,
    this.color,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null ? Icon(
        icon,
        color: color ?? context.theme.colorScheme.primary,
      ) : null,
      onTap: onTap,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          trailingText != null
              ? Text(
            trailingText!,
            style: context.theme.textTheme.labelLarge,
          )
              : const SizedBox(),
          Icon(
            Icons.chevron_right_rounded,
            color: context.theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}
