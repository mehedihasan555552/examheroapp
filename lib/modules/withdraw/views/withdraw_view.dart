import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mission_dmc/controllers/nav_controller.dart';
import 'package:mission_dmc/modules/withdraw/views/withdraw_history_list_view.dart';
import 'package:mission_dmc/modules/withdraw/views/withdraw_method_list_view.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

import '../controllers/withdraw_controller.dart';

class WithdrawView extends GetView<WithdrawController> {
  WithdrawView({super.key});
  final NavController _navController = Get.put(NavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                ),
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 16,
            right: 16,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 260,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const Text(
                              'Cash Balance',
                              style: TextStyle(fontSize: 12),
                            ),
                            FutureBuilder(
                              future: _navController.loadBalance(),
                              builder: (context, snapshot) {
                                // Checking if future is resolved
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  // If we got an error
                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text(
                                        'Error occurred',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );

                                    // if we got our data
                                  } else if (snapshot.hasData) {
                                    // Extracting data from snapshot object
                                    final data = snapshot.data as dynamic;
                                    double amount = 0.0;

                                    if (data != null &&
                                        data['balance'] != null) {
                                      if (data['balance']['amount'] != null) {
                                        amount = double.parse(data['balance']
                                                ['amount']
                                            .toString());
                                      }
                                    }
                                    return Center(
                                      child: Text(
                                        '${double.parse(amount.toString()).toStringAsFixed(2)} BDT',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                            child: const Icon(
                              Icons.attach_money_outlined,
                              size: 64,
                              color: Color(0xFF28ADFC),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Withdraw Here',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  'Choose your withdraw method',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                rPrimaryElevatedButton(
                                  onPressed: () => Get.to(
                                      () => WithdrawMethodListView(),
                                      fullscreenDialog: true),
                                  primaryColor: const Color(0xFF24BAB9),
                                  buttonText: 'Withdraw Now',
                                  fontSize: 16,
                                  fixedSize: const Size(180, 46),
                                  borderRadius: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(width: 1, color: Colors.grey),
                              ),
                            ),
                            child: const Icon(
                              Icons.history_outlined,
                              size: 64,
                              color: Color(0xFF494949),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Withdraw Histories',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  'View your withdraw histories',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                rPrimaryElevatedButton(
                                  onPressed: () => Get.to(
                                      () => WithdrawHistoryListView(),
                                      fullscreenDialog: true),
                                  primaryColor: const Color(0xFF494949),
                                  buttonText: 'View',
                                  fontSize: 16,
                                  fixedSize: const Size(180, 46),
                                  borderRadius: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
