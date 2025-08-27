import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/api_endpoints.dart';
import '../controllers/auth_controller.dart';
import '../screens/screen_parts/pdf_model.dart';

class BannerController extends GetxController {
  final topBannerList = [].obs;
  var currentIndexTop = 0.obs;
  var currentIndexBottom = 0.obs;
  final RxSet<int> bookmarkedItems = <int>{}.obs;
  var count =0.obs;


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
        topBannerList.clear();
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

  final bannerList = [].obs;
  Future<void> fetchBannerList() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kBottomBannerList,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        print(response.data);
        bannerList.clear();
        bannerList.addAll(response.data);
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



  // final pdfList = [].obs;
  // Future<void> fetchPdfList() async {
  //   final AuthController authController = Get.find();
  //   var dio = Dio();
  //
  //   try {
  //     final response = await dio.get(
  //       kBannerList,
  //       options: Options(headers: {
  //         'accept': '*/*',
  //         'Authorization': 'Token ${authController.token.value}',
  //       }),
  //     );
  //     int? statusCode = response.statusCode;
  //     if (statusCode == 200) {
  //       bannerList.addAll(response.data);
  //     }
  //   } catch (e) {
  //     print(e);
  //     Get.snackbar(
  //       'Failed',
  //       "Something is wrong. Please try again1.",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }



  final freePdfList = <Pdf>[].obs;
  final paidPdfList = <Pdf>[].obs;

  Future<void> fetchFreePdfLists() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        'https://examhero.xyz/api/v1/documents/pdfs/free/',
          options: Options(headers: {
            'accept': '*/*',
            'Authorization': 'Token ${authController.token.value}',
          }),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        freePdfList.clear();
        freePdfList.addAll(data.map((e) => Pdf.fromJson(e)).toList());
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Failed to fetch PDFs. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  Future<void> fetchPaidPdfLists() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        'https://examhero.xyz/api/v1/documents/pdfs/paid/',
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        paidPdfList.clear();
        paidPdfList.addAll(data.map((e) => Pdf.fromJson(e)).toList());
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Failed to fetch PDFs. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }



  final liveExamList = [].obs;
  Future<void> fetchLiveExamList() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kLiveList,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        liveExamList.addAll(response.data);
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again2.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final archiveExamList = [].obs;
  Future<void> fetchArchiveExamList() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kArchiveList,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        archiveExamList.addAll(response.data);
        print(archiveExamList);
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again3.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final upcomingExamList = [].obs;
  Future<void> fetchUpcomingExamList() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kUpcomingList,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        upcomingExamList.addAll(response.data);
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again4.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    fetchLiveExamList();
    fetchArchiveExamList();
    fetchUpcomingExamList();
    fetchPackageDetails();
    super.onInit();
  }

  // https://targetdmc.sheikhit.net/api/v1/mcq-preparation/course/

  final packageDetails = {}.obs;
  Future<void> fetchPackageDetails() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        'http://examhero.xyz/api/v1/mcq-preparation/course/',
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        packageDetails.value = response.data;
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again5.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final discount = 0.obs;
  final finalPrice = 0.obs;
  final isApplied = false.obs;

  dynamic checkPromo({required code}) async {
    final AuthController authController = Get.find();
    var dio = Dio();
    final data = {"code": code};

    try {
      final response = await dio.post(
        'http://examhero.xyz/api/v1/mcq-preparation/promo-code/',
        data: data,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;

      if (statusCode == 200 && isApplied.value == false) {
        // discount.value = int.parse(response.data['price']);
        isApplied.value = true;
        finalPrice.value = finalPrice.value - int.parse(response.data['price']);
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again6.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final isLoading = false.obs;

  final modeltestlist = [].obs;
  Future<void> fetchModelList() async {
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.get(
        kModelTestList,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        modeltestlist.addAll(response.data['subjects']);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e);
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again7.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  //add bookmarks
  Future<void> addBookmarks({required int mcqId}) async {
    print("MCQ_ID_test$mcqId");
    final AuthController authController = Get.find();
    var dio = Dio();

    try {
      final response = await dio.post(
        kBookmarks(mcqId),
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      isLoading.value = false;

      if (statusCode == 200) {
        print(response.data["result"]);

        // Toggle the mcqId in the bookmarked set
        if (bookmarkedItems.contains(mcqId)) {
          bookmarkedItems.remove(mcqId);
        } else {
          bookmarkedItems.add(mcqId);
        }

        Get.snackbar(
          'Success',
          "Bookmark updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Bookmark-$e");
      Get.snackbar(
        'Failed',
        "Something went wrong. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }




  final isbookloading = false.obs;
  final bookMarksList = {}.obs;
  Future<void> fetchBookMarksList() async {
    isbookloading.value = true;
    print('called00');
    final AuthController authController = Get.find();
    var dio = Dio();
    print(authController.token.value);

    try {
      final response = await dio.get(
        'https://examhero.xyz/api/v1/mcq-preparation/user-mcq-bookmark-list/',
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      isbookloading.value = false;
      print("++++99${response.statusCode}");
      int? statusCode = response.statusCode;
      if (statusCode == 200) {
        bookMarksList.value = response.data;
      }
      print(statusCode);
      isbookloading.value = false;
    } catch (e) {
      isbookloading.value = false;
      print(e);
      Get.snackbar(
        'Failed',
        "Something is wrong. Please try again.9",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
