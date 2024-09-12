import 'package:flutter/cupertino.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_widget/content_selection.dart';

enum PatientStatusChipSelectOptions { all, active, unassigned, discharged }

/// A Wrapper for showing a [SingleChipSelect] for the [Patient]'s status
class PatientStatusChipSelect extends StatelessWidget {
  /// The initially selected option
  final PatientAssignmentStatus? initialSelection;

  /// The Options for the ChipSelect
  final List<PatientStatusChipSelectOptions> options = PatientStatusChipSelectOptions.values;

  /// The [SingleChipSelect.onChange] function
  final void Function(PatientAssignmentStatus? value) onChange;

  /// A mapping for statuses from [PatientStatusChipSelectOptions] to [PatientAssignmentStatus]
  final Map<PatientStatusChipSelectOptions, PatientAssignmentStatus?> _statusMapping = const {
    PatientStatusChipSelectOptions.all: null,
    PatientStatusChipSelectOptions.active: PatientAssignmentStatus.active,
    PatientStatusChipSelectOptions.unassigned: PatientAssignmentStatus.unassigned,
    PatientStatusChipSelectOptions.discharged: PatientAssignmentStatus.discharged,
  };

  const PatientStatusChipSelect({
    super.key,
    required this.onChange,
    this.initialSelection,
  });

  PatientAssignmentStatus? _toPatientAssignmentStatus(PatientStatusChipSelectOptions status) {
    return _statusMapping[status];
  }

  PatientStatusChipSelectOptions _fromPatientAssignmentStatus(PatientAssignmentStatus? status) {
    if (status == null) {
      return PatientStatusChipSelectOptions.all;
    }
    return _statusMapping.entries.firstWhere((element) => element.value == status).key;
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
