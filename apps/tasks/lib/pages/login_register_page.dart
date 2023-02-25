import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:helpwave_localization/localization.dart';
import 'package:helpwave_theme/constants.dart';



class LoginRegisterPage extends StatelessWidget {
  const LoginRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialStateProperty<Size?>? buttonSize =
        const MaterialStatePropertyAll(Size(buttonWidth, buttonHeight));

    // TODO: replace with final color
    ButtonStyle loginButtonStyle = ButtonStyle(
      minimumSize: buttonSize,
      backgroundColor: const MaterialStatePropertyAll(Colors.deepPurple),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
                style: loginButtonStyle,
                child: Text(
                  context.localization!.login,
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () {}),
            const SizedBox(height: distanceDefault),
            const SizedBox(height: distanceSmall),
            OutlinedButton(
                style: buttonStyle,
                child: Text(
                  context.localization!.register,
                ),
                onPressed: () {}),
            const SizedBox(height: distanceDefault),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      ((MediaQuery.of(context).size.width + paddingMedium) -
                              buttonWidth) /
                          2),
              // workaround for dynamic underlining in different languages
              child: Html(
                data: context.localization!.termsOfUseInfoLogin,
              )
            )
          ],
        ),
      ),
    );
  }
}
