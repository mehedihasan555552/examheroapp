import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/config/api_endpoints.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';

class MCQPreparationController extends GetxController {
  final loadingMCQSubmission = false.obs;
  List<dynamic> listMCQChoosen = <dynamic>[].obs;
  final examTimeLeft = '00:00'.obs;




  void setFormatedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    examTimeLeft.value = "$minute : $second";
  }

  Future<List<dynamic>> fetcExamCategoryList() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kExamCategoryListUrl,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        return response.data['exam_categories'];
      }
    } catch (e) {
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return [];
  }

  Future<List<dynamic>> fetchExamList({required int categoryId}) async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kExamListUrl(categoryId),
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        return response.data['exam_list'];
      }
    } catch (e) {
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return [];
  }

  Future<List<dynamic>> fetchSubjectList() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kSubjectListUrl,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        return response.data['subjects'];
      }
    } catch (e) {
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return [];
  }

  Future<List<dynamic>> fetchSectionList({required int subjectId}) async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kSectionListUrl(subjectId),
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        return response.data['sections'];
      }
    } catch (e) {
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return [];
  }

  Future<dynamic> fetchMyPerformace() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kMyPerformaceRetrieveUrl,
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
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return {};
  }

  Future<List<dynamic>> fetcMCQTestRankingList({
    required int testId,
    required bool isSubjectWise,
  }) async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      print(kMCQTestRankingListUrl(testId));
      print('Token ${authController.token.value}');
      final response = await dio.get(
        kMCQTestRankingListUrl(testId),
        queryParameters: {'is_subject_wise_exam': isSubjectWise},
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        return response.data['ranking_list'];
      }
    } catch (e) {
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return [];
  }

  Future<dynamic> fetchCategoryWiseMCQList(
      {required int examId, int testId = 0}) async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kCategoryWiseMCQListUrl(examId),
        queryParameters: {'test_id': testId},
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
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return {};
  }

  Future<dynamic> fetchSectionWiseMCQList(
      {required int sectionId, int testId = 0}) async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kSectionMCQListUrl(sectionId),
        queryParameters: {'test_id': testId},
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
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return {};
  }

  Future<dynamic> tryToSubmitMCQTest({
    required bool isSubjectWise,
    required int testId,
  }) async {
    loadingMCQSubmission.value = true;
    final AuthController authController = Get.find();

    var data = {
      'is_subject_wise_exam': isSubjectWise,
      'list_submission': listMCQChoosen,
    };
    var dio = Dio();

    try {
      final response = await dio.post(
        kMCQTestAnswerSubmitCreateUrl(testId),
        data: data,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      loadingMCQSubmission.value = false;
      if (statusCode == 201) {
        return response.data['mcq_test_result'];
      }
    } catch (e) {
      loadingMCQSubmission.value = false;
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    return null;
  }

  bool checkOptionExistsInAnswerList(
      {required List<dynamic> listAnswer,
      required int questionId,
      required String choosenOption}) {
    int index = listAnswer.indexWhere((element) =>
        element['id'] == questionId &&
        element['choosen_option'] == choosenOption);
    if (index > -1) {
      return true;
    }

    return false;
  }

  void clearMCQChoosenList() => listMCQChoosen.clear();

  void setMCQChoosenOption({required int id, required String choosenOption}) {
    // Prevent adding or updating if the option is already chosen
    int index = listMCQChoosen.indexWhere((element) => element['id'] == id);
    if (index == -1) {
      // Insert only if no choice has been made for this question
      listMCQChoosen.add({'id': id, 'choosen_option': choosenOption});
    }
  }

  bool checkMCQChoosenOption({required int id, required String choosenOption}) {
    int index = listMCQChoosen.indexWhere((element) =>
        element['id'] == id && element['choosen_option'] == choosenOption);
    if (index > -1) {
      return true;
    }
    return false;
  }
}
