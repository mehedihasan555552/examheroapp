import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/modules/withdraw/controllers/withdraw_controller.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class WithdrawConfirmView extends GetView {
  WithdrawConfirmView({super.key, required this.withdrawMethod});
  final dynamic withdrawMethod;
  final WithdrawController _withdrawController = Get.put(WithdrawController());
  final TextEditingController _editingControllerSenderNumber =
      TextEditingController();
  final TextEditingController _editingControllerAmount =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlay(
        isLoading: _withdrawController.loadingWithdraw.value,
        // //opacity: 0.8,
        progressIndicator: const SpinKitCubeGrid(
          color: Colors.white,
          size: 50.0,
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text('${withdrawMethod['title']}'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Text(
                        //   'Account Number:',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        // withdrawMethod['method'] != null
                        //     ? ListTile(
                        //         contentPadding: EdgeInsets.zero,
                        //         horizontalTitleGap: 0,
                        //         title: Html(
                        //             data: withdrawMethod['method']
                        //                 ['description']),
                        //         trailing: InkWell(
                        //           child: Icon(Icons.copy_outlined),
                        //           onTap: () {
                        //             FlutterClipboard.copy(
                        //                     withdrawMethod['method']
                        //                         ['description'])
                        //                 .then((value) {
                        //               Get.snackbar(
                        //                 'Copied',
                        //                 withdrawMethod['method']['description'],
                        //                 backgroundColor: Colors.orange,
                        //                 colorText: Colors.white,
                        //                 snackPosition: SnackPosition.TOP,
                        //                 duration: const Duration(seconds: 2),
                        //               );
                        //             });
                        //           },
                        //         ),
                        //       )
                        //     : Text(
                        //         "You have to attached method details from Admin panel (i.e. ['method']['description'])",
                        //         style: TextStyle(
                        //           color: Colors.red,
                        //         ),
                        //       ),
                        // SizedBox(
                        //   height: 8,
                        // ),
                        Center(
                          child: Text(
                            'Percent Charge: ${double.parse(withdrawMethod['percent_charge']).toStringAsFixed(2)} BDT',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 16,
                        ),
                        rPrimaryTextField(
                            controller: _editingControllerAmount,
                            keyboardType: TextInputType.number,
                            borderColor: Theme.of(context).primaryColor,
                            hintText: 'Withdraw amount',
                            prefixIcon: Icon(Icons.attach_money_outlined)),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Enter your receiver number',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        rPrimaryTextField(
                            controller: _editingControllerSenderNumber,
                            keyboardType: TextInputType.phone,
                            borderColor: Theme.of(context).primaryColor,
                            hintText: 'Pyament number',
                            prefixIcon: Icon(Icons.mobile_friendly)),
                        const SizedBox(
                          height: 16,
                        ),
                        rPrimaryElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            String senderNumber =
                                _editingControllerSenderNumber.text.trim();
                            String amount =
                                _editingControllerAmount.text.trim();
                            if (amount.isNotEmpty &&
                                double.parse(amount) > 0 &&
                                senderNumber.isNotEmpty) {
                              bool result =
                                  await _withdrawController.tryToWithdraw(
                                methodId: withdrawMethod['id'],
                                amount: double.parse(amount),
                                receivedAmount: double.parse(amount) -
                                    ((double.parse(amount) / 100) *
                                        double.parse(
                                            withdrawMethod['percent_charge']
                                                .toString())),
                                receiverNumber: senderNumber,
                              );
                              if (result == true) {
                                Get.snackbar(
                                  'Success',
                                  'Your withdraw is pending now. Authority will response soon.',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                // Get.back(result: result);
                                Navigator.pop(context, true);
                              } else {
                                Get.snackbar(
                                  'Failed',
                                  "Your request can't proceed",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            } else {
                              Get.snackbar(
                                'Error',
                                'Please specify all fields.',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          primaryColor: Theme.of(context).primaryColor,
                          buttonText: 'Submit',
                          fontSize: 18.0,
                          borderRadius: 20.0,
                          fixedSize: const Size(double.maxFinite, 46.0),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
