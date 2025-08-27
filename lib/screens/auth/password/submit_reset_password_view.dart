import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/screens/auth/password/forget_password_view.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class SubmitResetPasswordOtpView extends GetView {
  SubmitResetPasswordOtpView({super.key});
  final AuthController _authController = Get.find();
  final TextEditingController _editingControllerMobile =
      TextEditingController();
  final TextEditingController _editingControllerPassword =
      TextEditingController();

  String _OTPCode = '';

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: _authController.loadingResetPassword.value,
        //opacity: 0.8,
        progressIndicator: const SpinKitCubeGrid(
          color: Colors.white,
          size: 50.0,
        ),
        child: Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 288,
                      height: 279,
                      decoration: const BoxDecoration(
                        // image: DecorationImage(
                        //   image: AssetImage(
                        //     'assets/logos/ellipse.png',
                        //   ),
                        //   fit: BoxFit.fill,
                        // ),
                        color: Colors.purple,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(100.0),
                        ),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            "Password reset OTP has been sent to your email. Please check there.",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: rPrimaryTextField(
                      controller: _editingControllerMobile,
                      keyboardType: TextInputType.phone,
                      borderColor: Colors.black,
                      hintText: 'Account Mobile number',
                      maxLength: 11,
                      prefixIcon: Icon(Icons.mobile_friendly),
                      prefixText: '+88',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: rPrimaryTextField(
                      controller: _editingControllerPassword,
                      keyboardType: TextInputType.visiblePassword,
                      borderColor: Colors.black,
                      obscureText: true,
                      hintText: 'New Password',
                      prefixIcon: const Icon(Icons.key),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Enter 6 digits OTP',
                    style: TextStyle(
                        color: Color(0xFF464646),
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.center,
                    fieldWidth: 40,
                    fieldStyle: FieldStyle.box,
                    spaceBetween: 8.0,
                    outlineBorderRadius: 8,
                    style: const TextStyle(fontSize: 17),
                    onChanged: (pin) {
                      _OTPCode = pin;
                    },
                    onCompleted: (pin) {
                      _OTPCode = pin;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't get the OTP?",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () => Get.off(() => ForgetPasswordView()),
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                              color: Color(0xFFFF4AC2),
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  rPrimaryElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      String mobileNumber =
                          _editingControllerMobile.text.trim();
                      String password = _editingControllerPassword.text.trim();

                      if (_OTPCode.length < 6) {
                        Get.snackbar(
                          'Failed',
                          "Please specify accurate 6 digits OTP code.",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

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

                      if (password.isEmpty || password.length < 8) {
                        Get.snackbar(
                          'Failed',
                          "Password must be at least 8 characters long.",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      _authController.tryToResetPasswordWithOTP(
                          mobile: '+88$mobileNumber',
                          password: password,
                          otp: _OTPCode);
                    },
                    primaryColor: Theme.of(context).primaryColor,
                    buttonText: 'Submit',
                    buttonTextColor: Colors.white,
                    fontSize: 16.0,
                    fixedSize: Size(MediaQuery.of(context).size.width - 96, 46),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
