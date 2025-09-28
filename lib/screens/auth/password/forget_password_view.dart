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
  final TextEditingController _editingControllerMobile = TextEditingController();
  final TextEditingController _editingControllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: _authController.loadingResetPassword.value,
        progressIndicator: SpinKitCubeGrid(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 
                       MediaQuery.of(context).padding.top,
                child: Column(
                  children: [
                    // Modern Header Section
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Back button
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                                onPressed: () => Get.back(),
                              ),
                            ),
                          ),
                          // Title and subtitle
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.lock_reset,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    'Enter your details to receive OTP via email',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form Section
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Mobile Number Input
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: rPrimaryTextField(
                                controller: _editingControllerMobile,
                                keyboardType: TextInputType.number,
                                borderColor: Colors.transparent,
                                hintText: 'Enter your mobile number',
                                maxLength: 11,
                                prefixIcon: Container(
                                  margin: EdgeInsets.all(12),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.mobile_friendly,
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  ),
                                ),
                                prefixText: '+88',
                              ),
                            ),

                            SizedBox(height: 20),

                            // Email Input
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: rPrimaryTextField(
                                controller: _editingControllerEmail,
                                keyboardType: TextInputType.emailAddress,
                                borderColor: Colors.transparent,
                                hintText: 'Enter your email address',
                                prefixIcon: Container(
                                  margin: EdgeInsets.all(12),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 32),

                            // Submit Button
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).primaryColor.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  String mobileNumber = _editingControllerMobile.text.trim();
                                  String email = _editingControllerEmail.text.trim();

                                  if (mobileNumber.isNotEmpty && email.isNotEmpty) {
                                    if (mobileNumber.length == 11 && mobileNumber.startsWith('01')) {
                                      bool result = await _authController.tryToGeneratePasswordResetOTP(
                                          mobile: '+88$mobileNumber', email: email);
                                      if (result) {
                                        Get.offAll(() => SubmitResetPasswordOtpView());
                                      }
                                    } else {
                                      Get.snackbar(
                                        'Invalid Mobile Number',
                                        "Please enter a valid 11-digit mobile number starting with 01",
                                        backgroundColor: Colors.red[400],
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM,
                                        borderRadius: 12,
                                        margin: EdgeInsets.all(16),
                                        icon: Icon(Icons.error_outline, color: Colors.white),
                                      );
                                    }
                                  } else {
                                    Get.snackbar(
                                      'Missing Information',
                                      "Please fill in both mobile number and email",
                                      backgroundColor: Colors.orange[400],
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                      borderRadius: 12,
                                      margin: EdgeInsets.all(16),
                                      icon: Icon(Icons.warning_amber_outlined, color: Colors.white),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.send_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Send OTP',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 24),

                            // Help text
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.blue[100]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.blue[600],
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'We\'ll send a verification code to your email address',
                                      style: TextStyle(
                                        color: Colors.blue[700],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
