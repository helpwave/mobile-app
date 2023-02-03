import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:tasks/components/markdown_renderer.dart';

class TaskEditPage extends StatefulWidget {
  const TaskEditPage({super.key});

  @override
  State<StatefulWidget> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  String description = "- [ ] gfdghbf";
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const double padding = distanceDefault;
    return Scaffold(
      appBar: AppBar(title: const Text("Task Editor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(padding),
        child: Column(
          children: [
            MarkdownTextInput(
              (value) => setState(() => description = value),
              description,
              actions: const [
                MarkdownType.list,
                MarkdownType.bold,
                MarkdownType.title,
                MarkdownType.italic,
                MarkdownType.link,
                MarkdownType.strikethrough
              ],
              controller: _textEditingController,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 2 * padding,
              height: MediaQuery.of(context).size.height * 0.4,
              child: MarkDownRenderer(
                markdownString: description,
                callback: (value) => setState(() {
                  _textEditingController.text = value;
                  description = value;
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
