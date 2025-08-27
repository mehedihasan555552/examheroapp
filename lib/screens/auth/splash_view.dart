import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/screens/auth/welcome_screen.dart';
import 'package:mission_dmc/screens/home_screen.dart';

class SplashView extends StatelessWidget {
  static const id = "splash_view";

  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      AuthController authController;
      try {
        authController = Get.find();
      } catch (e) {
        authController = Get.put(AuthController());
      }

      if (authController.token.value.isNotEmpty) {
        Get.offNamed(HomeScreen.id);
      } else {
        Get.offNamed(WelcomeScreen.id);
      }
    });
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,



        decoration: const BoxDecoration(

          image: DecorationImage(
            image: AssetImage("assets/splash.jpeg"), // Your top background image
            fit: BoxFit.fill,

          ),
        ),

        child:
        SpinKitCubeGrid(
          color: Colors.white,
          size: 50.0,
        ),
      )


      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: const [
      //     Center(
      //       child: Text(
      //         'prepMED',
      //         style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //             fontWeight: FontWeight.w700),
      //       ),
      //     ),
      //     SizedBox(
      //       height: 32,
      //     ),
      //
      //   ],
      // ),
    );
  }
}
