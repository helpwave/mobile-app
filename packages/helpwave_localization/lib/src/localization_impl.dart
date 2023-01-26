import 'package:flutter/material.dart';
import 'package:helpwave_localization/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  get localization => AppLocalizations.of(this);
}
