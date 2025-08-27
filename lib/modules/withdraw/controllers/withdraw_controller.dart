import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/config/api_endpoints.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';

class WithdrawController extends GetxController {
  final loadingWithdrawHistories = false.obs;
  final loadingWithdraw = false.obs;




  Future<List<dynamic>> loadWithdrawHistories() async {
    AuthController authController = Get.find();
    loadingWithdrawHistories.value = true;
    var dio = Dio();
    final List<dynamic> listData = [];

    try {
      final response = await dio.get(
        kWithdrawHistoryUrl,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      loadingWithdrawHistories.value = false;

      if (statusCode == 200) {
        listData.addAll(response.data['withdraw_request_list']);
      }
    } catch (e) {
      // Nothing
      loadingWithdrawHistories.value = false;
    }
    return listData;
  }

  Future<bool> tryToWithdraw(
      {required int methodId,
      required double amount,
      required double receivedAmount,
      required String receiverNumber}) async {
    AuthController authController = Get.find();
    loadingWithdraw.value = true;

    dynamic data = {
      'payment_method': methodId,
      'amount': amount,
      'received_amount': receivedAmount,
      'receiver_number': receiverNumber,
    };
    var dio = Dio();

    try {
      final response = await dio.post(
        kWithdrawRequestCreateUrl,
        data: data,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      loadingWithdraw.value = false;

      if (statusCode == 201) {
        Get.snackbar(
          'Success',
          "Your withdraw request has been sent. Please wait for authority confirmation.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 6),
        );
        return true;
      } else if (statusCode == 203) {
        Get.snackbar(
          'Failed',
          "You have no sufficient amount to withdraw!",
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
      // Nothing
      loadingWithdraw.value = false;
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
