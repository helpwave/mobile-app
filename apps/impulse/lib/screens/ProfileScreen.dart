import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

import '../dataclasses/user.dart';
import '../theming/colors.dart';

class ProfileScreen extends StatefulWidget {
  final User? initialUser;

  const ProfileScreen({super.key, this.initialUser});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  bool isCreating = false;
  User user =
      User(username: "", birthday: DateTime(2000), sex: Gender.na, pal: PAL.sitting, weight: 1, height: 1);

  @override
  void initState() {
    isCreating = widget.initialUser == null;
    if (!isCreating) {
      user.username = widget.initialUser!.username;
      user.sex = widget.initialUser!.sex;
      user.pal = widget.initialUser!.pal;
      user.birthday = widget.initialUser!.birthday;
      user.weight = widget.initialUser!.weight;
      user.height = widget.initialUser!.height;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const InputDecoration textFieldDecoration = InputDecoration(
      filled: true,
      fillColor: disabled,
      contentPadding: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: paddingSmall,
      ),
      border: OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
      ),
    );

    const InputDecoration dropdownDecoration = InputDecoration(
      border:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      disabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      errorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primary)),
      contentPadding: EdgeInsets.only(left: distanceSmall, right: distanceTiny),
      hoverColor: primary,
      fillColor: disabled,
      filled: true,
    );

    const BoxDecoration lizenzDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadiusMedium),
      ),
      color: tertiaryBackground,
    );


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(
              color: primary, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: Wrap(
              runSpacing: distanceSmall,
              children: [
                const Text(
                  "Dein Name",
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    user.username = value;
                  },
                  decoration: textFieldDecoration,
                  style: const TextStyle(
                    decoration: null,
                    color: primary,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  "Geschlecht",
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                InputDecorator(
                  decoration: dropdownDecoration,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      style: const TextStyle(color: primary),
                      value: user.sex,
                      items: [
                        DropdownMenuItem(
                          value: Gender.male,
                          child: Text(Gender.male.text),
                        ),
                        DropdownMenuItem(
                          value: Gender.female,
                          child: Text(Gender.female.text),
                        ),
                        DropdownMenuItem(
                          value: Gender.divers,
                          child: Text(Gender.divers.text),
                        ),
                        DropdownMenuItem(
                          value: Gender.na,
                          child: Text(Gender.na.text),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          user.sex = value ?? Gender.na;
                        });
                      },
                    ),
                  ),
                ),
                const Text(
                  "Größe in cm",
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    user.height = int.parse(value);
                  },
                  decoration: textFieldDecoration,
                  style: const TextStyle(
                    decoration: null,
                    color: primary,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  "Gewicht in kg",
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    user.weight = double.parse(value);
                  },
                  decoration: textFieldDecoration,
                  style: const TextStyle(
                    decoration: null,
                    color: primary,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  "PAL-Wert",
                  style: TextStyle(
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                InputDecorator(
                  decoration: dropdownDecoration,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      style: const TextStyle(color: primary),
                      value: user.pal,
                      items: [
                        DropdownMenuItem(
                          value: PAL.laying,
                          child: Text(PAL.laying.text),
                        ),
                        DropdownMenuItem(
                          value: PAL.sitting,
                          child: Text(PAL.sitting.text),
                        ),
                        DropdownMenuItem(
                          value: PAL.walking,
                          child: Text(PAL.walking.text),
                        ),
                        DropdownMenuItem(
                          value: PAL.standing,
                          child: Text(PAL.standing.text),
                        ),
                        DropdownMenuItem(
                          value: PAL.active,
                          child: Text(PAL.active.text),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          user.pal = value ?? PAL.sitting;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(child: Container()),

          Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: Container(
              decoration: lizenzDecoration,
              child: ListTile(
                contentPadding: const EdgeInsets.only(
                    left: paddingMedium, right: paddingSmall),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(borderRadiusMedium),
                  ),
                ),
                title: const Text(
                  "Lizenzen",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  size: iconSizeSmall,
                ),
                onTap: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return const LicensePage(
                        applicationName: 'helpwave impulse',
                        applicationVersion: '1.0.0',
                        applicationIcon: Icon(Icons.home),
                      );
                    },
                  ))
                },
              ),
            ),
          ),
          const SizedBox(height: distanceMedium),
          Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(primary),
                  fixedSize: MaterialStatePropertyAll(
                    Size.fromWidth(215),
                  ),
                ),
                child: const Text(
                  "Speichern",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
