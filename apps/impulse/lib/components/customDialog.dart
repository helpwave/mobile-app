import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/theming/colors.dart';

class ProfileForm extends StatefulWidget {
  final String title;
  final String text;

  const ProfileForm({super.key, required this.title, required this.text});

  @override
  State<StatefulWidget> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  @override
  void initState() {
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
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(primary),
                        ),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          widget.title,
                          style: const TextStyle(
                              color: primary,
                              fontSize: fontSizeBig,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(paddingBig),
                    child: Center(child: Text(widget.text)),
                  ),
                  Flexible(child: Container()),
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
                        "OK",
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
