import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/enums/rhesus_factor.dart';
import 'package:helpwave/styling/constants.dart';
import '../enums/blood_type.dart';

/// ListTile for the Selection of the patients blood type
///
/// BloodType is divided to the Blood-Group [initialBloodType] and
/// Rhesus-Factor [initialRhesusFactor]
class BloodTypeSelect extends StatefulWidget {
  /// Initial Value for the [BloodType] in the Selection
  final BloodType initialBloodType;

  /// Initial Value for the [RhesusFactor] in the Selection
  final RhesusFactor initialRhesusFactor;

  /// Callback for changes to the [BloodType]
  final void Function(BloodType) changedBloodType;

  /// Callback for changes to the [RhesusFactor]
  final void Function(RhesusFactor) changedRhesusFactor;

  const BloodTypeSelect(
      {super.key,
      this.initialBloodType = BloodType.none,
      this.initialRhesusFactor = RhesusFactor.none,
      required this.changedBloodType,
      required this.changedRhesusFactor});

  @override
  State<StatefulWidget> createState() => _BloodTypeSelectState();
}

class _BloodTypeSelectState extends State<BloodTypeSelect> {
  BloodType selectedBloodType = BloodType.none;
  RhesusFactor selectedRhesusFactor = RhesusFactor.none;

  final Map<RhesusFactor, String> rhesusMap = {
    RhesusFactor.none: 'N/A',
    RhesusFactor.rhPlus: 'Rh+',
    RhesusFactor.rhMinus: 'Rh-',
  };

  final Map<BloodType, String> bloodTypeMap = {
    BloodType.none: 'N/A',
    BloodType.a: 'A',
    BloodType.b: 'B',
    BloodType.ab: 'AB',
    BloodType.o: 'O',
  };

  @override
  void initState() {
    super.initState();
    selectedBloodType = widget.initialBloodType;
    selectedRhesusFactor = widget.initialRhesusFactor;
  }

  @override
  Widget build(BuildContext context) {
    const OutlineInputBorder inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadiusMedium)));
    double selectWidth = 80;

    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.bloodType),
          leading: const Icon(Icons.bloodtype),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: selectWidth,
                child: DropdownButtonFormField<BloodType>(
                  value: selectedBloodType,
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: dropDownVerticalPadding,
                        right: dropDownVerticalPadding),
                    labelText: AppLocalizations.of(context)!.type,
                    border: inputBorder,
                  ),
                  onChanged: (BloodType? newValue) {
                    setState(() {
                      selectedBloodType = newValue!;
                    });
                    widget.changedBloodType(selectedBloodType);
                  },
                  items: BloodType.values
                      .map<DropdownMenuItem<BloodType>>((BloodType value) {
                    return DropdownMenuItem<BloodType>(
                      value: value,
                      child: Text(bloodTypeMap[value]!),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: distanceDefault),
              SizedBox(
                width: selectWidth,
                child: DropdownButtonFormField<RhesusFactor>(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: dropDownVerticalPadding,
                        right: dropDownVerticalPadding),
                    labelText: AppLocalizations.of(context)!.rhesus,
                    border: inputBorder,
                  ),
                  value: selectedRhesusFactor,
                  isExpanded: true,
                  onChanged: (RhesusFactor? newValue) {
                    setState(() {
                      selectedRhesusFactor = newValue!;
                    });
                    widget.changedRhesusFactor(selectedRhesusFactor);
                  },
                  items: RhesusFactor.values
                      .map<DropdownMenuItem<RhesusFactor>>(
                          (RhesusFactor value) {
                    return DropdownMenuItem<RhesusFactor>(
                      value: value,
                      child: Text(rhesusMap[value]!),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
