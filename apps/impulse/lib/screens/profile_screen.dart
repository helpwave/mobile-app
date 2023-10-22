import 'package:flutter/material.dart';
import 'package:helpwave_proto_dart/proto/services/impulse_svc/v1/impulse_svc.pbenum.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/components/background_gradient.dart';
import 'package:impulse/screens/home_screen.dart';
import 'package:impulse/services/impulse_service.dart';
import 'package:provider/provider.dart';
import '../dataclasses/user.dart';
import '../notifiers/user_model.dart';
import '../theming/colors.dart';

/// A Screen for showing the [User]'s profile and their information
class ProfileScreen extends StatefulWidget {
  /// The [User] information already there
  ///
  /// Providing no [User] means creating one on this screen
  final User? initialUser;

  const ProfileScreen({super.key, this.initialUser});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  bool isCreating = false;
  User user = User.empty();

  bool createUser = false;

  @override
  void initState() {
    isCreating = widget.initialUser == null;
    if (!isCreating) {
      user.id = widget.initialUser!.id;
      user.username = widget.initialUser!.username;
      user.gender = widget.initialUser!.gender;
      user.pal = widget.initialUser!.pal;
      user.birthday = widget.initialUser!.birthday;
      user.weight = widget.initialUser!.weight;
      user.height = widget.initialUser!.height;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController(text: user.username);
    TextEditingController heightController = TextEditingController(text: user.height.toString());
    TextEditingController weightController = TextEditingController(text: user.weight.toString());


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
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primary)),
      contentPadding: EdgeInsets.only(left: paddingSmall, right: paddingTiny, top: paddingTiny, bottom: paddingTiny),
      hoverColor: primary,
      fillColor: disabled,
      filled: true,
    );
    const BoxDecoration licenseDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadiusMedium),
      ),
      color: tertiaryBackground,
    );

    return Consumer(builder: (_, UserModel userNotifier, __) => BackgroundGradient(child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
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
                        controller: usernameController,
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
                            padding: EdgeInsets.zero,
                            isDense: true,
                            style: const TextStyle(color: primary),
                            value: user.gender,
                            items: [
                              DropdownMenuItem(
                                value: Gender.GENDER_MALE,
                                child: Text(Gender.GENDER_MALE.text),
                              ),
                              DropdownMenuItem(
                                value: Gender.GENDER_FEMALE,
                                child: Text(Gender.GENDER_FEMALE.text),
                              ),
                              DropdownMenuItem(
                                value: Gender.GENDER_DIVERSE,
                                child: Text(Gender.GENDER_DIVERSE.text),
                              ),
                              DropdownMenuItem(
                                value: Gender.GENDER_UNSPECIFIED,
                                child: Text(Gender.GENDER_UNSPECIFIED.text),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                user.gender = value ?? Gender.GENDER_UNSPECIFIED;
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
                        controller: heightController,
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
                        controller: weightController,
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
                            value: user.palDescriptor,
                            items: [
                              DropdownMenuItem(
                                value: PALDescriptor.laying,
                                child: Text(PALDescriptor.laying.text),
                              ),
                              DropdownMenuItem(
                                value: PALDescriptor.sitting,
                                child: Text(PALDescriptor.sitting.text),
                              ),
                              DropdownMenuItem(
                                value: PALDescriptor.walking,
                                child: Text(PALDescriptor.walking.text),
                              ),
                              DropdownMenuItem(
                                value: PALDescriptor.standing,
                                child: Text(PALDescriptor.standing.text),
                              ),
                              DropdownMenuItem(
                                value: PALDescriptor.active,
                                child: Text(PALDescriptor.active.text),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                user.palDescriptor = value ?? PALDescriptor.sitting;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(paddingMedium),
                  child: Container(
                    decoration: licenseDecoration,
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: paddingMedium, right: paddingSmall),
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
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return const BackgroundGradient(
                              child: LicensePage(
                                applicationName: 'helpwave impulse',
                                applicationVersion: '0.0.1',
                                applicationIcon: Icon(Icons.home),
                              ),
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
                      onPressed: () async{
                        if (isCreating) {
                          await ImpulseService().createUser(user).then((value) {
                            userNotifier.setUser(user: user);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          });
                        }
                        else {
                          await ImpulseService().updateUser(user).then((value) {
                            userNotifier.setUser(user: user);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          });
                        }
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(primary),
                        fixedSize: MaterialStatePropertyAll(
                          Size.fromWidth(215),
                        ),
                        side: MaterialStatePropertyAll(BorderSide(color: Colors.white, width: 2)),
                      ),
                      child: Text(
                        isCreating ?  "Registrieren" : "Aktualisieren" ,
                        style: const TextStyle(
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
          ),
        ),
      ),
    )));
  }
}
