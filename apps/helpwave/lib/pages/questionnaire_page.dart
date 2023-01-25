import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave/components/question_answer_column.dart';
import 'package:helpwave/pages/emergency_room_overview_page.dart';

/// Page for displaying Questions in case of an emergency
///
/// Used make the best possible advice for a emergency room
///
/// See [QuestionAnswerColumn] for actual implementation
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
          Text(AppLocalizations.of(context)!.loadEmergencyWard),
        ],
      ),
    );

    Widget questionAnswer = Padding(
      padding: const EdgeInsets.all(columnPadding),
      child: QuestionAnswerColumn(
        // TODO replace with current Question from Tree and a handler
        // TODO and load correct emergency rooms
        answers: [AppLocalizations.of(context)!.yes, AppLocalizations.of(context)!.no],
        question: "Ist das eine Frage?",
        helpText: "Dies ist ein überaus hilfreicher Text, der zu beantwortung der Frage helfen könnte.",
        answerHandler: (index, answer) {
          if (answer == AppLocalizations.of(context)!.yes) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EmergencyRoomOverviewPage(),
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
                  builder: (_) => const EmergencyRoomOverviewPage(),
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
