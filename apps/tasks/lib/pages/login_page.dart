import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:helpwave_widget/text_input.dart';

/// Page for logging in an existing user
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    const padding = distanceDefault;
    double rowWidth = MediaQuery.of(context).size.width - 2 * padding;
    ButtonStyle loginButtonStyle = ButtonStyle(
      side: MaterialStateProperty.all(const BorderSide(style: BorderStyle.solid)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      minimumSize: MaterialStatePropertyAll(Size(rowWidth, 50)),
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.localization!.login)),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: padding),
        child: TextButton(
          style: loginButtonStyle,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // TODO do use email password here

              // TODO onSuccess push to app home-screen
            }
          },
          child: Text(
            context.localization!.login,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(padding),
              child: Column(
                children: [
                  const SizedBox(height: distanceSmall),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: context.localization!.email
                    ),
                    onSaved: (value) => _email = value!,
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return context.localization!.emailNotValid;
                      }
                      if (!RegExp(r"^[a-zA-Z0-9a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
                        return context.localization!.emailNotValid;
                      }
                      return null;
                      },
                  ),
                  const SizedBox(height: distanceDefault),
                  const SizedBox(height: distanceSmall),
                  PasswordTextEditingField(
                    hintText: context.localization!.password,
                    onChanged: (value) => _password,
                    onSaved: (value) => _password = value!,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return context.localization!.noPassword;
                      }
                      return null;
                      },
                  ),
                ],
              ),
            )
        ),
      )
    );
  }
}
