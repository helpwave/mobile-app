import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tasks/screens/landing_screen.dart';
import 'package:tasks/screens/main_screen.dart';
import '../controllers/user_session_controller.dart';

/// A Screen for forcing the User to login or be logged in
///
/// Automatically show the [MainScreen] when logged in and otherwise
/// the [LandingScreen]
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSessionController>(builder: (context, userSessionController, __) {
      if (userSessionController.isLoggedIn) {
        return const MainScreen();
      }
      return const LandingScreen();
    });
  }
}
