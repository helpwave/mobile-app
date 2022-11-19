import 'package:flutter/material.dart';
import 'package:helpwave/components/chat_message.dart';
import 'package:helpwave/styling/constants.dart';

class EmergencyChatPage extends StatefulWidget {
  final Map<String, dynamic> emergencyRoom;

  const EmergencyChatPage({required this.emergencyRoom, super.key});

  @override
  State<StatefulWidget> createState() => _EmergencyChatPageState();
}

class _EmergencyChatPageState extends State<EmergencyChatPage> {
  List<Map<String, dynamic>> messages = [
    {"isFromEmergencyRoom": true, "message": "How are you?"},
    {"isFromEmergencyRoom": false, "message": "Fine"},
    {"isFromEmergencyRoom": true, "message": "okay..."}
  ];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    addMessage() {
      messages.add({"isFromEmergencyRoom": false, "message": _controller.text});
      _controller.text = "";
    }

    const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadiusMedium),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: iconSizeSmall / 2,
              foregroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6"
                  "?ixlib=rb-4.0.3&"
                  "ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8"
                  "&auto=format&fit=crop&w=1085&q=80"),
            ),
            Container(
              width: distanceTiny,
            ),
            Text(
              widget.emergencyRoom["name"],
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontSize: fontSizeMedium),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children:
                      messages.map((e) => ChatMessage(message: e)).toList(),
                ),
              ),
              Container(
                width: mediaQuery.width,
                padding: const EdgeInsets.all(paddingSmall),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          focusedBorder: outlineInputBorder.copyWith(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          enabledBorder: outlineInputBorder.copyWith(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: distanceSmall,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Center(
                        child: Ink(
                          decoration: ShapeDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: const CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.send,
                              size: iconSizeSmall,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            onPressed: addMessage,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
