import 'package:flutter/cupertino.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_widget/content_selection.dart';

/// A Wrapper for showing a [SingleChipSelect] for the [Patient]'s status
class PatientStatusChipSelect extends StatelessWidget {
  const PatientStatusChipSelect({super.key, required this.onChange, this.initialSelection = "all"});

  /// The initially selected option
  final String initialSelection;

  /// The Options for the ChipSelect
  final List<String> options = const ["all", "active", "unassigned", "discharged"];

  /// The [SingleChipSelect.onChange] function
  final void Function(String? value) onChange;

  @override
  Widget build(BuildContext context) {
    return SingleChipSelect<String>(
      options: options,
      initialSelection: initialSelection,
      onChange: onChange,
      labeling: (value) {
        var translationMap = {
          "all": context.localization!.all,
          "active": context.localization!.active,
          "unassigned": context.localization!.unassigned,
          "discharged": context.localization!.discharged,
        };
        return translationMap[value]!;
      },
    );
  }
}
