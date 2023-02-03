import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';

class MarkDownRenderer extends StatefulWidget {
  final void Function(String value)? callback;
  final String markdownString;

  const MarkDownRenderer({super.key, this.callback, required this.markdownString});

  @override
  State<StatefulWidget> createState() => _MarkDownRendererState();
}

class _MarkDownRendererState extends State<MarkDownRenderer> {
  List<String> stringLines = [];

  TextSpan inlineTranslateMarkdown(String inlineString, TextStyle textStyle) {
    Map<String, TextStyle> markdownIdentifier = {
      "**": textStyle.copyWith(fontWeight: FontWeight.bold),
      "_": textStyle.copyWith(fontStyle: FontStyle.italic),
      "~~": textStyle.copyWith(decoration: TextDecoration.lineThrough),
    };
    String firstSign = "";
    int firstStartIndex = inlineString.length;
    int firstEndIndex = -1;
    String firstAfterOpened = "";
    for (String sign in markdownIdentifier.keys) {
      int startIndex = inlineString.length;
      startIndex = inlineString.startsWith(sign) ? 0 : inlineString.indexOf(" $sign");
      if (startIndex == -1) {
        continue;
      }
      String afterOpened = inlineString.substring(startIndex + sign.length + (inlineString.startsWith(sign) ? 0 : 1));
      int endIndex = afterOpened.indexOf("$sign ");
      if (endIndex == -1 && inlineString.endsWith(sign)) {
        endIndex = afterOpened.length - sign.length;
      }
      if (endIndex == -1) {
        continue;
      }
      if (startIndex < firstStartIndex) {
        firstSign = sign;
        firstStartIndex = startIndex;
        firstEndIndex = endIndex;
        firstAfterOpened = afterOpened;
      }
    }

    if (firstSign != "") {
      List<TextSpan> children = [];
      // Split the String in part before, middle, and after (only middle is affected)
      children.add(
        inlineTranslateMarkdown(
          inlineString.substring(0, firstStartIndex),
          textStyle,
        ),
      );
      children.add(inlineTranslateMarkdown(
        firstAfterOpened.substring(0, firstEndIndex),
        markdownIdentifier[firstSign]!,
      ));
      if (firstEndIndex != firstAfterOpened.length - 1) {
        children.add(
          inlineTranslateMarkdown(
            firstAfterOpened.substring(firstEndIndex + firstSign.length, firstAfterOpened.length),
            textStyle,
          ),
        );
      }
      return TextSpan(children: children);
    }

    return TextSpan(
      text: inlineString,
      style: textStyle,
    );
  }

  List<Widget> translateMarkdown(TextStyle textStyle) {
    stringLines = widget.markdownString.split("\n");
    List<Widget> widgets = [];
    for (int i = 0; i < stringLines.length; i++) {
      String line = stringLines[i];
      if (line.startsWith("- [ ] ") || line.startsWith("- [x] ")) {
        bool isChecked = line[3] == "x";
        widgets.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: iconSizeTiny,
                width: iconSizeTiny,
                child: Checkbox(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: isChecked,
                  onChanged: (value) => setState(() {
                    stringLines[i] = value! ? line.replaceRange(3, 4, "x") : line.replaceRange(3, 4, " ");
                    if (widget.callback != null) {
                      widget.callback!(stringLines.join("\n"));
                    }
                  }),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: RichText(text: inlineTranslateMarkdown(line.substring(5), textStyle)),
                ),
              ),
            ],
          ),
        );
      } else if (line.startsWith("* ") || line.startsWith("- ")) {
        bool hasBulletBefore = i > 0 &&
            (stringLines[i - 1].startsWith("* ") ||
                (stringLines[i - 1].startsWith("- ") &&
                    !stringLines[i - 1].startsWith("- [ ] ") &&
                    !stringLines[i - 1].startsWith("- [x] ")));
        widgets.add(
          Padding(
            padding: EdgeInsets.only(top: hasBulletBefore ? 0 : distanceSmall, bottom: distanceSmall),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("•", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Flexible(child: RichText(text: inlineTranslateMarkdown(line.substring(2), textStyle))),
            ]),
          ),
        );
        // After a "#" there needs to be a whitespace at least at the 7th character
      } else if (line.startsWith("#") && line.substring(0, line.length < 7 ? line.length : 7).contains(" ")) {
        int hashTagCount = 1;
        for (int i = 1; i < line.length && i < 6; i++) {
          if (line[i] == "#") {
            hashTagCount++;
          } else {
            break;
          }
        }
        widgets.add(
          RichText(
            text: inlineTranslateMarkdown(
              line.substring(hashTagCount + 1 < line.length ? hashTagCount + 1 : hashTagCount),
              textStyle.copyWith(fontSize: textStyle.fontSize! + (7 - hashTagCount) * 2),
            ),
          ),
        );
      } else {
        widgets.add(RichText(text: inlineTranslateMarkdown(line, textStyle)));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: translateMarkdown(
        Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
      ),
    );
  }
}
