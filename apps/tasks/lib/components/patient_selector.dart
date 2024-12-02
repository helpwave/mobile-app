import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_service/tasks.dart';
import 'package:helpwave_theme/util.dart';
import 'package:helpwave_widget/loading.dart';

class PatientSelector extends StatelessWidget {
  final String? initialPatientId;
  final void Function(PatientMinimal? value) onChange;

  const PatientSelector({super.key, this.initialPatientId, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return LoadingFutureBuilder(
        future: PatientService().getPatientList(),
        loadingWidget: const PulsingContainer(width: 60, height: 20),
        thenBuilder: (context, patientList) {
          List<Patient> patients = patientList.active + patientList.unassigned;
          return DropdownButton(
            underline: const SizedBox(),
            iconEnabledColor: context.theme.colorScheme.primary.withOpacity(0.6),
            // removes the default underline
            padding: EdgeInsets.zero,
            hint: Text(
              context.localization.selectPatient,
              style: TextStyle(color: context.theme.colorScheme.primary.withOpacity(0.6)),
            ),
            isDense: true,
            items: patients.map((patient) => DropdownMenuItem(value: patient.id, child: Text(patient.name))).toList(),
            value: initialPatientId,
            onChanged: (value) {
              if (value != null) {
                onChange(patients.firstWhere((element) => element.id == value));
              }
            },
          );
        });
  }
}
