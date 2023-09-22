
import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';


class ActivityCard extends StatelessWidget{

  const ActivityCard({super.key, required this.activityName, required this.activityDescription, required this.xp});

  final String activityName;
  final String activityDescription;
  final String xp;


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width * 0.9;

    return Card(
      child: SizedBox(
        width: screenWidth,
        child:  IntrinsicHeight(
          child: Row(
            children: [
              Padding(padding: const EdgeInsets.all(paddingSmall),
                child: IconButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(negativeColor),
                    ),
                    onPressed: () => {

                    }, icon: const Icon(Icons.play_arrow, color: Colors.white,)),),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(paddingSmall),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(paddingTiny),
                            child: Text(xp, style: const TextStyle(color: Colors.white),),
                          )
                        ),
                        Text(activityName,
                          style: const TextStyle(fontSize: fontSizeBig, fontWeight: FontWeight.bold, color: negativeColor),),
                        Text(activityDescription,
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                      ],
                    ),
                  )
              ),
            ],),
        ),
      )
    );
  }
}
