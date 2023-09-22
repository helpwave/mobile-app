import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/theming/colors.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadiusBig)),
      child: Padding(
        padding: const EdgeInsets.only(
            top: paddingMedium,
            left: paddingSmall,
            right: paddingSmall,
            bottom: paddingMedium),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(primary),
                  shape: MaterialStatePropertyAll(
                    CircleBorder(),
                  ),
                ),
              ),
            ),
            Text(
              "Profil",
              style: TextStyle(
                  color: primary, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            ProfileEntry(title: "Dein Name"),
            ProfileEntry(title: "XXX"),
            ProfileEntry(title: "XXX")
          ],
        ),
      ),
    );
  }
}

class ProfileEntry extends StatelessWidget {
  final String title;

  const ProfileEntry({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 8, top: 8),
      child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: paddingTiny),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: labelColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(child: Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: TextField(decoration: null, style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 16),),
            ), decoration: BoxDecoration(color: disabled, borderRadius:  BorderRadius.circular(borderRadiusSmall)) ,)
          ],
        ),

    );
  }
}
