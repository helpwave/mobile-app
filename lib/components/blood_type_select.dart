import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave/enums/rhesus_factor.dart';
import 'package:helpwave/styling/constants.dart';
import '../enums/blood_type.dart';

class BloodTypeSelect extends StatefulWidget {
  final BloodType initialBloodType;
  final RhesusFactor initialRhesusFactor;
  final void Function(BloodType) changedBloodType;
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

    return Row(
      children: [
        Expanded(child: Text(AppLocalizations.of(context)!.bloodType)),
        SizedBox(
          width: selectWidth,
          child: DropdownButtonFormField<BloodType>(
            value: selectedBloodType,
            onChanged: (value) => {
              setState(() {
                selectedBloodType = value!;
                widget.changedBloodType(selectedBloodType);
              })
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: dropDownVerticalPadding,
                  right: dropDownVerticalPadding),
              labelText: AppLocalizations.of(context)!.type,
              border: inputBorder,
            ),
            icon: const Icon(Icons.expand_more),
            items: BloodType.values
                .map<DropdownMenuItem<BloodType>>((BloodType bloodType) {
              String itemName = "";
              switch (bloodType) {
                case BloodType.a:
                  itemName = AppLocalizations.of(context)!.bloodTypeA;
                  break;
                case BloodType.b:
                  itemName = AppLocalizations.of(context)!.bloodTypeB;
                  break;
                case BloodType.ab:
                  itemName = AppLocalizations.of(context)!.bloodTypeAB;
                  break;
                case BloodType.o:
                  itemName = AppLocalizations.of(context)!.bloodTypeO;
                  break;
                case BloodType.none:
                  itemName = AppLocalizations.of(context)!.notAnswered;
                  break;
              }
              return DropdownMenuItem<BloodType>(
                value: bloodType,
                child: Text(itemName),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: distanceDefault),
        SizedBox(
          width: selectWidth,
          child: DropdownButtonFormField<RhesusFactor>(
            value: selectedRhesusFactor,
            onChanged: (value) => {
              setState(() {
                selectedRhesusFactor = value!;
                widget.changedRhesusFactor(selectedRhesusFactor);
              })
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: dropDownVerticalPadding,
                  right: dropDownVerticalPadding),
              labelText: AppLocalizations.of(context)!.rhesus,
              border: inputBorder,
            ),
            icon: const Icon(Icons.expand_more),
            items: RhesusFactor.values.map<DropdownMenuItem<RhesusFactor>>(
                (RhesusFactor rhesusFactor) {
              String itemName = "";
              switch (rhesusFactor) {
                case RhesusFactor.rhMinus:
                  itemName = AppLocalizations.of(context)!.rhMinus;
                  break;
                case RhesusFactor.rhPlus:
                  itemName = AppLocalizations.of(context)!.rhPlus;
                  break;
                case RhesusFactor.none:
                  itemName = AppLocalizations.of(context)!.notAnswered;
                  break;
              }
              return DropdownMenuItem<RhesusFactor>(
                value: rhesusFactor,
                child: Text(itemName),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
