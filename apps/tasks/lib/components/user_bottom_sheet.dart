import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';


class UserBottomSheet extends StatelessWidget {
  const UserBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final double height  = MediaQuery.of(context).size.height;

    return BottomSheet(
      animationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 500),
      ),
      elevation: 10,
      onClosing: () {},
      enableDrag: true,
      builder: (BuildContext ctx) => SizedBox(
          height: height * 0.40,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(paddingMedium),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ),
              ),

              Positioned(
                top: 0,
                right: 0,
                child: Padding(padding: const EdgeInsets.all(paddingMedium),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black, backgroundColor: Colors.transparent,
                        ),
                        onPressed: () {  },
                        child: const Text( "Log out", style: TextStyle(color: Colors.black),))
                ),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: const EdgeInsets.all(paddingSmall),
                      child: CircleAvatar(child: Container(
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
                      ),),),
                    const Text("Max Mustermann"),
                    const Text("Uniklikum Münster (UKM)", style: TextStyle(color: Colors.grey))
                  ],
                ),
              )


            ],
          )
      ),
    );
  }
}
