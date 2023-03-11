import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave/components/question_answer_column.dart';
import 'package:helpwave/screens/emergency_room_overview_screen.dart';

/// Screen for displaying Questions in case of an emergency
///
/// Used make the best possible advice for a emergency room
///
/// See [QuestionAnswerColumn] for actual implementation
class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<StatefulWidget> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
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
          Text(context.localization!.loadEmergencyWard),
        ],
      ),
    );

    Widget questionAnswer = Padding(
      padding: const EdgeInsets.all(columnPadding),
      child: QuestionAnswerColumn(
        // TODO replace with current Question from Tree and a handler
        // TODO and load correct emergency rooms
        answers: [context.localization!.yes, context.localization!.no],
        question: "Ist das eine Frage?",
        helpText: "Dies ist ein überaus hilfreicher Text, der zu beantwortung der Frage helfen könnte.",
        answerHandler: (index, answer) {
          if (answer == context.localization!.yes) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EmergencyRoomOverviewScreen(),
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
                  builder: (_) => const EmergencyRoomOverviewScreen(),
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