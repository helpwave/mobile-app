import 'package:flutter/cupertino.dart';

class PressableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final void Function() onPressed;
  final double? width;
  final double? height;

  const PressableText({
    super.key,
    required this.text,
    this.style,
    required this.onPressed,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightForFinite(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
        ),
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}
