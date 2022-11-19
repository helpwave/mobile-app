import 'package:flutter/material.dart';

import '../styling/constants.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> message;

  const ChatMessage({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    const smallCorner = Radius.circular(borderRadiusTiny);
    const bigCorner = Radius.circular(borderRadiusBig);

    Size mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          paddingSmall, paddingSmall / 2, paddingSmall, paddingSmall / 2),
      child: Align(
        alignment: message["isFromEmergencyRoom"]
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: mediaQuery.width * 0.8,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: bigCorner,
                topLeft: bigCorner,
                bottomLeft:
                    message["isFromEmergencyRoom"] ? smallCorner : bigCorner,
                bottomRight:
                    message["isFromEmergencyRoom"] ? bigCorner : smallCorner,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(paddingSmall),
              child: Text(message["message"]),
            ),
          ),
        ),
      ),
    );
  }
}
