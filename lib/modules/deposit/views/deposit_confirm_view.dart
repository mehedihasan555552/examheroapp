import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/modules/deposit/controllers/deposit_controller.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class DepositConfirmView extends GetView {
  DepositConfirmView({
    super.key,
    required this.depositMethod,
  });
  final dynamic depositMethod;
  final DepositController _depositController = Get.put(DepositController());
  final TextEditingController _editingControllerMobile =
      TextEditingController();
  final TextEditingController _editingControllerAmount =
      TextEditingController();
  final TextEditingController _editingControllerTrxID = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, () {
    //   controller.clearImageFile();
    // });
    return Obx(
      () => LoadingOverlay(
        isLoading: _depositController.loadingDeposit.value,
        // //opacity: 0.8,
        progressIndicator: SpinKitCubeGrid(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text('${depositMethod['title']}'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      ListTile(
                        // contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 0,
                        title: Text(
                          'Account: ${depositMethod['account_number']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: InkWell(
                          child: const Icon(Icons.copy_outlined),
                          onTap: () {
                            FlutterClipboard.copy(
                                    depositMethod['account_number'])
                                .then((value) {
                              Get.snackbar(
                                'Copied',
                                depositMethod['account_number'],
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 2),
                              );
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Obx(
                        () =>
                            _depositController.pickedImageFile.value.path != ''
                                ? Image.file(
                                    _depositController.pickedImageFile.value)
                                : Image.asset('assets/default/default.jpg'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
                              'jpg',
                              'jpeg',
                              'png',
                              'gif',
                              'tiff'
                            ],
                          );

                          if (result != null) {
                            PlatformFile file = result.files.first;
                            // _fileExtension = file.extension;
                            File imageFile = File(file.path!);

                            _depositController.setImageFile(
                                imageFile, file.extension!);
                          }
                        },
                        icon: const Icon(Icons.image),
                        label: const Text('Pick screenshot of send mony'),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, backgroundColor: Colors.white),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      rPrimaryTextField(
                        controller: _editingControllerAmount,
                        keyboardType: TextInputType.number,
                        borderColor: Colors.grey,
                        hintText: 'Amount',
                        prefixIcon: const Icon(Icons.attach_money_outlined),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      rPrimaryTextField(
                        controller: _editingControllerMobile,
                        keyboardType: TextInputType.phone,
                        borderColor: Colors.grey,
                        hintText: 'Sender number',
                        prefixIcon: const Icon(Icons.phone_android),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      depositMethod['is_receive_transaction_id'] == true
                          ? rPrimaryTextField(
                              controller: _editingControllerTrxID,
                              keyboardType: TextInputType.text,
                              borderColor: Colors.grey,
                              hintText: 'Transaction ID',
                              prefixIcon: const Icon(Icons.security_outlined),
                            )
                          : Container(),
                      depositMethod['is_receive_transaction_id'] == true
                          ? const SizedBox(
                              height: 16,
                            )
                          : Container(),
                      rPrimaryElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          String amountText =
                              _editingControllerAmount.text.trim();
                          String senderNumber =
                              _editingControllerMobile.text.trim();
                          String trxID = _editingControllerTrxID.text.trim();
                          String imagePath =
                              _depositController.pickedImageFile.value.path;
                          if (depositMethod['is_receive_transaction_id'] ==
                                  true &&
                              trxID.isEmpty) {
                            Get.snackbar(
                              'Error',
                              "You must specify transaction ID",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          if (amountText.isNotEmpty &&
                              double.parse(amountText) > 0 &&
                              senderNumber.isNotEmpty &&
                              imagePath.isNotEmpty) {
                            bool result = await _depositController.tryToDeposit(
                                senderNumber: senderNumber,
                                amount: double.parse(amountText),
                                methodId: depositMethod['id'],
                                transactionId: trxID);
                            if (result) {
                              Navigator.pop(context, result);
                            }
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please submit Sender number and Screen Shot of send money.',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        primaryColor: Theme.of(context).primaryColor,
                        buttonText: 'Confirm',
                        fontSize: 18.0,
                        borderRadius: 20.0,
                        fixedSize: const Size(double.maxFinite, 46.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
