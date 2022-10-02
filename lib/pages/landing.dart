import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/banner.png',
          width: mediaQuery.width * 0.9,
          height: mediaQuery.height * 0.3,
        ),
      ),
    );
  }
}
