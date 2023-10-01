
import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_theme/theme.dart';
import 'package:provider/provider.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (BuildContext context, ThemeModel themeNotifier, _) => Padding(padding: const EdgeInsets.only(top: paddingBig, bottom: paddingMedium),
        child: ExpansionTile(
          shape: const Border(),
          iconColor: Colors.grey,
          textColor: themeNotifier.getIsDarkNullSafe(context)? Colors.white : Colors.black,
          title: const Text("Max Mustermann"),
          subtitle: const Row(
              children: [
                Text("Uniklinikum Münster (UKM) - ", style: TextStyle(color: Colors.grey)),
                Text("Station 1", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
          ),
          leading: CircleAvatar(child: Container(
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
              )
          ),),
          children: const [

          ],)
    ));
  }

}
