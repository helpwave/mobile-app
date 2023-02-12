import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:tasks/pages/home_page.dart';
import 'package:tasks/pages/login_page.dart';
import 'package:tasks/config/config.dart';

/// Page for registering a new user
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _passwordRepeatKey = GlobalKey<FormFieldState>();
  String _email = "";
  String _password = "";
  String _passwordRepeat = "";
  bool _isPasswordVisible = false;
  bool _isPasswordRepeatVisible = false;

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
        _passwordKey.currentState!.validate();
      }
    });
    _passwordRepeatFocusNode.addListener(() {
      if (!_passwordRepeatFocusNode.hasFocus) {
        _hasEditedPasswordRepeatOnce = true;
        _passwordRepeatKey.currentState!.validate();
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
      appBar: AppBar(title: Text(context.localization!.register)),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: padding),
        child: TextButton(
          style: registerButtonStyle,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // TODO do use email password here

              // TODO onSuccess push to app home-screen
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
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
                  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
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
              TextFormField(
                key: _passwordKey,
                focusNode: _passwordFocusNode,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    }),
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                onSaved: (value) => _password = value!,
                onChanged: (value) {
                  _password = value;
                  if (_hasEditedPasswordOnce) {
                    _passwordKey.currentState!.validate();
                    // case where the use wants to change the original password to match the repeated one
                    String? passwordRepeatValue = _passwordRepeatKey.currentState!.value as String?;
                    if (passwordRepeatValue != null && passwordRepeatValue.isNotEmpty) {
                      _passwordRepeatKey.currentState!.validate();
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
              TextFormField(
                key: _passwordRepeatKey,
                focusNode: _passwordRepeatFocusNode,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: !_isPasswordRepeatVisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      _isPasswordRepeatVisible = !_isPasswordRepeatVisible;
                    }),
                    icon: Icon(_isPasswordRepeatVisible ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                onSaved: (value) => _passwordRepeat = value!,
                onChanged: (value) {
                  _passwordRepeat = value;
                  if (_hasEditedPasswordRepeatOnce) {
                    _passwordKey.currentState!.validate();
                    _passwordRepeatKey.currentState!.validate();
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
                style: const ButtonStyle(minimumSize: MaterialStatePropertyAll(Size.zero)),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginPage())),
                child: Text(context.localization!.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
