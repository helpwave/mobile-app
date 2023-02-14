import 'package:flutter/material.dart';

/// A Widget for Inputting passwords
class PasswordTextEditingField extends StatefulWidget {
  /// Controller for the password field
  final ObscuringTextEditingController? controller;

  /// The initial value of the visibility. Should the password be visible in the beginning?
  final bool isInitiallyVisible;

  /// The Value for indicating whether the flutter default obscuring should be used
  ///
  /// true: show the last letter on mobile devices, none on all other devices
  ///
  /// false: never show any letter when obscuring
  final bool isUsingNativeObscure;

  /// The [Icon] shown when password is visible
  final Icon visibleIcon;

  /// The [Icon] shown when password is invisible
  final Icon obscureIcon;

  /// A Function to construct the [InputDecoration] of the [TextFormField]
  ///
  /// You have to use the Function **changeVisibility** somewhere to be able to toggle visibility
  final InputDecoration Function(BuildContext context, void Function() changeVisibility)? inputDecorationConstructor;

  /// The [onChanged] function of the [TextFormField]
  final void Function(String value)? onChanged;

  /// The [onSaved] function of the [TextFormField]
  final void Function(String? value)? onSaved;

  /// The [validator] function of the [TextFormField]
  final String? Function(String? value)? validator;

  /// The [FocusNode] of the [TextFormField]
  final FocusNode? focusNode;

  /// The Key of the [TextFormField]
  final Key? textEditingFieldKey;

  const PasswordTextEditingField({
    super.key,
    this.textEditingFieldKey,
    this.controller,
    this.isInitiallyVisible = false,
    this.visibleIcon = const Icon(Icons.visibility_rounded),
    this.obscureIcon = const Icon(Icons.visibility_off_rounded),
    this.inputDecorationConstructor,
    this.isUsingNativeObscure = false,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.focusNode,
  });

  @override
  State<StatefulWidget> createState() => _PasswordTextEditingFieldState();
}

class _PasswordTextEditingFieldState extends State<PasswordTextEditingField> {
  bool _isPasswordObscured = true;
  late ObscuringTextEditingController _controller;

  @override
  void initState() {
    _controller = widget.controller ?? ObscuringTextEditingController();
    _isPasswordObscured = !widget.isInitiallyVisible;
    _controller.isObscuring = widget.isUsingNativeObscure ? false : _isPasswordObscured;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  changeVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
      if (!widget.isUsingNativeObscure) {
        _controller.isObscuring = _isPasswordObscured;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.textEditingFieldKey,
      focusNode: widget.focusNode,
      controller: _controller,
      enableSuggestions: false,
      autocorrect: false,
      obscureText: widget.isUsingNativeObscure ? _isPasswordObscured : false,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: changeVisibility,
          icon: _isPasswordObscured ? widget.obscureIcon : widget.visibleIcon,
        ),
      ),
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      validator: widget.validator,
    );
  }
}

/// Obscures the Text it controls with given [obscureSymbol]
///
/// Acts as a normal [TextEditingController] when [isObscuring] is set to false
class ObscuringTextEditingController extends TextEditingController {
  final String obscureSymbol;
  bool isObscuring = true;

  ObscuringTextEditingController({
    this.obscureSymbol = '•',
    String? text,
  }) : super(text: text);

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    if (isObscuring) {
      return TextSpan(text: '•' * value.text.length, style: style);
    }
    return super.buildTextSpan(context: context, withComposing: withComposing, style: style);
  }
}
