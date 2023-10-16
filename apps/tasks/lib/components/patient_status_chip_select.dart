import 'package:flutter/cupertino.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_widget/content_selection.dart';
import 'package:tasks/dataclasses/patient.dart';

enum PatientStatusChipSelectOptions { active, unassigned, discharged, all }

/// A Wrapper for showing a [SingleChipSelect] for the [Patient]'s status
class PatientStatusChipSelect extends StatelessWidget {
  /// The initially selected option
  final PatientAssignmentStatus? initialSelection;

  /// The Options for the ChipSelect
  final List<PatientStatusChipSelectOptions> options = const [
    PatientStatusChipSelectOptions.all,
    PatientStatusChipSelectOptions.active,
    PatientStatusChipSelectOptions.unassigned,
    PatientStatusChipSelectOptions.discharged,
  ];

  /// The [SingleChipSelect.onChange] function
  final void Function(PatientAssignmentStatus? value) onChange;

  const PatientStatusChipSelect({
    super.key,
    required this.onChange,
    this.initialSelection,
  });

  PatientAssignmentStatus? _toPatientAssignmentStatus(PatientStatusChipSelectOptions status) {
    switch (status) {
      case PatientStatusChipSelectOptions.all:
        return null;
      case PatientStatusChipSelectOptions.active:
        return PatientAssignmentStatus.active;
      case PatientStatusChipSelectOptions.unassigned:
        return PatientAssignmentStatus.unassigned;
      case PatientStatusChipSelectOptions.discharged:
        return PatientAssignmentStatus.discharged;
    }
  }

  PatientStatusChipSelectOptions _fromPatientAssignmentStatus(PatientAssignmentStatus? status) {
    if (status == null) {
      return PatientStatusChipSelectOptions.all;
    }
    switch (status) {
      case PatientAssignmentStatus.active:
        return PatientStatusChipSelectOptions.active;
      case PatientAssignmentStatus.unassigned:
        return PatientStatusChipSelectOptions.unassigned;
      case PatientAssignmentStatus.discharged:
        return PatientStatusChipSelectOptions.discharged;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChipSelect<PatientStatusChipSelectOptions>(
      options: options,
      initialSelection: _fromPatientAssignmentStatus(initialSelection),
      onChange: (value) => onChange(_toPatientAssignmentStatus(value ?? PatientStatusChipSelectOptions.all)),
      labeling: (value) {
        var translationMap = {
          PatientStatusChipSelectOptions.all: context.localization!.all,
          PatientStatusChipSelectOptions.active: context.localization!.active,
          PatientStatusChipSelectOptions.unassigned: context.localization!.unassigned,
          PatientStatusChipSelectOptions.discharged: context.localization!.discharged,
        };
        return translationMap[value]!;
      },
    );
  }
}
