import 'package:flutter/material.dart';

class QuestionAnswerColumn extends StatelessWidget {
  final Function(String, int) answerHandler;
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
    List<Widget> children = [
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 250,
          margin: EdgeInsets.fromLTRB(
              0, mediaQuery.height * 0.05, 0, mediaQuery.height * 0.12),
          child: Text(
            question,
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    ];

    answers.asMap().forEach((index, answer) => {
          children.add(Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: OutlinedButton(
              onPressed: () => answerHandler(answer, index),
              child: Text(answer),
            ),
          ))
        });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
