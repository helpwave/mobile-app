
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:impulse/theming/colors.dart';

class NumberInput extends StatefulWidget{
  const NumberInput({super.key, required this.value, required this.onChanged, this.minValue = 0, this.maxValue = 100});

  final void Function(int) onChanged;
  final int minValue;
  final int maxValue;
  final int value;


  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  TextEditingController? controller;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    counter = widget.value;
    controller = TextEditingController(text: widget.value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width * 0.2;

    return Row(
      children: [
        CupertinoButton(
          onPressed: () => {
            counter -= 1,
            if (counter > widget.minValue) {
              setState(() {
                controller?.text = counter.toString();
              }),
              widget.onChanged(widget.value - 1)
            }
          },
          child: const Icon(CupertinoIcons.minus_circle_fill, size: iconSizeSmall,),
        ),
        SizedBox(
          width: screenWidth,
          child: TextField(
            textAlign: TextAlign.center,
            enabled: false,
            controller: controller,
            style: const TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 32),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: paddingSmall, vertical: paddingTiny),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: primary,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ),
        CupertinoButton(
          onPressed: () => {
            if (counter < widget.maxValue) {
              counter += 1,
              setState(() {
                controller?.text = counter.toString();
              }),
              widget.onChanged(widget.value + 1)
            }
          },
          child: const Icon(CupertinoIcons.plus_circle_fill, size: iconSizeSmall,),
        ),
      ],
    );
  }
}
