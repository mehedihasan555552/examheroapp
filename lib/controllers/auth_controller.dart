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



  var isContentLoading = false.obs;

  final isbookloading = false.obs;
  final bookMarksList = {}.obs;
  var contentList = <dynamic>[].obs;
  Future<void> menuDataList() async {
    isContentLoading.value = true; // Indicate that data loading has started
    print('Fetching app content...');
    final AuthController authController = Get.find(); // Fetch the auth controller
    var dio = Dio(); // Using Dio for HTTP requests

    try {
      // Make a GET request to the specified URL
      final response = await dio.get(
        'https://examhero.xyz/api/v1/mcq-preparation/app-content/',
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );

      isContentLoading.value = false; // Indicate that data loading is done
      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        contentList.value = response.data;
        print("Content List Updated: $contentList");
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
  print("🚀 LOGIN START");
  print("📱 Mobile: $mobile");
  print("🔒 Password: ${password.isNotEmpty ? '[PROVIDED]' : '[EMPTY]'}");
  print("🌐 API URL: $kLoginUrl");

  authLoading.value = true;
  
  var data = {
    'phone': mobile,
    'password': password,
  };
  
  print("📦 Request data: $data");
  
  var dio = Dio();
  
  // Add interceptor for more detailed logging
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    requestHeader: true,
    responseHeader: true,
    error: true,
  ));
  
  try {
    print("🔄 Sending POST request...");
    
    final response = await dio.post(
      kLoginUrl,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    authLoading.value = false;
    
    print("✅ Response received!");
    print("📊 Status Code: ${response.statusCode}");
    print("📄 Response Data: ${response.data}");
    print("📋 Response Headers: ${response.headers}");
    
    if (response.statusCode == 200) {
      // Check response structure
      if (response.data == null) {
        print("❌ Response data is null");
        _showError("Server returned empty response");
        return;
      }
      
      if (response.data is! Map) {
        print("❌ Response data is not a Map: ${response.data.runtimeType}");
        _showError("Invalid response format from server");
        return;
      }
      
      Map<String, dynamic> responseMap = response.data as Map<String, dynamic>;
      print("🔍 Response Map: $responseMap");
      
      if (!responseMap.containsKey('token')) {
        print("❌ No 'token' key in response");
        print("🔑 Available keys: ${responseMap.keys.toList()}");
        _showError("Invalid response: missing token");
        return;
      }
      
      if (!responseMap.containsKey('profile')) {
        print("❌ No 'profile' key in response");
        print("🔑 Available keys: ${responseMap.keys.toList()}");
        _showError("Invalid response: missing profile");
        return;
      }
      
      try {
        token.value = responseMap['token'];
        profile.value = Profile.fromJson(responseMap['profile']);
        
        print("✅ Token saved: ${token.value}");
        print("✅ Profile saved: ${profile.value.toString()}");
        
        await preferences.setString('token', responseMap['token']);
        await preferences.setString('profile', jsonEncode(responseMap['profile']));
        
        print("💾 Data saved to preferences");
        
        Get.snackbar(
          'Success',
          "Login successful!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        
        print("🏠 Navigating to home screen...");
        Get.offAllNamed(HomeScreen.id);
        
      } catch (e) {
        print("❌ Error processing response data: $e");
        _showError("Error processing login data: $e");
      }
      
    } else {
      print("❌ Non-200 status code: ${response.statusCode}");
      _showError("Login failed. Status: ${response.statusCode}");
    }
    
  } catch (e) {
    authLoading.value = false;
    print("💥 EXCEPTION CAUGHT: $e");
    
    if (e is DioException) {
      print("🔍 DioException Details:");
      print("   Type: ${e.type}");
      print("   Message: ${e.message}");
      print("   Request URI: ${e.requestOptions.uri}");
      print("   Request Method: ${e.requestOptions.method}");
      print("   Request Data: ${e.requestOptions.data}");
      print("   Request Headers: ${e.requestOptions.headers}");
      
      if (e.response != null) {
        print("   Response Status: ${e.response!.statusCode}");
        print("   Response Data: ${e.response!.data}");
        print("   Response Headers: ${e.response!.headers}");
      }
      
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          _showError("Connection timeout. Check your internet connection.");
          break;
        case DioExceptionType.sendTimeout:
          _showError("Request timeout. Please try again.");
          break;
        case DioExceptionType.receiveTimeout:
          _showError("Server response timeout. Please try again.");
          break;
        case DioExceptionType.badResponse:
          _showError("Server error: ${e.response?.statusCode}");
          break;
        case DioExceptionType.cancel:
          _showError("Request cancelled.");
          break;
        case DioExceptionType.connectionError:
          _showError("Connection error. Check your internet connection.");
          break;
        case DioExceptionType.unknown:
          _showError("Network error: ${e.message}");
          break;
      }
    } else {
      print("   Non-Dio Exception: ${e.runtimeType}");
      _showError("Unexpected error: $e");
    }
  }
}

void _showError(String message) {
  print("🚨 Error: $message");
  Get.snackbar(
    'Error',
    message,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 4),
  );
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
        "Something is wrong. Please try again1.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }





void tryToSignUp({
  required String fullName,
  required String mobileNumber,
  required String email,
  required String institute,
  required int hscExamYear,
  required String password,
  required String studentClass,
  required String department,
}) async {
  print("🚀 REGISTRATION START");
  print("👤 Full Name: $fullName");
  print("📱 Mobile: $mobileNumber");
  print("📧 Email: $email");
  print("🏫 Institute: $institute");
  print("📅 HSC Year: $hscExamYear");
  print("🔒 Password: ${password.isNotEmpty ? '[PROVIDED]' : '[EMPTY]'}");
  print("📚 Class: $studentClass");
  print("🎯 Department: $department");
  print("🌐 API URL: $kRegisterWithProfileUrl");

  authLoading.value = true;
  
  var data = {
    'full_name': fullName,
    'email': email,
    'mobile_number': mobileNumber,
    'password': password,
    'institute': institute,
    'hsc_exam_year': hscExamYear.toString(),
    'class': studentClass,
    'department': department,
  };
  
  print("📦 Request data: $data");
  
  var dio = Dio();
  
  // Add interceptor for debugging
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    requestHeader: true,
    responseHeader: true,
    error: true,
  ));

  try {
    print("🔄 Sending POST request...");
    
    final response = await dio.post(
      kRegisterWithProfileUrl,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    authLoading.value = false;
    
    print("✅ Response received!");
    print("📊 Status Code: ${response.statusCode}");
    print("📄 Response Data: ${response.data}");
    
    if (response.statusCode == 201) {
      if (response.data != null && 
          response.data['token'] != null && 
          response.data['profile'] != null) {
        
        token.value = response.data['token'];
        profile.value = Profile.fromJson(response.data['profile']);
        
        print("✅ Token saved: ${token.value}");
        print("✅ Profile saved: ${profile.value.toString()}");
        
        await preferences.setString('token', response.data['token']);
        await preferences.setString('profile', jsonEncode(response.data['profile']));
        
        print("💾 Data saved to preferences");

        Get.snackbar(
          'Success',
          "Account created successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );

        print("🏠 Navigating to home screen...");
        Get.offAllNamed(HomeScreen.id);
        
      } else {
        print("❌ Invalid response structure: ${response.data}");
        Get.snackbar(
          'Failed',
          "Invalid response from server.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      print("❌ Non-201 status code: ${response.statusCode}");
      String errorMessage = "Registration failed.";
      
      if (response.data != null && response.data['error'] != null) {
        errorMessage = response.data['error'];
      }
      
      Get.snackbar(
        'Failed',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
      );
    }
  } catch (e) {
    authLoading.value = false;
    print("💥 EXCEPTION CAUGHT: $e");
    
    if (e is DioException) {
      print("🔍 DioException Details:");
      print("   Type: ${e.type}");
      print("   Message: ${e.message}");
      print("   Request URI: ${e.requestOptions.uri}");
      print("   Request Data: ${e.requestOptions.data}");
      
      if (e.response != null) {
        print("   Response Status: ${e.response!.statusCode}");
        print("   Response Data: ${e.response!.data}");
        
        String errorMessage = "Registration failed.";
        if (e.response!.data != null && e.response!.data['error'] != null) {
          errorMessage = e.response!.data['error'];
        }
        
        Get.snackbar(
          'Failed',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 4),
        );
      } else {
        _showNetworkError(e.type);
      }
    } else {
      print("   Non-Dio Exception: ${e.runtimeType}");
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

void _showNetworkError(DioExceptionType type) {
  String message;
  switch (type) {
    case DioExceptionType.connectionTimeout:
      message = "Connection timeout. Check your internet connection.";
      break;
    case DioExceptionType.sendTimeout:
      message = "Request timeout. Please try again.";
      break;
    case DioExceptionType.receiveTimeout:
      message = "Server response timeout. Please try again.";
      break;
    case DioExceptionType.connectionError:
      message = "Connection error. Check your internet connection.";
      break;
    default:
      message = "Network error. Please try again.";
  }
  
  Get.snackbar(
    'Network Error',
    message,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 4),
  );
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
        // profile.value = Profile();
      } else {
        Get.snackbar(
          'Failed',
          "Something is wrong. Please check your internet connection.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      authLoading.value = false;
      Get.snackbar(
        'Failed',
        "Something is wrong. Please check your internet connection.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      preferences.clear();
      Get.offAllNamed(WelcomeScreen.id);
      token.value = '';
      // profile.value = Profile();
    }
  }

  void sendOtpRequest(String mobileNumber) {
    // authLoading.value = true;
    // //TODO: Api will call here
    // Timer(const Duration(seconds: 5), () {
    //   isOtpRequested.value = true;
    //   authLoading.value = false;
    // });
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
          "Your password has been changed.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else if (statusCode == 203) {
        Get.snackbar(
          'Failed',
          "Your credential is mismatch.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Failed',
          "Something is wrong. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      loadingChangePassword.value = false;
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
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
          "Password reset OTP has been sent to your email. Please check there.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 6),
        );
        return true;
      } else {
        Get.snackbar(
          'Failed',
          "Your credential is mismatch.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      loadingResetPassword.value = false;
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
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
          "Password reset is done. You can login now.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 6),
        );
        Get.offAllNamed(WelcomeScreen.id);
        // return true;
      } else {
        Get.snackbar(
          'Failed',
          "Your credential is mismatch.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      loadingResetPassword.value = false;
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return false;
  }
}
