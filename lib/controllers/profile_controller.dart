import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:mission_dmc/config/api_endpoints.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/models/profile_model.dart';

class ProfileController extends GetxController {
  final profileLoading = false.obs;
  final profileUpdateLoading = false.obs;
  final imageUploadProgress = 0.0.obs;

  final userProfile = Profile().obs;
  final selectedProfileImageFile = File('').obs;

  String? _selectedProfileImageExtension;

  @override
  void onInit() {
    super.onInit();
    _initializeProfile();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _initializeProfile() {
    // Initialize with current user's profile if available
    final AuthController authController = Get.find();
    if (authController.profile.value.id != null) {
      userProfile.value = authController.profile.value;
    }
  }

  void clearUploadedFiles() {
    selectedProfileImageFile.value = File('');
    _selectedProfileImageExtension = null;
    imageUploadProgress.value = 0.0;
  }

  void putPageProfileImage({required File file, required String extension}) {
    selectedProfileImageFile.value = file;
    _selectedProfileImageExtension = extension;
    print('Profile image selected: ${file.path}');
  }

  // Enhanced profile loading with better error handling
  void loadProfile({required int userId}) async {
    profileLoading.value = true;
    print('Loading profile for userId: $userId');
    
    final AuthController authController = Get.find();
    
    // Check if we already have this profile loaded
    if (userProfile.value.user?.uid == userId && userProfile.value.id != null) {
      profileLoading.value = false;
      return;
    }

    var dio = _createDioClient();
    
    try {
      final response = await dio.get(
        kProfileRetrieveUrl(userId),
        options: Options(headers: {
          'accept': 'application/json',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      
      profileLoading.value = false;
      int? statusCode = response.statusCode;
      
      print('Profile load response status: $statusCode');
      print('Profile load response data: ${response.data}');
      
      if (statusCode == 200) {
        try {
          // Handle different response structures
          Map<String, dynamic> profileData;
          
          if (response.data.containsKey('profile')) {
            profileData = response.data['profile'];
          } else {
            profileData = response.data;
          }
          
          userProfile.value = Profile.fromJson(profileData);
          print('Profile loaded successfully: ${userProfile.value.full_name}');
          
        } catch (e) {
          print('Error parsing profile data: $e');
          _showError('Failed to load profile data');
        }
      } else if (statusCode == 404) {
        _showError('Profile not found');
      } else if (statusCode == 401) {
        _showError('Unauthorized access');
        // Potentially redirect to login
      } else {
        _showError('Failed to load profile');
      }
    } catch (e) {
      profileLoading.value = false;
      print('Profile loading error: $e');
      
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
            _showError('Connection timeout. Please try again.');
            break;
          case DioExceptionType.connectionError:
            _showError('No internet connection.');
            break;
          case DioExceptionType.badResponse:
            _showError('Server error. Please try again later.');
            break;
          default:
            _showError('Failed to load profile. Please try again.');
        }
      } else {
        _showError('An unexpected error occurred.');
      }
    }
  }

  // Enhanced profile update with new fields
  void tryToUpdateProfile({
    required String fullName,
    required String emailAddress,
    required String institute,
    String? studentClass,
    String? department,
  }) async {
    profileUpdateLoading.value = true;
    imageUploadProgress.value = 0.0;
    
    print('=== PROFILE UPDATE ATTEMPT ===');
    print('Full Name: $fullName');
    print('Email: $emailAddress');
    print('Institute: $institute');
    print('Student Class: $studentClass');
    print('Department: $department');
    print('Has Profile Image: ${selectedProfileImageFile.value.path.isNotEmpty}');
    
    final AuthController authController = Get.find();
    var dio = _createDioClient();
    
    try {
      // Prepare form data
      Map<String, dynamic> formDataMap = {
        'full_name': fullName,
        'email': emailAddress,
        'institute': institute,
      };
      
      // Add new fields if provided
      if (studentClass != null && studentClass.isNotEmpty) {
        formDataMap['student_class'] = studentClass;
      }
      
      if (department != null && department.isNotEmpty) {
        formDataMap['department'] = department;
      }
      
      // Add profile image if selected
      if (selectedProfileImageFile.value.path.isNotEmpty) {
        String filename = 'profile_${DateTime.now().millisecondsSinceEpoch}.$_selectedProfileImageExtension';
        formDataMap['profile_image'] = await MultipartFile.fromFile(
          selectedProfileImageFile.value.path,
          filename: filename,
        );
      }
      
      FormData formData = FormData.fromMap(formDataMap);
      
      print('Form data prepared successfully');
      
      final response = await dio.put(
        kProfileUpdateUrl,
        data: formData,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Token ${authController.token.value}',
            'Content-Type': 'multipart/form-data'
          },
        ),
        onSendProgress: (sent, total) {
          if (total != -1) {
            imageUploadProgress.value = (sent / total);
            print('Upload progress: ${(sent / total * 100).toStringAsFixed(1)}%');
          }
        },
      );
      
      profileUpdateLoading.value = false;
      int? statusCode = response.statusCode;
      
      print('=== PROFILE UPDATE RESPONSE ===');
      print('Status Code: $statusCode');
      print('Response Data: ${response.data}');
      
      if (statusCode == 200) {
        try {
          // Handle different response structures
          Map<String, dynamic> profileData;
          
          if (response.data.containsKey('profile')) {
            profileData = response.data['profile'];
          } else {
            profileData = response.data;
          }
          
          // Update local profile
          userProfile.value = Profile.fromJson(profileData);
          
          // Update auth controller profile
          authController.profile.value = Profile.fromJson(profileData);
          
          // Update shared preferences
          await authController.preferences.setString(
            'profile', 
            jsonEncode(profileData)
          );
          
          // Clear uploaded files
          clearUploadedFiles();
          
          print('Profile updated successfully');
          
          Get.snackbar(
            'Success',
            "Your profile has been updated successfully.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
          
          // Navigate back
          Get.back();
          
        } catch (e) {
          print('Error parsing updated profile: $e');
          _showError('Profile updated but failed to refresh data');
        }
        
      } else if (statusCode == 400) {
        // Handle validation errors
        String errorMessage = "Please check your input and try again.";
        
        if (response.data != null && response.data['error'] != null) {
          errorMessage = response.data['error'].toString();
        } else if (response.data != null && response.data.containsKey('email')) {
          errorMessage = "Invalid email address.";
        }
        
        _showError(errorMessage);
        
      } else if (statusCode == 401) {
        _showError("Unauthorized. Please login again.");
        // Potentially redirect to login
      } else {
        _showError("Failed to update profile. Please try again.");
      }
      
    } catch (e) {
      profileUpdateLoading.value = false;
      imageUploadProgress.value = 0.0;
      
      print('Profile update error: $e');
      
      if (e is DioException) {
        print('DioException details:');
        print('- Type: ${e.type}');
        print('- Status Code: ${e.response?.statusCode}');
        print('- Response Data: ${e.response?.data}');
        print('- Message: ${e.message}');
        
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            _showError('Upload timeout. Please check your connection and try again.');
            break;
          case DioExceptionType.connectionError:
            _showError('No internet connection. Please check your network.');
            break;
          case DioExceptionType.badResponse:
            String errorMessage = "Server error. Please try again later.";
            
            if (e.response?.statusCode == 400 && e.response?.data != null) {
              if (e.response!.data['error'] != null) {
                errorMessage = e.response!.data['error'].toString();
              }
            }
            
            _showError(errorMessage);
            break;
          default:
            _showError('Failed to update profile. Please try again.');
        }
      } else {
        _showError('An unexpected error occurred. Please try again.');
      }
    }
  }

  // Create configured Dio client
  Dio _createDioClient() {
    var dio = Dio();
    
    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(minutes: 2), // Longer for file uploads
    );
    
    // Add logging interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        print('REQUEST HEADERS: ${options.headers}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE[${response.statusCode}] => DATA LENGTH: ${response.data?.toString().length ?? 0}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('ERROR[${error.response?.statusCode}] => MESSAGE: ${error.message}');
        print('ERROR TYPE: ${error.type}');
        handler.next(error);
      },
    ));
    
    return dio;
  }

  // Helper method to show errors
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  // Helper method to validate update data
  bool _validateUpdateData({
    required String fullName,
    required String emailAddress,
    required String institute,
  }) {
    if (fullName.trim().isEmpty) {
      _showError('Full name is required');
      return false;
    }
    
    if (emailAddress.trim().isEmpty || !GetUtils.isEmail(emailAddress)) {
      _showError('Valid email address is required');
      return false;
    }
    
    if (institute.trim().isEmpty) {
      _showError('Institute name is required');
      return false;
    }
    
   
    
    return true;
  }

  // Refresh current profile
  void refreshProfile() {
    if (userProfile.value.user?.uid != null) {
      loadProfile(userId: userProfile.value.user!.uid!);
    }
  }

  // Check if profile is complete
  bool get isProfileComplete {
    return userProfile.value.isProfileComplete;
  }

  // Get profile completion percentage
  double get profileCompletionPercentage {
    int completedFields = 0;
    int totalFields = 7; // Adjust based on required fields
    
    if (userProfile.value.full_name?.isNotEmpty == true) completedFields++;
    if (userProfile.value.email?.isNotEmpty == true) completedFields++;
    if (userProfile.value.institute?.isNotEmpty == true) completedFields++;
    if (userProfile.value.hsc_exam_year != null) completedFields++;
    if (userProfile.value.student_class?.isNotEmpty == true) completedFields++;
    if (userProfile.value.department?.isNotEmpty == true) completedFields++;
    if (userProfile.value.profile_image?.isNotEmpty == true) completedFields++;
    
    return completedFields / totalFields;
  }
}
