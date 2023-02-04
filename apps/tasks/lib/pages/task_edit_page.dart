import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:tasks/components/markdown_renderer.dart';

/// Page for Editing or Creating a [Task]
///
/// Code Example:
/// ```dart
/// TaskEditPage(
///   patientId: "734fd141-fd1889ab-1452",
///   roomName: "Room 24 E1",
///   task: {
///     "content": "- [ ] Example Checkbox",
///     "title": "Test Title",
///   },
/// ),
/// ```
class TaskEditPage extends StatefulWidget {
  /// The ID of the [Patient] the Task refers to
  final String? patientId;

  /// The name of the room the [Patient] or [Task] is located in
  final String? roomName;

  // TODO replace later with [Task] data type
  /// The [Task] that contains the content and title of the [Task]
  ///
  /// Here it is used to edit a existing [Task] or to be used as an Template which can be used to create a new Task
  final Map<String, String>? task;

  const TaskEditPage({
    super.key,
    this.patientId,
    this.roomName,
    this.task,
  });

  @override
  State<StatefulWidget> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  final TextEditingController _contentTextEditingController = TextEditingController();
  final TextEditingController _titleTextEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String content = "";
  String title = "Title";
  bool isMarkdownView = false;
  bool isEditingTitle = false;

  @override
  void initState() {
    if (widget.task != null) {
      content = widget.task!["content"]!;
      title = widget.task!["title"]!;
    }
    _titleTextEditingController.text = title;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        stopEditingTitle();
      }
    });
    super.initState();
  }

  stopEditingTitle() {
    setState(() {
      title = _titleTextEditingController.text;
      isEditingTitle = false;
    });
  }

  startEditingTitle() {
    setState(() {
      isEditingTitle = true;
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    const double padding = distanceDefault;
    const double outlineWidth = 3;
    const Color activeBorder = Color.fromARGB(255, 50, 50, 255);
    const Color inactiveBorder = Color.fromARGB(255, 0, 0, 90);
    bool hasTopCard = widget.patientId != null || widget.roomName != null;
    Size buttonSize = Size(MediaQuery.of(context).size.width * 0.5 - padding, 50);
    return Scaffold(
      appBar: AppBar(title: const Text("Task Editor")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(borderRadiusBig),
                    bottomLeft: Radius.circular(borderRadiusBig),
                  ),
                  side: BorderSide(width: outlineWidth, color: isMarkdownView ? activeBorder : inactiveBorder),
                ),
              ),
              minimumSize: MaterialStatePropertyAll(buttonSize),
            ),
            onPressed: () => setState(() {
              isMarkdownView = true;
            }),
            child: Text(context.localization!.markdown),
          ),
          TextButton(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(borderRadiusBig),
                    bottomRight: Radius.circular(borderRadiusBig),
                  ),
                  side: BorderSide(width: outlineWidth, color: isMarkdownView ? inactiveBorder : activeBorder),
                ),
              ),
              minimumSize: MaterialStatePropertyAll(buttonSize),
            ),
            onPressed: () => setState(() {
              isMarkdownView = false;
            }),
            child: Text(context.localization!.text),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(padding),
        child: Column(
          children: [
            hasTopCard
                ? Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(paddingSmall))),
                    child: Padding(
                      padding: const EdgeInsets.all(paddingSmall),
                      child: Column(
                        children: [
                          widget.roomName != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${context.localization!.room}:"),
                                    Text(widget.roomName!),
                                  ],
                                )
                              : const SizedBox(),
                          SizedBox(height: widget.patientId != null && widget.roomName != null ? distanceSmall : 0),
                          widget.patientId != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${context.localization!.patientID}:"),
                                    Text(widget.patientId!),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            SizedBox(height: hasTopCard ? distanceMedium : 0),
            isEditingTitle
                ? TextFormField(
                    focusNode: _focusNode,
                    controller: _titleTextEditingController,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      enabledBorder: const UnderlineInputBorder(),
                      focusedBorder: const UnderlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: stopEditingTitle,
                        icon: const Icon(Icons.check, color: positiveColor),
                      ),
                    ),
                  )
                : ListTile(
                    contentPadding: const EdgeInsets.only(left: paddingSmall),
                    horizontalTitleGap: distanceSmall,
                    title: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    onTap: startEditingTitle,
                    trailing: IconButton(
                      onPressed: startEditingTitle,
                      icon: const Icon(
                        Icons.edit,
                        size: iconSizeTiny,
                      ),
                    ),
                  ),
            const SizedBox(height: distanceSmall),
            isMarkdownView
                ? MarkdownTextInput(
                    (value) => setState(() => content = value),
                    content,
                    actions: const [
                      MarkdownType.list,
                      MarkdownType.bold,
                      MarkdownType.title,
                      MarkdownType.italic,
                      MarkdownType.link,
                      MarkdownType.strikethrough,
                    ],
                    controller: _contentTextEditingController,
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width - 2 * padding,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: MarkDownRenderer(
                      markdownString: content,
                      callback: (value) => setState(() {
                        _contentTextEditingController.text = value;
                        content = value;
                      }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
