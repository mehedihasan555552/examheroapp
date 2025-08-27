import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/screens/home_screen.dart';

import '../../config/constants.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});
  static const id = 'reg_screen';
  final AuthController _authController = Get.find();

  final TextEditingController _editingControllerMobileNumber = TextEditingController();
  final TextEditingController _editingControllerFullName = TextEditingController();
  final TextEditingController _editingControllerInstitute = TextEditingController();
  final TextEditingController _editingControllerHSCExamYear = TextEditingController();
  final TextEditingController _editingControllerEmailAddress = TextEditingController();
  final TextEditingController _editingControllerPassword = TextEditingController();
  
  final RxBool _isPasswordObscured = true.obs;
  final RxString _selectedClass = 'hsc'.obs;
  final RxString _selectedDepartment = 'science'.obs;

  // Dropdown options
  final List<String> _classOptions = ['ssc', 'hsc'];
  final List<String> _departmentOptions = ['science', 'arts', 'commerce'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(() {
      return LoadingOverlay(
        isLoading: _authController.authLoading.value,
        progressIndicator: SpinKitCubeGrid(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background decorations
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/shape/main_top.png",
                      width: size.width * 0.3,
                      color: kPrimaryColorLight,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(width: size.width * 0.3, height: 100);
                      },
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Image.asset(
                      "assets/shape/main_bottom.png",
                      width: size.width * 0.3,
                      color: kPrimaryColorLight,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox(width: size.width * 0.3, height: 100);
                      },
                    ),
                  ),
                  
                  // Main content
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.08),
                        
                        // Header
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Join us today and start your journey',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        // Logo
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "assets/main_logo.png",
                            width: size.width * 0.3,
                            height: size.width * 0.2,
                            color: kPrimaryColor,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: size.width * 0.3,
                                height: size.width * 0.2,
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported, size: 40),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        
                        // Form fields
                        _buildModernTextField(
                          controller: _editingControllerFullName,
                          hintText: "Enter Your Full Name",
                          icon: Icons.person_outline,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 16),
                        
                        _buildModernTextField(
                          controller: _editingControllerMobileNumber,
                          hintText: "Enter 11-digit Phone Number",
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        _buildModernTextField(
                          controller: _editingControllerEmailAddress,
                          hintText: "Enter Your Email Address",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16),
                        
                        _buildModernTextField(
                          controller: _editingControllerInstitute,
                          hintText: "Enter Your College/School Name",
                          icon: Icons.school_outlined,
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 16),
                        
                        _buildModernTextField(
                          controller: _editingControllerHSCExamYear,
                          hintText: "HSC Exam Year (e.g., 2024)",
                          icon: Icons.calendar_today_outlined,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        // Class Dropdown
                        _buildModernDropdown(
                          value: _selectedClass,
                          options: _classOptions,
                          hintText: "Select Class",
                          icon: Icons.class_outlined,
                        ),
                        SizedBox(height: 16),
                        
                        // Department Dropdown
                        _buildModernDropdown(
                          value: _selectedDepartment,
                          options: _departmentOptions,
                          hintText: "Select Department",
                          icon: Icons.category_outlined,
                        ),
                        SizedBox(height: 16),
                        
                        // Password Field
                        Obx(() => _buildModernTextField(
                          controller: _editingControllerPassword,
                          hintText: "Enter Your Password",
                          icon: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _isPasswordObscured.value,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _isPasswordObscured.value = !_isPasswordObscured.value;
                            },
                            child: Icon(
                              _isPasswordObscured.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey[600],
                              size: 22,
                            ),
                          ),
                        )),
                        SizedBox(height: 30),
                        
                        // Register Button
                        _buildModernButton(context, size),
                        SizedBox(height: 20),
                        
                        // Login Link
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                color: Colors.grey[600], 
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
          prefixIcon: Container(
            padding: EdgeInsets.all(12),
            child: Icon(
              icon,
              color: kPrimaryColor,
              size: 24,
            ),
          ),
          suffixIcon: suffixIcon != null ? Container(
            padding: EdgeInsets.all(12),
            child: suffixIcon,
          ) : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildModernDropdown({
    required RxString value,
    required List<String> options,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: kPrimaryColor,
              size: 24,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Obx(() => DropdownButtonFormField<String>(
                initialValue: value.value,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 15,
                  ),
                ),
                dropdownColor: Colors.white,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey[600],
                  size: 24,
                ),
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    value.value = newValue;
                  }
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernButton(BuildContext context, Size size) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            kPrimaryColor,
            kPrimaryColor.withOpacity(0.8),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (!_authController.authLoading.value) {
              _handleRegistration(context);
            }
          },
          child: Center(
            child: _authController.authLoading.value
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _handleRegistration(BuildContext context) {
    FocusScope.of(context).unfocus();
    
    // Get values
    String mobileNumber = _editingControllerMobileNumber.text.trim();
    String password = _editingControllerPassword.text.trim();
    String fullName = _editingControllerFullName.text.trim();
    String emailAddress = _editingControllerEmailAddress.text.trim();
    String institute = _editingControllerInstitute.text.trim();
    String hscExamYear = _editingControllerHSCExamYear.text.trim();
    String selectedClass = _selectedClass.value;
    String selectedDepartment = _selectedDepartment.value;

    print("🔍 Registration attempt:");
    print("👤 Full Name: '$fullName'");
    print("📱 Mobile: '$mobileNumber'");
    print("📧 Email: '$emailAddress'");
    print("🏫 Institute: '$institute'");
    print("📅 HSC Year: '$hscExamYear'");
    print("📚 Class: '$selectedClass'");
    print("🎯 Department: '$selectedDepartment'");
    print("🔒 Password length: ${password.length}");

    // Validation
    if (mobileNumber.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty ||
        emailAddress.isEmpty ||
        institute.isEmpty ||
        hscExamYear.isEmpty) {
      Get.snackbar(
        'Validation Error',
        "Please fill in all required fields.",
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.error_outline, color: Colors.white),
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
      return;
    }

    // Mobile number validation
    if (mobileNumber.length != 11 || !mobileNumber.startsWith('01')) {
      Get.snackbar(
        'Invalid Phone Number',
        "Please enter a valid 11-digit mobile number starting with 01.",
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.phone_disabled, color: Colors.white),
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
      return;
    }

    // Password validation
    if (password.length < 4) {
      Get.snackbar(
        'Weak Password',
        "Password must be at least 4 characters long.",
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.lock_open, color: Colors.white),
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
      return;
    }

    // Email validation
    if (!GetUtils.isEmail(emailAddress)) {
      Get.snackbar(
        'Invalid Email',
        "Please enter a valid email address.",
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.email_outlined, color: Colors.white),
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
      return;
    }

    // HSC Year validation
    int? hscYear = int.tryParse(hscExamYear);
    if (hscYear == null || hscYear < 2000 || hscYear > DateTime.now().year + 5) {
      Get.snackbar(
        'Invalid Year',
        "Please enter a valid HSC exam year (2000-${DateTime.now().year + 5}).",
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.calendar_today, color: Colors.white),
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
      return;
    }

    // Format mobile number
    String formattedMobile = '+88$mobileNumber';
    print("📞 Formatted mobile: '$formattedMobile'");

    // Call registration function
    _authController.tryToSignUp(
      fullName: fullName,
      mobileNumber: formattedMobile,
      email: emailAddress,
      institute: institute,
      hscExamYear: hscYear,
      password: password,
      studentClass: selectedClass,
      department: selectedDepartment,
    );
  }
}
