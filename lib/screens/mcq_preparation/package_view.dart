import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/controllers/package_controller.dart';
import 'package:mission_dmc/update_controllers/banner_controller.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../app/modules/info/views/terms_and_conditions_view.dart';
import '../../config/constants.dart';

class PackageView extends StatefulWidget {
  const PackageView({super.key});

  @override
  _PackageViewState createState() => _PackageViewState();
}

class _PackageViewState extends State<PackageView> {
  final BannerController bannerController = Get.find();
  final PackageController _packageController = Get.put(PackageController());
  final AuthController _authController = Get.find();
  final TextEditingController _editingControllerReferalCode = TextEditingController();

  late YoutubePlayerController _youtubeController;

  // Selected package tracking
  final RxInt _selectedPackageIndex = RxInt(1); // Default to 6 months package
  bool isChecked = false;

  // Package data
  final List<Map<String, dynamic>> packages = [
    {
      'duration': 3,
      'title': '৩ মাসের প্যাকেজ',
      'subtitle': 'Basic Course Access',
      'color': Colors.orange,
      'discount': '10%',
    },
    {
      'duration': 6,
      'title': '৬ মাসের প্যাকেজ',
      'subtitle': 'Standard Course Access',
      'color': Colors.blue,
      'discount': '20%',
      'popular': true,
    },
    {
      'duration': 12,
      'title': '১২ মাসের প্যাকেজ',
      'subtitle': 'Premium Course Access',
      'color': Colors.green,
      'discount': '30%',
    },
  ];

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: bannerController.packageDetails['video_url'],
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Purchase Package'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _packageController.fetchPackage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Error occurred',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              } else if (snapshot.hasData) {
                final data = snapshot.data as dynamic;
                if (data == null || data['title'] == null) {
                  return Container();
                }
                return _packageItem(data: data, context: context);
              }
            }
            return Center(
              child: SpinKitCubeGrid(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _packageItem({required dynamic data, required BuildContext context}) {
    return Obx(() {
      return LoadingOverlay(
        isLoading: _packageController.loadingOnPurchase.value,
        progressIndicator: SpinKitCubeGrid(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // YouTube Video
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: YoutubePlayer(
                    controller: _youtubeController,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Course Details Button
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                    title: 'Course Description',
                    content: Text(bannerController.packageDetails['description']),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Course Details >',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Main Course Title
              Text(
                data['title'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.green.shade900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              // Package Selection Cards
              Text(
                'Choose Your Package',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 15),

              // Package Cards
              ...packages.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> package = entry.value;
                return Obx(() => _buildPackageCard(package, index, context));
              }).toList(),

              const SizedBox(height: 25),

              // Price Display
              Obx(() {
                final originalPrice = int.parse(bannerController.packageDetails['price']);
                final selectedPackage = packages[_selectedPackageIndex.value];
                bannerController.finalPrice.value = (originalPrice * selectedPackage['duration']).toInt();

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[50]!, Colors.green[100]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green[300]!, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total Price',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${bannerController.finalPrice.value} ৳',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'for ${selectedPackage['duration']} months',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Promo Code Field
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Have a Promo Code?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: rPrimaryTextField(
                            controller: _editingControllerReferalCode,
                            keyboardType: TextInputType.text,
                            borderColor: Theme.of(context).primaryColor,
                            hintText: 'Enter your promo code',
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            bannerController.checkPromo(
                                code: _editingControllerReferalCode.text.trim());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Terms and Conditions Checkbox
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Get.to(() => TermsAndConditionsView(authController: _authController));
                        },
                        child: const Text(
                          "I agree to the Terms & Conditions, Privacy Policy, Refund Policy, and About App.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Purchase Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await _handlePurchase(data, context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Purchase Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPackageCard(Map<String, dynamic> package, int index, BuildContext context) {
    final bool isSelected = _selectedPackageIndex.value == index;
    final bool isPopular = package['popular'] == true;

    return GestureDetector(
      onTap: () {
        _selectedPackageIndex.value = index;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [package['color'].withOpacity(0.1), package['color'].withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? package['color'] : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? package['color'].withOpacity(0.2) : Colors.black.withOpacity(0.05),
              spreadRadius: isSelected ? 2 : 1,
              blurRadius: isSelected ? 15 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Package Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: package['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.access_time,
                      color: package['color'],
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  
                  // Package Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? package['color'] : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          package['subtitle'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: package['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${package['discount']} OFF',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: package['color'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Selection Indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? package['color'] : Colors.grey[400]!,
                        width: 2,
                      ),
                      color: isSelected ? package['color'] : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ],
              ),
            ),
            
            // Popular Badge
            if (isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: package['color'],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePurchase(dynamic data, BuildContext context) async {
    if (isChecked) {
      FocusScope.of(context).unfocus();
      if (_packageController.loadingOnPurchase.value) {
        return;
      }

      String referalCode = _editingControllerReferalCode.text.trim();

      // Check if the referral code is the user's own referral code
      if (referalCode == _authController.profile.value.referral_code) {
        Get.snackbar(
          'Failed',
          "Can't allow using your own Referral Code during package purchase.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Call SSLCommerz Payment
      Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          multi_card_name: "visa,master,bkash",
          currency: SSLCurrencyType.BDT,
          product_category: "Study",
          sdkType: SSLCSdkType.TESTBOX, // Change to LIVE for production
          store_id: "prepm6770cd934cda9",
          store_passwd: "prepm6770cd934cda9@ssl",
          total_amount: bannerController.finalPrice.value.toDouble(),
          tran_id: "custom_transaction_id", // Ensure this ID is unique for each transaction
        ),
      );

      try {
        var transactionResult = await sslcommerz.payNow();

        // Check the transaction status
        if (transactionResult.status == "VALID") {
          // Purchase the package after successful payment
          Get.to(PackageView());
          // bool result = await _packageController.tryToPurchasePackage(
          //   packageId: data['id'],
          //   referralCode: referalCode,
          // );

          // if (result) {
          //   Get.snackbar(
          //     'Success',
          //     'Package purchased successfully!',
          //     backgroundColor: Colors.green,
          //     colorText: Colors.white,
          //     snackPosition: SnackPosition.BOTTOM,
          //   );
          //   Get.to(PackageView());
          // } else {
          //   Get.snackbar(
          //     'Failed',
          //     'Package purchase failed. Please try again.',
          //     backgroundColor: Colors.red,
          //     colorText: Colors.white,
          //     snackPosition: SnackPosition.BOTTOM,
          //   );
          // }
        } else {
          // Payment failed
          Get.snackbar(
            'Payment Failed',
            'Transaction was unsuccessful. Status: ${transactionResult.status}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        // Log the error and show a user-friendly message
        print('Payment Error: $e');
        Get.snackbar(
          'Error',
          'Payment error: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept the terms and conditions!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
