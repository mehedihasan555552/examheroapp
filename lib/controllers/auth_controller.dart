import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/config/api_endpoints.dart';
import 'package:mission_dmc/models/profile_model.dart';
import 'package:mission_dmc/screens/home_screen.dart';
import 'package:mission_dmc/screens/auth/welcome_screen.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class AuthController extends GetxController {
  final authLoading = false.obs;
  final loadingChangePassword = false.obs;
  final loadingResetPassword = false.obs;
  final profile = Profile().obs;
  final token = ''.obs;

  late StreamingSharedPreferences preferences;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize() async {
    preferences = await StreamingSharedPreferences.instance;
    preferences.getString('token', defaultValue: '').listen((value) {
      token.value = value;
    });
    preferences.getString('profile', defaultValue: '').listen((value) {
      if (value.isNotEmpty) {
        profile.value = Profile.fromJson(jsonDecode(value));
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // ever(token, _setInitialScreen);
  }

  @override
  void onClose() {
    super.onClose();
  }

  var isContentLoading = false.obs;
  final isbookloading = false.obs;
  final bookMarksList = {}.obs;
  var contentList = <dynamic>[].obs;
  
  Future<void> menuDataList() async {
    isContentLoading.value = true;
    print('Fetching app content...');
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        'https://admin.examhero.xyz/api/v1/mcq-preparation/app-content/',
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );

      isContentLoading.value = false;
      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        contentList.value = response.data;
        print("Content List Updated: ${contentList}");
      } else {
        print("Failed to fetch data with status code: ${response.statusCode}");
      }
    } catch (e) {
      isContentLoading.value = false;
      print("Error occurred: $e");
      Get.snackbar(
        'Failed',
        "Something went wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void tryToSignIn({required String mobile, required String password}) async {
    authLoading.value = true;
    var data = {
      'phone': mobile,
      'password': password,
    };
    var dio = Dio();
    try {
      final response = await dio.post(
        kLoginUrl,
        data: data,
      );
      int? statusCode = response.statusCode;
      print("Login Response Status Code: ${statusCode}");

      authLoading.value = false;
      if (statusCode == 200) {
        token.value = response.data['token'];
        profile.value = Profile.fromJson(response.data['profile']);
        print("Profile loaded: ${profile.value.referral_code}");
        preferences.setString('token', response.data['token']);
        preferences.setString('profile', jsonEncode(response.data['profile']));

        Get.snackbar(
          'Success',
          "You are logged in successfully.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(HomeScreen.id);
      } else {
        Get.snackbar(
          'Failed',
          "Invalid credentials. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      authLoading.value = false;
      print("Login Error: ${e}");
      
      // Handle specific error cases
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          Get.snackbar(
            'Failed',
            "Invalid mobile number or password.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else if (e.response?.statusCode == 401) {
          Get.snackbar(
            'Failed',
            "Unauthorized access. Please check your credentials.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Failed',
            "Network error. Please check your internet connection.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Failed',
          "Something went wrong. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  final topBannerList = [].obs;
  
  Future<void> fetchTopBannerList() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kBannerList,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        print(response.data);
        topBannerList.addAll(response.data);
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Failed',
        "Failed to load banners. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Enhanced tryToSignUp method with improved error handling and debugging
  void tryToSignUp({
    required String fullName,
    required String mobileNumber,
    required String email,
    required String institute,
    required String studentClass,
    required String department,
    required String password,
  }) async {
    authLoading.value = true;
    
    // Prepare data matching your Django API expectations
    var data = {
      'full_name': fullName,
      'email': email,
      'mobile_number': mobileNumber,
      'institute': institute,
      'password': password,
      'class': studentClass,        // Send as 'class' to match your API
      'department': department,
    };
    
    print("=== REGISTRATION API REQUEST ===");
    print("URL: $kRegisterWithProfileUrl");
    print("Data being sent: ${jsonEncode(data)}");
    
    var dio = Dio();
    
    // Add request/response interceptor for better debugging
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("REQUEST[${options.method}] => PATH: ${options.path}");
        print("REQUEST DATA: ${options.data}");
        handler.next(options);
      },
      onResponse: (response, handler) {
        print("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
        handler.next(response);
      },
      onError: (error, handler) {
        print("ERROR[${error.response?.statusCode}] => MESSAGE: ${error.message}");
        print("ERROR DATA: ${error.response?.data}");
        handler.next(error);
      },
    ));
    
    try {
      final response = await dio.post(
        kRegisterWithProfileUrl,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',  // More specific accept header
          },
          validateStatus: (status) {
            // Allow all status codes to be handled manually
            return status != null && status < 500;
          },
        ),
      );

      authLoading.value = false;
      int? statusCode = response.statusCode;
      
      print("=== REGISTRATION RESPONSE ===");
      print("Status Code: $statusCode");
      print("Response Data: ${response.data}");
      
      if (statusCode == 201) {
        // Successful registration
        if (response.data['token'] != null && response.data['profile'] != null) {
          token.value = response.data['token'];
          profile.value = Profile.fromJson(response.data['profile']);
          
          // Save to preferences
          await preferences.setString('token', response.data['token']);
          await preferences.setString('profile', jsonEncode(response.data['profile']));

          Get.snackbar(
            'Success',
            "Account created successfully! Welcome to ExamHero.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );

          Get.offAllNamed(HomeScreen.id);
        } else {
          throw Exception("Invalid response format: missing token or profile");
        }
      } else if (statusCode == 400) {
        // Validation errors
        String errorMessage = "Please check all required fields and try again.";
        
        if (response.data != null) {
          if (response.data['error'] != null) {
            errorMessage = response.data['error'].toString();
          } else if (response.data.containsKey('phone')) {
            errorMessage = "This mobile number is already registered.";
          } else if (response.data.containsKey('email')) {
            errorMessage = "This email address is already registered.";
          }
        }
        
        Get.snackbar(
          'Registration Failed',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      } else {
        // Other error status codes
        String errorMessage = "Registration failed. Please try again.";
        
        if (response.data != null && response.data['error'] != null) {
          errorMessage = response.data['error'].toString();
        }
        
        Get.snackbar(
          'Registration Failed',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print("=== REGISTRATION ERROR ===");
      print("Error Type: ${e.runtimeType}");
      print("Error Details: $e");
      
      authLoading.value = false;
      String errorMessage = "Something went wrong. Please try again.";
      
      if (e is DioException) {
        print("DioException Details:");
        print("- Status Code: ${e.response?.statusCode}");
        print("- Response Data: ${e.response?.data}");
        print("- Message: ${e.message}");
        
        switch (e.response?.statusCode) {
          case 400:
            if (e.response?.data != null) {
              if (e.response!.data['error'] != null) {
                errorMessage = e.response!.data['error'].toString();
              } else if (e.response!.data.toString().contains('phone')) {
                errorMessage = "This mobile number is already registered.";
              } else if (e.response!.data.toString().contains('email')) {
                errorMessage = "This email address is already registered.";
              } else {
                errorMessage = "Please check all required fields and try again.";
              }
            }
            break;
          case 409:
            errorMessage = "Account with this information already exists.";
            break;
          case 500:
            errorMessage = "Server error. Please try again later.";
            break;
          case null:
            errorMessage = "Network error. Please check your internet connection.";
            break;
          default:
            errorMessage = "Registration failed. Please try again.";
        }
      } else if (e.toString().contains('SocketException')) {
        errorMessage = "No internet connection. Please check your network.";
      }
      
      Get.snackbar(
        'Registration Failed',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }
  }

  void tryToSignOut() async {
    authLoading.value = true;

    var dio = Dio();
    try {
      final response = await dio.post(
        kLogoutUrl,
        options: Options(
          headers: {
            'accept': '*/*',
            'Authorization': 'Token ${token.value}',
          },
        ),
      );
      int? statusCode = response.statusCode;
      authLoading.value = false;

      if (statusCode == 201) {
        preferences.clear();
        Get.offAllNamed(WelcomeScreen.id);
        token.value = '';
        
        Get.snackbar(
          'Success',
          "You have been logged out successfully.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Failed',
          "Logout failed. Please check your internet connection.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      authLoading.value = false;
      Get.snackbar(
        'Logged Out',
        "You have been logged out.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      preferences.clear();
      Get.offAllNamed(WelcomeScreen.id);
      token.value = '';
    }
  }

  void sendOtpRequest(String mobileNumber) {
    // Implementation for OTP request if needed
  }

  Future<bool> tryToChangePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    loadingChangePassword.value = true;
    final AuthController authController = Get.find();
    var dio = Dio();
    var data = {
      'old_password': oldPassword,
      'new_password': newPassword,
    };
    try {
      final response = await dio.put(
        kChangePasswordUpdateUrl,
        data: data,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      loadingChangePassword.value = false;
      if (statusCode == 200) {
        Get.snackbar(
          'Success',
          "Your password has been changed successfully.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else if (statusCode == 203) {
        Get.snackbar(
          'Failed',
          "Current password is incorrect.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Failed',
          "Password change failed. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      loadingChangePassword.value = false;
      Get.snackbar(
        'Failed',
        "Network error. Please check your connection.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return false;
  }

  Future<bool> tryToGeneratePasswordResetOTP({
    required String mobile,
    required String email,
  }) async {
    loadingResetPassword.value = true;
    var dio = Dio();
    var data = {
      'mobile': mobile,
      'email': email,
    };
    try {
      final response = await dio.post(
        kPasswordResetOtpGenerateCreateUrl,
        data: data,
        options: Options(headers: {
          'accept': '*/*',
        }),
      );
      int? statusCode = response.statusCode;
      loadingResetPassword.value = false;
      if (statusCode == 201) {
        Get.snackbar(
          'Success',
          "Password reset OTP has been sent to your email. Please check your inbox.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 6),
        );
        return true;
      } else {
        Get.snackbar(
          'Failed',
          "Mobile number or email not found in our records.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      loadingResetPassword.value = false;
      Get.snackbar(
        'Failed',
        "Failed to send OTP. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return false;
  }

  Future<bool> tryToResetPasswordWithOTP({
    required String mobile,
    required String password,
    required String otp,
  }) async {
    loadingResetPassword.value = true;
    var dio = Dio();
    var data = {
      'mobile': mobile,
      'password': password,
      'otp': otp,
    };
    try {
      final response = await dio.put(
        kResetPasswordWithOtpUpdateUrl,
        data: data,
        options: Options(headers: {
          'accept': '*/*',
        }),
      );
      int? statusCode = response.statusCode;
      loadingResetPassword.value = false;
      if (statusCode == 200) {
        Get.snackbar(
          'Success',
          "Password reset successful! You can now login with your new password.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 6),
        );
        Get.offAllNamed(WelcomeScreen.id);
        return true;
      } else {
        Get.snackbar(
          'Failed',
          "Invalid OTP or expired. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      loadingResetPassword.value = false;
      Get.snackbar(
        'Failed',
        "Password reset failed. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return false;
  }
}
