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

  final userProfile = Profile().obs;
  final selectedProfileImageFile = File('').obs;

  String? _selectedProfileImageExtension;
  String? _selectedCoverImageExtension;




  void clearUploadedFiles() {
    selectedProfileImageFile.value = File('');
  }

  void putPageProfileImage({required File file, required String extension}) {
    selectedProfileImageFile.value = file;
    _selectedProfileImageExtension = extension;
  }

  void loadProfile({required int userId}) async {
    profileLoading.value = true;
    final AuthController authController = Get.find();
    var dio = Dio();
    try {
      final response = await dio.get(
        kProfileRetrieveUrl(userId),
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      profileLoading.value = false;
      if (statusCode == 200) {
        try {
          userProfile.value = Profile.fromJson(response.data['profile']);
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      profileLoading.value = false;
    }
  }

  void tryToUpdateProfile({
    required String fullName,
    required String emailAddress,
    required int hscPassingYear,
    required String institute,
    required String studentClass,    // Added parameter
    required String department,      // Added parameter
  }) async {
    profileUpdateLoading.value = true;
    final AuthController authController = Get.find();
    var dio = Dio();
    FormData formData = FormData.fromMap({
      'full_name': fullName,
      'email': emailAddress,
      'hsc_exam_year': hscPassingYear,
      'institute': institute,
      'student_class': studentClass,    // Added field
      'department': department,         // Added field
      'profile_image': selectedProfileImageFile.value.path != ''
          ? await MultipartFile.fromFile(selectedProfileImageFile.value.path,
              filename: _selectedProfileImageExtension)
          : null,
    });
    try {
      final response = await dio.put(
        kProfileUpdateUrl,
        data: formData,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
          'Content-Type': 'multipart/form-data'
        }),
      );
      int? statusCode = response.statusCode;
      profileUpdateLoading.value = false;
      if (statusCode == 200) {
        userProfile.value = Profile();
        userProfile.value = Profile.fromJson(response.data['profile']);
        authController.profile.value =
            Profile.fromJson(response.data['profile']);
        authController.preferences
            .setString('profile', jsonEncode(response.data['profile']));

        Get.snackbar(
          'Success',
          "Your profile has been updated.",
          backgroundColor: Colors.green,
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
      profileUpdateLoading.value = false;
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
