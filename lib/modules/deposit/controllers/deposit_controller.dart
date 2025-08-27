import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:mission_dmc/config/api_endpoints.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';

class DepositController extends GetxController {
  final loadingDepositHistories = false.obs;
  final loadingDeposit = false.obs;
  final pickedImageFile = File('').obs;
  final pickedImageFileExtension = ''.obs;




  void clearImageFile() {
    pickedImageFile.value = File('');
    pickedImageFileExtension.value = '';
  }

  void setImageFile(File file, String extension) {
    pickedImageFile.value = file;
    pickedImageFileExtension.value = extension;
  }

  Future<List<dynamic>> loadDepositHistories() async {
    AuthController authController = Get.find();
    loadingDepositHistories.value = true;
    var dio = Dio();
    final List<dynamic> listData = [];

    try {
      final response = await dio.get(
        kDepositHistoryListUrl,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      loadingDepositHistories.value = false;

      if (statusCode == 200) {
        listData.addAll(response.data['deposit_request_list']);
      }
    } catch (e) {
      // Nothing
      loadingDepositHistories.value = false;
    }
    return listData;
  }

  Future<bool> tryToDeposit(
      {required int methodId,
      required double amount,
      required String senderNumber,
      String? transactionId}) async {
    AuthController authController = Get.find();
    loadingDeposit.value = true;

    FormData formData = FormData.fromMap({
      'payment_method': methodId,
      'amount': amount,
      'sender_number': senderNumber,
      'transaction_id': transactionId,
      'screenshot': await MultipartFile.fromFile(
        pickedImageFile.value.path,
        filename:
            '${DateTime.now().toString()}.${pickedImageFileExtension.value}',
      ),
    });
    var dio = Dio();

    try {
      final response = await dio.post(
        kDepositRequestCreateUrl,
        data: formData,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
          'Content-Type': 'multipart/form-data',
        }),
      );
      int? statusCode = response.statusCode;
      loadingDeposit.value = false;

      if (statusCode == 201) {
        Get.snackbar(
          'Success',
          "Your deposit request has been sent. Please wait for authority confirmation.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
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
      loadingDeposit.value = false;
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
