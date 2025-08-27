import 'package:flutter/material.dart';
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/screens/auth/login_screen.dart';
import 'package:mission_dmc/screens/auth/registration_screen.dart';

import '../../widgets/rounded_button.dart';

class WelcomeScreen extends StatelessWidget {
  static const id = "welcome_screen";
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/shape/main_top.png",
                width: size.width * 0.3,
                color: kPrimaryColorLight,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(
                "assets/shape/main_bottom.png",
                width: size.width * 0.3,
                color: kPrimaryColorLight,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome To ExamHero.!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/welcome.png",
                  width: size.width * 0.7,
                ),
                const SizedBox(
                  height: 30,
                ),
                RoundedButton(
                  textColor: Colors.white,
                  text: "Login Now",
                  pressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  textColor: Colors.white,
                  text: "Registration Now",
                  pressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
