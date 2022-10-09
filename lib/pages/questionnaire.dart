import 'package:flutter/material.dart';
import 'package:helpwave/components/question_answer_column.dart';
import 'package:helpwave/pages/emergency_room_overview.dart';
import 'package:helpwave/styling/constants.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<StatefulWidget> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  bool isLoadingEmergencyRooms = false;

  @override
  Widget build(BuildContext context) {
    const double loadingCircleSize = iconSizeBig;
    const double spinnerTextDistance = distanceDefault;
    const double columnPadding = paddingMedium;

    Widget loading = Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: spinnerTextDistance),
            width: loadingCircleSize,
            height: loadingCircleSize,
            child: const CircularProgressIndicator(),
          ),
          const Text("Lade Notaufnahmen"),
        ],
      ),
    );

    Widget questionAnswer = Padding(
      padding: const EdgeInsets.all(columnPadding),
      child: QuestionAnswerColumn(
        // TODO replace with current Question from Tree and a handler
        // TODO and load correct emergency rooms
        answers: const ["Ja", "Nein"],
        question: "Ist das eine Frage?",
        answerHandler: (index, answer) {
          if (answer == "Ja") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EmergencyRoomOverview(),
              ),
            );
          } else {
            setState(() {
              isLoadingEmergencyRooms = true;
            });
            Future.delayed(
              const Duration(seconds: 2),
              () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EmergencyRoomOverview(),
                ),
              ),
            );
          }
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("helpwave"),
      ),
      body: isLoadingEmergencyRooms ? loading : questionAnswer,
    );
  }
}
