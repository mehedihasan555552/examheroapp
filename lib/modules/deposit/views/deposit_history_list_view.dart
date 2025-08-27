import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/modules/deposit/controllers/deposit_controller.dart';
import 'package:mission_dmc/modules/deposit/views/deposit_details_view.dart';

class DepositHistoryListView extends GetView {
  DepositHistoryListView({super.key});
  final DepositController _depositController = Get.put(DepositController());
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deposit Histories'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: _depositController.loadDepositHistories(),
        builder: ((context, snapshot) {
          // Checking if future is resolved or not
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error occurred',
                  style: TextStyle(color: Colors.red),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final dataList = snapshot.data as List<dynamic>;

              if (dataList.isEmpty) {
                return const Center(
                  child: Text(
                    'No history yet.',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  dynamic data = dataList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          onTap: () {
                            Get.to(() => DepositDetailsView(data: data),
                                fullscreenDialog: true);
                            // Get.defaultDialog(
                            //   title: data['payment_method']['title'],
                            //   titleStyle: const TextStyle(
                            //     fontSize: 18.0,
                            //     color: Colors.red,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            //   titlePadding: const EdgeInsets.symmetric(
                            //       vertical: 16.0, horizontal: 8.0),
                            //   content: SingleChildScrollView(
                            //     child: Padding(
                            //       padding: const EdgeInsets.symmetric(
                            //           horizontal: 8.0),
                            //       child: Column(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //               'Amount: ${double.parse(data['amount']).toStringAsFixed(2)} BDT'),
                            //           const SizedBox(
                            //             height: 8,
                            //           ),
                            //           data['payment_method'][
                            //                       'is_receive_transaction_id'] ==
                            //                   true
                            //               ? Text(
                            //                   'Trx ID: ${data['transaction_id']}')
                            //               : Container(),
                            //           data['payment_method'][
                            //                       'is_receive_transaction_id'] ==
                            //                   true
                            //               ? const SizedBox(
                            //                   height: 8,
                            //                 )
                            //               : Container(),
                            //           Text(
                            //               'Feedback: ${data['feedback'] ?? 'No feedback'}'),
                            //           const SizedBox(
                            //             height: 8,
                            //           ),
                            //           Text(
                            //             'Status: ${data['is_accepted'] == true ? 'Approved' : data['is_declined'] == true ? 'Declined' : 'Pending'}',
                            //             style: TextStyle(
                            //                 color: data['is_accepted'] == true
                            //                     ? Colors.green
                            //                     : data['is_declined'] == true
                            //                         ? Colors.red
                            //                         : Colors.amber,
                            //                 fontWeight: FontWeight.w700),
                            //           ),
                            //           const SizedBox(
                            //             height: 8,
                            //           ),
                            //           Text(
                            //               'Date: ${DateFormat.yMMMd().add_jm().format(DateTime.parse(data['requested_datetime']).toLocal())}'),
                            //           const SizedBox(
                            //             height: 8,
                            //           ),
                            //           CachedNetworkImage(
                            //             imageUrl: data['screenshot'],
                            //             placeholder: (context, url) =>
                            //                 const Center(
                            //               child: CircularProgressIndicator(),
                            //             ),
                            //           ),
                            //           const SizedBox(
                            //             height: 8,
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // );
                          },
                          leading: _authController
                                      .profile.value.profile_image ==
                                  null
                              ? const CircleAvatar(
                                  backgroundColor: Colors.blueGrey,
                                  backgroundImage:
                                      AssetImage('assets/default/profile.jpg'),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.blueGrey,
                                  backgroundImage: CachedNetworkImageProvider(
                                      _authController
                                          .profile.value.profile_image!),
                                ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${double.parse(data['amount'].toString()).toStringAsFixed(2)} BDT'),
                              Text(
                                data['is_accepted'] == true
                                    ? 'Approved'
                                    : data['is_declined'] == true
                                        ? 'Declined'
                                        : 'Pending',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: data['is_accepted'] == true
                                        ? Colors.green
                                        : data['is_declined'] == true
                                            ? Colors.red
                                            : Colors.amber,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: Text(
                            // '27th Aug, 2022',
                            DateFormat.yMMMd().add_jm().format(
                                DateTime.parse(data['requested_datetime'])
                                    .toLocal()),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.deepOrange),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: dataList.length,
              );
            } else {
              return const Center(
                child: Text(
                  'No history yet.',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
          }

          // Displaying LoadingSpinner to indicate waiting state
          return Center(
            child: SpinKitCubeGrid(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ),
          );
        }),
      ),
    );
  }
}
