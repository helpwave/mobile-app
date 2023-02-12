import 'package:flutter/material.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';
import 'package:tasks/pages/organization_picker_dart.dart';

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
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    const padding = distanceDefault;
    double rowWidth = MediaQuery.of(context).size.width - 2 * padding;
    ButtonStyle loginButtonStyle = ButtonStyle(
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
              // TODO do use email password here for login

              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const OrganizationPickerPage()));
            }
          },
          child: Text(
            context.localization!.login,
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
                decoration: const InputDecoration(),
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
        ),
      ),
    );
  }
}
