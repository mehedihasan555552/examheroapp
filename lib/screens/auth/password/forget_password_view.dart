import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/screens/auth/password/submit_reset_password_view.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class ForgetPasswordView extends StatelessWidget {
  ForgetPasswordView({super.key});
  final AuthController _authController = Get.find();
  final TextEditingController _editingControllerMobile =
      TextEditingController();
  final TextEditingController _editingControllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: _authController.loadingResetPassword.value,
        //opacity: 0.8,
        progressIndicator: SpinKitCubeGrid(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        child: Scaffold(
          // backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text('Get OTP in Email'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: rPrimaryTextField(
                  controller: _editingControllerMobile,
                  keyboardType: TextInputType.number,
                  borderColor: Colors.black,
                  hintText: 'Your account mobile number',
                  maxLength: 11,
                  prefixIcon: Icon(Icons.mobile_friendly),
                  prefixText: '+88',
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: rPrimaryTextField(
                  controller: _editingControllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  borderColor: Colors.black,
                  hintText: 'Your account email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              rPrimaryElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  String mobileNumber = _editingControllerMobile.text.trim();
                  String email = _editingControllerEmail.text.trim();

                  if (mobileNumber.isNotEmpty && email.isNotEmpty) {
                    if (mobileNumber.length == 11 &&
                        mobileNumber.startsWith('01')) {
                      bool result =
                          await _authController.tryToGeneratePasswordResetOTP(
                              mobile: '+88$mobileNumber', email: email);
                      if (result) {
                        Get.offAll(() => SubmitResetPasswordOtpView());
                      }
                    } else {
                      Get.snackbar(
                        'Failed',
                        "Please specify accurate 11 digits mobile number.",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
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
                primaryColor: Theme.of(context).primaryColor,
                buttonText: 'Submit',
                buttonTextColor: Colors.white,
                fontSize: 16.0,
                fixedSize: Size(MediaQuery.of(context).size.width - 32, 46),
              ),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
