import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';

/// A [BottomSheet] for showing the [User]s information
class UserBottomSheet extends StatefulWidget {
  const UserBottomSheet({super.key});

  @override
  State<UserBottomSheet> createState() => _UserBottomSheetState();
}

class _UserBottomSheetState extends State<UserBottomSheet> {
  final items = ["station 1"];
  String? selectedStation;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Consumer<ThemeModel>(
      builder: (BuildContext context, ThemeModel themeNotifier, __) {
        return BottomSheet(
          animationController: AnimationController(
            vsync: Navigator.of(context),
            duration: const Duration(milliseconds: 500),
          ),
          elevation: 10,
          onClosing: () {},
          enableDrag: true,
          builder: (BuildContext ctx) => Container(
              color: const Color(0x70f2f2f2),
              height: height * 0.40,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(paddingMedium),
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.all(paddingMedium),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(borderRadiusMedium),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                context.localization!.logout,
                                style: TextStyle(
                                    color: themeNotifier.getIsDarkNullSafe(context) ? Colors.white : Colors.black),
                              ))),
                    ],
                  ),
                  Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(paddingSmall),
                        child: CircleAvatar(
                          child: Container(
                              decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment(0.8, 1),
                              colors: <Color>[
                                Color(0xff1f005c),
                                Color(0xff5b0060),
                                Color(0xff870160),
                                Color(0xffac255e),
                                Color(0xffca485c),
                                Color(0xffe16b5c),
                                Color(0xfff39060),
                                Color(0xffffb56b),
                              ],
                              tileMode: TileMode.mirror,
                            ),
                          )),
                        ),
                      ),
                      const Text(
                        "Max Mustermann",
                        style: TextStyle(fontSize: fontSizeBig),
                      ),
                      const Text("Uniklikum Münster (UKM)",
                          style: TextStyle(fontSize: fontSizeSmall, color: Colors.grey)),
                      Padding(
                          padding: const EdgeInsets.all(paddingBig),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(borderRadiusMedium),
                              color: Colors.white,
                            ),
                            width: width * 0.7,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: selectedStation,
                                  isExpanded: true,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStation = value.toString();
                                    });
                                  },
                                  items: items.map((String value) {
                                    return DropdownMenuItem(
                                        value: value,
                                        child: Row(
                                          children: [
                                            Text(
                                              context.localization!.station,
                                              style: const TextStyle(color: Colors.grey),
                                            ),
                                            Expanded(
                                                child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                value,
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ))
                                          ],
                                        ));
                                  }).toList(),
                                ),
                              ),
                            ),
                          ))
                    ],
                  )),
                ],
              )),
        );
      },
    );
  }
}
