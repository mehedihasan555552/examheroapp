import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/config/api_endpoints.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';

class NavController extends GetxController {
  final loadingPaymentMethods = false.obs;
  final loadingBalance = false.obs;

  final pageIndex = 0.obs;




  void setPageIndex({required int index}) {
    pageIndex.value = index;
  }

  Future<List<dynamic>> loadPaymentMethods() async {
    AuthController authController = Get.find();
    loadingPaymentMethods.value = true;
    var dio = Dio();
    final List<dynamic> listData = [];

    try {
      final response = await dio.get(
        kPaymentMethodListUrl,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      loadingPaymentMethods.value = false;

      if (statusCode == 200) {
        listData.addAll(response.data['payment_methods']);
      }
    } catch (e) {
      // Nothing
      loadingPaymentMethods.value = false;
    }
    return listData;
  }

  Future<dynamic> loadBalance() async {
    AuthController authController = Get.find();
    loadingBalance.value = true;
    var dio = Dio();
    dynamic balanceData;

    try {
      final response = await dio.get(
        kBalanceRetrieveUrl,
        options: Options(headers: {
          'accept': '*/*',
          'Authorization': 'Token ${authController.token.value}',
        }),
      );
      int? statusCode = response.statusCode;
      loadingBalance.value = false;

      if (statusCode == 200) {
        // balanceData = response.data['balance'];
        balanceData = response.data;
      }
    } catch (e) {
      // Nothing
      loadingBalance.value = false;
    }
    return balanceData;
  }
}
