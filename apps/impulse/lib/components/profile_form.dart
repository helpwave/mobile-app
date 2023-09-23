import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/theming/colors.dart';
import '../dataclasses/user.dart';

class ProfileForm extends StatefulWidget {
  final User? initialUser;

  const ProfileForm({super.key, this.initialUser});

  @override
  State<StatefulWidget> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  String name = "";
  bool isCreating = false;
  User user = User(
    username: "",
    birthday: DateTime(2000),
    gender: Gender.na,
    pal: 1,
    id: 'user1',
  );

  @override
  void initState() {
    isCreating = widget.initialUser == null;
    if (!isCreating) {
      user.username = widget.initialUser!.username;
      user.gender = widget.initialUser!.gender;
      user.pal = widget.initialUser!.pal;
      user.birthday = widget.initialUser!.birthday;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8 -
                  paddingMedium -
                  paddingSmall,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadiusBig),
              ),
              padding: const EdgeInsets.all(paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      isCreating
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(primary),
                              ),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                      const Padding(
                        padding: EdgeInsets.all(paddingSmall),
                        child: Center(
                          child: Text(
                            "Profil",
                            style: TextStyle(
                                color: primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: distanceBig,
                  ),
                  const Text(
                    "Dein Name",
                    style: TextStyle(
                      color: labelColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: distanceTiny,
                  ),
                  TextField(
                    onChanged: (value) {
                      user.username = value;
                    },
                    decoration: const InputDecoration(
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
                    ),
                    style: const TextStyle(
                      decoration: null,
                      color: primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: distanceSmall),
                  const Text(
                    "Geschlecht",
                    style: TextStyle(
                      color: labelColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: distanceTiny,
                  ),
                  InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary)),
                      contentPadding: EdgeInsets.only(
                          left: distanceSmall, right: distanceTiny),
                      hoverColor: primary,
                      fillColor: disabled,
                      filled: true,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        style: const TextStyle(color: primary),
                        value: user.gender,
                        items: const [
                          DropdownMenuItem(
                            value: Gender.male,
                            child: Text("Männlich"),
                          ),
                          DropdownMenuItem(
                            value: Gender.female,
                            child: Text("Weiblich"),
                          ),
                          DropdownMenuItem(
                            value: Gender.divers,
                            child: Text("Divers"),
                          ),
                          DropdownMenuItem(
                            value: Gender.na,
                            child: Text("Nicht angegeben"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            user.gender = value ?? Gender.na;
                          });
                        },
                      ),
                    ),
                  ),
                  Flexible(child: Container()),
                  isCreating
                      ? Container()
                      : Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(borderRadiusMedium),
                            ),
                            color: tertiaryBackground,
                          ),
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
                  const SizedBox(height: distanceMedium),
                  Center(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileEntry extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry margin;

  const ProfileEntry(
      {super.key, required this.title, this.margin = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: paddingTiny),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: disabled,
                borderRadius: BorderRadius.circular(borderRadiusSmall)),
            child: const Padding(
              padding: EdgeInsets.all(paddingSmall),
              child: TextField(
                decoration: null,
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
