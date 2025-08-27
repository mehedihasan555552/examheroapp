import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:mission_dmc/controllers/nav_controller.dart';
import 'package:mission_dmc/modules/deposit/views/deposit_confirm_view.dart';

class DepositMethodListView extends GetView {
  DepositMethodListView({super.key});
  final NavController _navController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Choose deposit method'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: _navController.loadPaymentMethods(),
        builder: (context, snapshot) {
          // Checking if future is resolved
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error occurred',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final dataList = snapshot.data as List<dynamic>;
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  dynamic data = dataList[index];
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: .5),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      onTap: () async {
                        dynamic result = await Get.to(
                          () => DepositConfirmView(depositMethod: data),
                          fullscreenDialog: true,
                        );
                        if (result != null &&
                            result.runtimeType == bool &&
                            result == true) {
                          Navigator.pop(context, result);
                          // Get.back();
                        }
                      },
                      leading: CachedNetworkImage(
                        imageUrl: data['logo'],
                        width: 60.0,
                        height: 40.0,
                        fit: BoxFit.contain,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['title']),
                          Text(data['account_number']),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
          // Displaying LoadingSpinner to indicate waiting state
          return const Center(
            child: SpinKitCubeGrid(
              color: Colors.white,
              size: 50.0,
            ),
          );
        },
      ),
    );
  }
}
