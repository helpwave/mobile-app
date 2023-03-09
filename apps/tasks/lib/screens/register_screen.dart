import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/text_input.dart';
import 'package:tasks/components/navigation_drawer.dart';
import 'package:tasks/config/config.dart';
import 'package:tasks/screens/login_screen.dart';
import 'package:tasks/screens/organization_picker_screen.dart';

/// Screen for registering a new user
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordTextFieldKey = GlobalKey<FormFieldState>();
  final _passwordRepeatTextFieldKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<PasswordTextEditingFieldState>();
  final _passwordRepeatKey = GlobalKey<PasswordTextEditingFieldState>();
  String _email = "";
  String _password = "";
  String _passwordRepeat = "";

  // used for ux improvements
  final FocusNode _emailFocusNode = FocusNode();
  bool _hasEditedEmailOnce = false;
  final FocusNode _passwordFocusNode = FocusNode();
  bool _hasEditedPasswordOnce = false;
  final FocusNode _passwordRepeatFocusNode = FocusNode();
  bool _hasEditedPasswordRepeatOnce = false;

  @override
  void initState() {
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _hasEditedEmailOnce = true;
        _emailKey.currentState!.validate();
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        _hasEditedPasswordOnce = true;
        _passwordTextFieldKey.currentState!.validate();
      }
    });
    _passwordRepeatFocusNode.addListener(() {
      if (!_passwordRepeatFocusNode.hasFocus) {
        _hasEditedPasswordRepeatOnce = true;
        _passwordRepeatTextFieldKey.currentState!.validate();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const padding = distanceDefault;
    double rowWidth = MediaQuery.of(context).size.width - 2 * padding;
    ButtonStyle registerButtonStyle = ButtonStyle(
      minimumSize: MaterialStatePropertyAll(Size(rowWidth, 50)),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const NavigationDrawer(currentPage: NavigationOptions.myTasks),
      appBar: AppBar(title: Text(context.localization!.register)),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: padding),
        child: TextButton(
          style: registerButtonStyle,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // TODO do use email password here for registration

              // TODO onSuccess push to app home-screen
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => const OrganizationPickerScreen()));
            }
          },
          child: Text(
            context.localization!.register,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(padding),
          child: Column(
            children: [
              SizedBox(
                width: rowWidth,
                child: Text(
                  context.localization!.email,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: distanceSmall),
              TextFormField(
                key: _emailKey,
                focusNode: _emailFocusNode,
                decoration: const InputDecoration(),
                onChanged: (_) {
                  if (_hasEditedEmailOnce) {
                    _emailKey.currentState!.validate();
                  }
                },
                onSaved: (value) => _email = value!,
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return context.localization!.emailNotValid;
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email)) {
                    return context.localization!.emailNotValid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: distanceDefault),
              SizedBox(
                width: rowWidth,
                child: Text(
                  context.localization!.password,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: distanceSmall),
              PasswordTextEditingField(
                key: _passwordKey,
                textEditingFieldKey: _passwordTextFieldKey,
                focusNode: _passwordFocusNode,
                onVisibilityChanged: (isObscured) =>
                    _passwordRepeatKey.currentState?.changeVisibility(),
                onSaved: (value) => _password = value!,
                onChanged: (value) {
                  _password = value;
                  if (_hasEditedPasswordOnce) {
                    _passwordTextFieldKey.currentState!.validate();
                    // case where the use wants to change the original password to match the repeated one
                    String? passwordRepeatValue = _passwordRepeatTextFieldKey
                        .currentState!.value as String?;
                    if (passwordRepeatValue != null &&
                        passwordRepeatValue.isNotEmpty) {
                      _passwordRepeatTextFieldKey.currentState!.validate();
                    }
                  }
                },
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return context.localization!.noPassword;
                  }
                  if (password.length < minimumPasswordCharacters) {
                    return context.localization!.passwordLengthError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: distanceSmall),
              PasswordTextEditingField(
                key: _passwordRepeatKey,
                textEditingFieldKey: _passwordRepeatTextFieldKey,
                focusNode: _passwordRepeatFocusNode,
                onVisibilityChanged: (isObscured) =>
                    _passwordKey.currentState?.changeVisibility(),
                onSaved: (value) => _passwordRepeat = value!,
                onChanged: (value) {
                  _passwordRepeat = value;
                  if (_hasEditedPasswordRepeatOnce) {
                    _passwordTextFieldKey.currentState!.validate();
                    _passwordRepeatTextFieldKey.currentState!.validate();
                  }
                },
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return context.localization!.noPassword;
                  }
                  if (_passwordRepeat != _password) {
                    return context.localization!.passwordNotEqual;
                  }
                  return null;
                },
              ),
              const SizedBox(height: distanceBig),
              Text(context.localization!.alreadyHaveAnAccount),
              const SizedBox(height: distanceSmall),
              TextButton(
                style: const ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(Size.zero)),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: Text(context.localization!.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
