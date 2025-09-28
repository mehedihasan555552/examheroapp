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

class PackageViewController extends GetxController {
  final selectedPackageIndex = 0.obs;
  final isTermsAccepted = false.obs;
  
  void selectPackage(int index) {
    selectedPackageIndex.value = index;
  }
  
  void toggleTermsAcceptance() {
    isTermsAccepted.value = !isTermsAccepted.value;
  }
}

class PackageView extends StatefulWidget {
  @override
  _PackageViewState createState() => _PackageViewState();
}

class _PackageViewState extends State<PackageView> {
  final BannerController bannerController = Get.find();
  final PackageController _packageController = Get.put(PackageController());
  final AuthController _authController = Get.find();
  final PackageViewController _controller = Get.put(PackageViewController());
  final TextEditingController _editingControllerReferalCode = TextEditingController();

  YoutubePlayerController? _youtubeController;

  // Package data
  final List<Map<String, dynamic>> packages = [
    {
      'title': '৩ মাসের প্যাকেজ',
      'subtitle': 'Basic Course Access',
      'price': 400,
      'discount': 10,
      'color': Colors.orange,
      'icon': Icons.access_time_rounded,
      'duration': 3,
      'popular': false,
    },
    {
      'title': '৬ মাসের প্যাকেজ',
      'subtitle': 'Standard Course Access',
      'price': 600,
      'discount': 20,
      'color': Color(0xFF4A90E2),
      'icon': Icons.star_rounded,
      'duration': 6,
      'popular': true,
      'features': [
        'Priority Support',
        'Premium Content',
        'All Device Access',
      ],
    },
    {
      'title': '১২ মাসের প্যাকেজ',
      'subtitle': 'Premium Course Access',
      'price': 1200,
      'discount': 30,
      'color': Colors.green,
      'icon': Icons.diamond_rounded,
      'duration': 12,
      'popular': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeYouTubePlayer();
  }

  void _initializeYouTubePlayer() {
    try {
      final videoUrl = bannerController.packageDetails['video_url'];
      if (videoUrl != null && videoUrl.toString().isNotEmpty) {
        final videoId = YoutubePlayer.convertUrlToId(videoUrl.toString());
        if (videoId != null) {
          _youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          );
        }
      }
    } catch (e) {
      print('Error initializing YouTube player: $e');
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _editingControllerReferalCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4A90E2),
      body: SafeArea(
        child: GetX<PackageController>(
          builder: (packageController) {
            return LoadingOverlay(
              isLoading: packageController.loadingOnPurchase.value,
              progressIndicator: SpinKitPulse(
                color: Colors.white,
                size: 50.0,
              ),
              child: Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              _buildVideoSection(),
                              const SizedBox(height: 20),
                              _buildCourseDetailsButton(),
                              const SizedBox(height: 20),
                              _buildPackageSelectionTitle(),
                              const SizedBox(height: 16),
                              _buildPackagesList(),
                              const SizedBox(height: 24),
                              _buildSelectedPackagePrice(),
                              const SizedBox(height: 20),
                              _buildPromoCodeSection(),
                              const SizedBox(height: 20),
                              _buildTermsAndConditions(),
                              const SizedBox(height: 24),
                              _buildPurchaseButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Text(
            'Purchase\nPackage',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _youtubeController != null
            ? YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Color(0xFF4A90E2),
                aspectRatio: 16 / 9,
              )
            : Container(
                height: 200,
                color: Colors.black,
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCourseDetailsButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFF4A90E2).withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Color(0xFF4A90E2).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          final description = bannerController.packageDetails['description'];
          if (description != null) {
            Get.defaultDialog(
              title: 'Course Description',
              titleStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A90E2),
              ),
              content: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  description.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              confirm: TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Color(0xFF4A90E2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF4A90E2),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Course Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A90E2),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF4A90E2),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPackageSelectionTitle() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: Color(0xFF4A90E2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Choose Your Package',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPackagesList() {
    return GetX<PackageViewController>(
      builder: (controller) {
        return Column(
          children: packages.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> package = entry.value;
            return _buildPackageCard(package, index, controller);
          }).toList(),
        );
      },
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> package, int index, PackageViewController controller) {
    final bool isSelected = controller.selectedPackageIndex.value == index;
    final bool isPopular = package['popular'] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? package['color'] : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: package['color'].withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ] : [],
      ),
      child: InkWell(
        onTap: () => controller.selectPackage(index),
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected 
                    ? package['color'].withOpacity(0.1) 
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: package['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      package['icon'],
                      color: package['color'],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          package['subtitle'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '৳${package['price']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: package['color'],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: package['color'].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${package['discount']}% OFF',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: package['color'],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (package['features'] != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Features:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: package['color'],
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...package['features'].map<Widget>((feature) => 
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: package['color'],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    feature,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).toList(),
                        ],
                      ],
                    ),
                  ),
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
                        ? Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ],
              ),
            ),
            if (isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: package['color'],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'POPULAR',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPackagePrice() {
    return GetX<PackageViewController>(
      builder: (controller) {
        final selectedPackage = packages[controller.selectedPackageIndex.value];
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green[200]!, width: 2),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_offer_rounded,
                    color: Colors.green[600],
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Total Price',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${selectedPackage['price']} ৳',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              Text(
                'for ${selectedPackage['duration']} months',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromoCodeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                color: Color(0xFF4A90E2),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Have a Promo Code?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _editingControllerReferalCode,
                  decoration: InputDecoration(
                    hintText: 'Enter your promo...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final code = _editingControllerReferalCode.text.trim();
                    if (code.isNotEmpty) {
                      bannerController.checkPromo(code: code);
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please enter a promo code',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return GetX<PackageViewController>(
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF4A90E2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF4A90E2).withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.isTermsAccepted.value ? Color(0xFF4A90E2) : Colors.grey[400]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  color: controller.isTermsAccepted.value ? Color(0xFF4A90E2) : Colors.transparent,
                ),
                child: InkWell(
                  onTap: () => controller.toggleTermsAcceptance(),
                  child: controller.isTermsAccepted.value
                      ? Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 14,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Navigate to Terms & Conditions
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4A90E2),
                      ),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms & Conditions, Privacy Policy, Refund Policy, and About App.',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPurchaseButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF7B68EE),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4A90E2).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handlePurchase,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_rounded, size: 24, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Purchase Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePurchase() async {
    if (!_controller.isTermsAccepted.value) {
      Get.snackbar(
        'Error',
        'Please agree to Terms & Conditions before proceeding',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_packageController.loadingOnPurchase.value) return;

    FocusScope.of(context).unfocus();

    final selectedPackage = packages[_controller.selectedPackageIndex.value];
    String referalCode = _editingControllerReferalCode.text.trim();

    // Check if the referral code is the user's own referral code
    if (referalCode.isNotEmpty && referalCode == _authController.profile.value.referral_code) {
      Get.snackbar(
        'Error',
        "Cannot use your own referral code during package purchase",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Call SSLCommerz Payment
      Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          multi_card_name: "visa,master,bkash",
          currency: SSLCurrencyType.BDT,
          product_category: "Study",
          sdkType: SSLCSdkType.TESTBOX, // Change to LIVE for production
          store_id: "prepm6770cd934cda9",
          store_passwd: "prepm6770cd934cda9@ssl",
          total_amount: selectedPackage['price'].toDouble(),
          tran_id: "custom_transaction_id_${DateTime.now().millisecondsSinceEpoch}",
        ),
      );

      var transactionResult = await sslcommerz.payNow();

      if (transactionResult is SSLCTransactionInfoModel) {
        if (transactionResult.status == "VALID") {
          Get.snackbar(
            'Success',
            'Payment successful! Package purchased.',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          
          // Navigate back or refresh
          Get.back();
        } else {
          Get.snackbar(
            'Payment Failed',
            'Transaction was unsuccessful. Status: ${transactionResult.status}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Payment Error',
          'Unexpected response received. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Payment Error: $e');
      Get.snackbar(
        'Error',
        'Payment processing failed. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
