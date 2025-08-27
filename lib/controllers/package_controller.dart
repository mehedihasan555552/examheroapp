import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/config/api_endpoints.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/models/profile_model.dart';
import 'package:mission_dmc/modules/deposit/views/deposit_view.dart';

class PackageController extends GetxController {
  var packageData = Rx<dynamic>(null); // Add this in your PackageController
  final loadingOnPurchase = false.obs;
  final loadingEarningHistoryList = false.obs;

  final List<dynamic> listEarningHistory = <dynamic>[].obs;




  Future<dynamic> fetchPackage() async {
    AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kPackageRetrieveUrl,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      //
    }
    return {};
  }

  void loadEarningHistoryList() async {
    loadingEarningHistoryList.value = true;
    AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kEarningHistoryListUrl,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      loadingEarningHistoryList.value = false;
      if (statusCode == 200) {
        listEarningHistory.clear();
        listEarningHistory.addAll(response.data);
      }
    } catch (e) {
      loadingEarningHistoryList.value = false;
    }
  }

  Future<bool> tryToPurchasePackage(
      {required int packageId, String? referralCode}) async {
    AuthController authController = Get.find();
    loadingOnPurchase.value = true;

    var data = {
      'package_id': packageId,
      'referral_code': referralCode,
    };
    var dio = Dio();

    try {
      final response = await dio.post(
        kPackagePurchasedCreateUrl,
        data: data,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      loadingOnPurchase.value = false;

      if (statusCode == 201) {
        Profile profile = authController.profile.value;
        profile.package = packageId.toString();
        authController.profile.value = profile;
        authController.preferences
            .setString('profile', jsonEncode(profile.toJson()));
        Get.snackbar(
          'Success',
          "You have purchased.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 6),
        );
        return true;
      } else if (statusCode == 203) {
        Get.snackbar(
          'Failed',
          "You have no sufficient balance to purchase this package. Please deposit first.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 6),
        );
        Get.off(() => DepositView());
      } else {
        Get.snackbar(
          'Failed',
          "Something is wrong. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      loadingOnPurchase.value = false;
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
    return false;
  }
}
