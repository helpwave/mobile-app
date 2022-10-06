import 'package:flutter/material.dart';

class QuestionAnswerColumn extends StatelessWidget {
  final Function(int, String) answerHandler;
  final String question;
  final List<String> answers;

  const QuestionAnswerColumn({
    super.key,
    required this.answerHandler,
    required this.question,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    const double topDistance = 0.05;
    const double bottomDistance = 0.12;
    const double questionWidth = 250;
    const double buttonTopDistance = 20;

    List<Widget> children = [
      Container(
        height: mediaQuery.height * topDistance,
      ),
      Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: questionWidth,
          child: Text(
            question,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
      Container(
        height: mediaQuery.height * bottomDistance,
      ),
    ];

    answers.asMap().forEach(
          (index, answer) => children.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(0, buttonTopDistance, 0, 0),
              child: OutlinedButton(
                onPressed: () => answerHandler(index, answer),
                child: Text(answer),
              ),
            ),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
