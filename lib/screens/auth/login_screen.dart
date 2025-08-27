import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/screens/auth/password/forget_password_view.dart';
import 'package:mission_dmc/screens/auth/registration_screen.dart';

import '../../widgets/rounded_button.dart';
import '../../widgets/textFieldContainer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController controller = Get.find();
  final TextEditingController _editingControllerMobileNumber =
      TextEditingController();
  final TextEditingController _editingControllerPassword =
      TextEditingController();
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(() {
      return LoadingOverlay(
        isLoading: controller.authLoading.value,
        //opacity: 0.8,
        progressIndicator: SpinKitCubeGrid(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: Get.height * 0.96,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img_1.png"), // Your top background image
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start, // Adjust alignment
                    children: [
                      // Removed or reduced this SizedBox
                      SizedBox(
                        height: 10, // Adjusted height for less space
                      ),
                      Center(
                        child: Image.asset(
                          "assets/main_logo.png", // Your app logo
                          width: 300,
                          height: 250,
                        ),
                      ),
                      Center(
                        child: Text(
                          'ExamHero',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.15),
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Text("Please Enter Number ",style: TextStyle(color: Colors.black),),
                          ),// Reduced this height for less space
                          Center(
                            child: TextFieldContainer(
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: _editingControllerMobileNumber,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(11), // Restrict to 11 digits
                                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                ],
                                decoration: const InputDecoration(
                                  hintText: "Enter Your Mobile Number",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.mobile_friendly,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.01),
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Text("Please Enter Password ",style: TextStyle(color: Colors.black),),
                          ),
                          Center(
                            child: TextFieldContainer(
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: _editingControllerPassword,
                                obscureText: _isPasswordObscured,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  hintText: "Enter Your Password",
                                  hintStyle: const TextStyle(color: Colors.white),
                                  icon: const Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isPasswordObscured = !_isPasswordObscured;
                                      });
                                    },
                                    child: Icon(
                                      _isPasswordObscured
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                           SizedBox(height: Get.height * 0.0006),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 46),
                              child: InkWell(
                                onTap: () => Get.to(
                                      () => ForgetPasswordView(),
                                  fullscreenDialog: true,
                                ),
                                child: const Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                String mobileNumber =
                                _editingControllerMobileNumber.text.trim();
                                String password = _editingControllerPassword.text.trim();
                                if (mobileNumber.isNotEmpty && password.isNotEmpty) {
                                  if (mobileNumber.length < 11 ||
                                      !mobileNumber.startsWith('01')) {
                                    Get.snackbar(
                                      'Failed',
                                      "Please specify accurate 11 digits mobile number.",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                    return;
                                  }
                                  mobileNumber = '+88$mobileNumber';
                                  controller.tryToSignIn(
                                      mobile: mobileNumber, password: password);
                                } else {
                                  Get.snackbar(
                                    'Failed',
                                    "All fields are required.",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                              child: Container(
                                width: Get.width * 0.3,
                                height: Get.height *0.05,
                                decoration: const BoxDecoration(
                                  color: kPrimaryColor,

                                  image: DecorationImage(
                                    image: AssetImage("assets/field design.png"), // Your top background image
                                    fit: BoxFit.fill,

                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(29.0),
                                    topLeft: Radius.circular(29.0) ,
                                    topRight:  Radius.circular(29.0),
                                    bottomRight: Radius.circular(29.0),
                                  ),
                                ),
                                child:Center(child: Text("Login", style: TextStyle(color: Colors.white,fontSize: 18),)),

                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () => Get.to(
                                    () => RegistrationScreen(),
                                fullscreenDialog: true,
                              ),
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        ,
      );
    });
  }
}
