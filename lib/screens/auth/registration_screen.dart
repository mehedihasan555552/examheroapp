import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import '../../config/constants.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/textFieldContainer.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);
  static const id = 'reg_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with TickerProviderStateMixin {
  final AuthController _authController = Get.find();
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _editingControllerMobileNumber = TextEditingController();
  final TextEditingController _editingControllerFullName = TextEditingController();
  final TextEditingController _editingControllerInstitute = TextEditingController();
  final TextEditingController _editingControllerEmailAddress = TextEditingController();
  final TextEditingController _editingControllerPassword = TextEditingController();

  // Reactive variables
  RxBool _isPasswordObscured = true.obs;
  RxString selectedClass = ''.obs;
  RxString selectedDepartment = ''.obs;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Dropdown options matching your Django model
  final List<Map<String, String>> classOptions = [
    {'value': '', 'label': 'Select Class'},
    {'value': 'ssc', 'label': 'এসএসসি (SSC)'},
    {'value': 'hsc', 'label': 'এইচএসসি (HSC)'},
  ];

  final List<Map<String, String>> departmentOptions = [
    {'value': '', 'label': 'Select Department'},
    {'value': 'science', 'label': 'বিজ্ঞান (Science)'},
    {'value': 'arts', 'label': 'মানবিক (Arts)'},
    {'value': 'commerce', 'label': 'বাণিজ্য (Commerce)'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _editingControllerMobileNumber.dispose();
    _editingControllerFullName.dispose();
    _editingControllerInstitute.dispose();
    _editingControllerEmailAddress.dispose();
    _editingControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Obx(() {
      return LoadingOverlay(
        isLoading: _authController.authLoading.value,
        progressIndicator: SpinKitPulse(
          color: kPrimaryColor,
          size: 50.0,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            height: size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kPrimaryColor.withOpacity(0.8),
                  kPrimaryColor,
                  kPrimaryColor.withOpacity(0.9),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Header Section
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/main_logo.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Join ExamHero Today!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Form Container
                        SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Full Name Field
                                _buildTextField(
                                  controller: _editingControllerFullName,
                                  hint: "Enter Your Full Name",
                                  icon: Icons.person_rounded,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Full name is required';
                                    }
                                    if (value.length < 2) {
                                      return 'Name must be at least 2 characters';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Mobile Number Field
                                _buildTextField(
                                  controller: _editingControllerMobileNumber,
                                  hint: "Enter Mobile Number",
                                  icon: Icons.phone_android_rounded,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(11),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Mobile number is required';
                                    }
                                    if (value.length != 11) {
                                      return 'Mobile number must be exactly 11 digits';
                                    }
                                    if (!value.startsWith('01')) {
                                      return 'Mobile number must start with 01';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Email Field
                                _buildTextField(
                                  controller: _editingControllerEmailAddress,
                                  hint: "Enter Email Address",
                                  icon: Icons.email_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is required';
                                    }
                                    if (!GetUtils.isEmail(value)) {
                                      return 'Enter valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Institute Field
                                _buildTextField(
                                  controller: _editingControllerInstitute,
                                  hint: "Enter Institute/College Name",
                                  icon: Icons.school_rounded,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Institute name is required';
                                    }
                                    if (value.length < 3) {
                                      return 'Institute name must be at least 3 characters';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Student Class Dropdown
                                Obx(() => _buildDropdownField(
                                  label: 'Student Class',
                                  value: selectedClass.value,
                                  items: classOptions,
                                  icon: Icons.class_rounded,
                                  onChanged: (String? newValue) {
                                    print('Selected Class: $newValue');
                                    selectedClass.value = newValue ?? '';
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select student class';
                                    }
                                    return null;
                                  },
                                )),
                                
                                const SizedBox(height: 20),
                                
                                // Department Dropdown
                                Obx(() => _buildDropdownField(
                                  label: 'Department',
                                  value: selectedDepartment.value,
                                  items: departmentOptions,
                                  icon: Icons.category_rounded,
                                  onChanged: (String? newValue) {
                                    print('Selected Department: $newValue');
                                    selectedDepartment.value = newValue ?? '';
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select department';
                                    }
                                    return null;
                                  },
                                )),
                                
                                const SizedBox(height: 20),
                                
                                // Password Field
                                Obx(() => _buildTextField(
                                  controller: _editingControllerPassword,
                                  hint: "Enter Password",
                                  icon: Icons.lock_rounded,
                                  obscureText: _isPasswordObscured.value,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _isPasswordObscured.value = !_isPasswordObscured.value;
                                    },
                                    child: Icon(
                                      _isPasswordObscured.value
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    }
                                    if (value.length < 3) {
                                      return 'Password must be at least 3 characters';
                                    }
                                    return null;
                                  },
                                )),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Register Button
                        ScaleTransition(
                          scale: _fadeAnimation,
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.95),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: MaterialButton(
                              onPressed: _handleRegistration,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Login Link
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<Map<String, String>> items,
    required IconData icon,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        hint: Text(
          'Select $label',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16,
          ),
        ),
        dropdownColor: kPrimaryColor.withOpacity(0.9),
        iconEnabledColor: Colors.white.withOpacity(0.8),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        items: items.skip(1).map((Map<String, String> item) { // Skip the first "Select" option
          return DropdownMenuItem<String>(
            value: item['value'],
            child: Text(
              item['label']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _handleRegistration() {
    print('=== REGISTRATION ATTEMPT STARTED ===');
    
    // Print form validation status
    print('Form is valid: ${_formKey.currentState?.validate()}');
    
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      
      // Extract and validate data
      String mobileNumber = _editingControllerMobileNumber.text.trim();
      String password = _editingControllerPassword.text.trim();
      String fullName = _editingControllerFullName.text.trim();
      String emailAddress = _editingControllerEmailAddress.text.trim();
      String institute = _editingControllerInstitute.text.trim();
      String studentClass = selectedClass.value;
      String department = selectedDepartment.value;
      
      // Print all form data
      print('=== FORM DATA ===');
      print('Full Name: "$fullName"');
      print('Mobile Number (raw): "$mobileNumber"');
      print('Email: "$emailAddress"');
      print('Institute: "$institute"');
      print('Student Class: "$studentClass"');
      print('Department: "$department"');
      print('Password Length: ${password.length}');
      
      // Validate required fields
      if (fullName.isEmpty) {
        print('ERROR: Full name is empty');
        _showError('Full name is required');
        return;
      }
      
      if (mobileNumber.isEmpty) {
        print('ERROR: Mobile number is empty');
        _showError('Mobile number is required');
        return;
      }
      
      if (emailAddress.isEmpty) {
        print('ERROR: Email is empty');
        _showError('Email address is required');
        return;
      }
      
      if (institute.isEmpty) {
        print('ERROR: Institute is empty');
        _showError('Institute name is required');
        return;
      }
      
      if (studentClass.isEmpty) {
        print('ERROR: Student class not selected');
        _showError('Please select student class');
        return;
      }
      
      if (department.isEmpty) {
        print('ERROR: Department not selected');
        _showError('Please select department');
        return;
      }
      
      if (password.isEmpty) {
        print('ERROR: Password is empty');
        _showError('Password is required');
        return;
      }
      
      // Add the +88 prefix to mobile number
      String fullMobileNumber = '+88$mobileNumber';
      print('Mobile Number (with prefix): "$fullMobileNumber"');
      
      // Prepare final data object
      Map<String, dynamic> finalData = {
        'full_name': fullName,
        'mobile_number': fullMobileNumber,
        'email': emailAddress,
        'institute': institute,
        'class': studentClass,
        'department': department,
        'password': password,
      };
      
      print('=== FINAL API DATA ===');
      finalData.forEach((key, value) {
        print('$key: "$value"');
      });
      
      print('=== CALLING AUTH CONTROLLER ===');
      
      // Call the registration method
      try {
        _authController.tryToSignUp(
          fullName: fullName,
          mobileNumber: fullMobileNumber,
          email: emailAddress,
          institute: institute,
          studentClass: studentClass,
          department: department,
          password: password,
        );
        print('Registration method called successfully');
      } catch (e) {
        print('ERROR calling registration method: $e');
        _showError('Registration failed: $e');
      }
    } else {
      print('=== FORM VALIDATION FAILED ===');
      _showError('Please fill all required fields correctly');
    }
  }
  
  void _showError(String message) {
    Get.snackbar(
      'Registration Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }
}
