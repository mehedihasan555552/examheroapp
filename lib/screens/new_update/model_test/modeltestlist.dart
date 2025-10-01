import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../config/constants.dart';
import '../../../update_controllers/banner_controller.dart';
import '../../../widgets/update/exam_start_card.dart';
import '../../inner_screens/screens_parts/inner_page_header.dart';

class ModelTestListView extends StatefulWidget {
  const ModelTestListView({super.key});

  @override
  State<ModelTestListView> createState() => _ModelTestListViewState();
}

class _ModelTestListViewState extends State<ModelTestListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Device responsive detection
  bool get isTablet => MediaQuery.of(context).size.width > 768;
  double get responsivePadding => isTablet ? 24.0 : 16.0;
  double getResponsiveFontSize(double baseFontSize) {
    return isTablet ? baseFontSize * 1.2 : baseFontSize;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    BannerController bannerController = Get.find();

    return Scaffold(
      backgroundColor: Color(0xFF4A90E2),
      body: SafeArea(
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
                child: _buildModelTestList(bannerController),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.all(responsivePadding),
        child: Column(
          children: [
            Row(
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
                      size: isTablet ? 24 : 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Model Test',
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(20),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.quiz_rounded,
                      color: Colors.white,
                      size: isTablet ? 24 : 20,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: responsivePadding),
           
          ],
        ),
      ),
    );
  }

  Widget _buildModelTestList(BannerController bannerController) {
    return Obx(() {
      return FutureBuilder(
        future: bannerController.fetchModelList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasError) {
            return _buildErrorState();
          }

          if (bannerController.modeltestlist.isEmpty) {
            return _buildEmptyState();
          }

          return _buildTestList(bannerController);
        },
      );
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitPulse(
            color: Color(0xFF4A90E2),
            size: isTablet ? 60 : 50,
          ),
          SizedBox(height: responsivePadding),
          Text(
            'Loading model tests...',
            style: TextStyle(
              fontSize: getResponsiveFontSize(16),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(responsivePadding),
        padding: EdgeInsets.all(responsivePadding * 1.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: isTablet ? 80 : 64,
              color: Colors.red[400],
            ),
            SizedBox(height: responsivePadding),
            Text(
              'Error Loading Tests',
              style: TextStyle(
                fontSize: getResponsiveFontSize(18),
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Unable to load model tests. Please try again.',
              style: TextStyle(
                fontSize: getResponsiveFontSize(14),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsivePadding),
            ElevatedButton(
              onPressed: () => setState(() {}),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A90E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(responsivePadding),
        padding: EdgeInsets.all(responsivePadding * 1.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: isTablet ? 80 : 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: responsivePadding),
            Text(
              'No Model Tests Available',
              style: TextStyle(
                fontSize: getResponsiveFontSize(18),
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Model tests will appear here when they\'re available.',
              style: TextStyle(
                fontSize: getResponsiveFontSize(14),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: responsivePadding),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF4A90E2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: Color(0xFF4A90E2),
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Check back soon!',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(12),
                      color: Color(0xFF4A90E2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestList(BannerController bannerController) {
    return Column(
      children: [
        // Header section
        Container(
          padding: EdgeInsets.all(responsivePadding),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF4A90E2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.quiz_rounded,
                  color: Color(0xFF4A90E2),
                  size: isTablet ? 28 : 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Model Tests',
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      '${bannerController.modeltestlist.length} test${bannerController.modeltestlist.length == 1 ? '' : 's'} available',
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(12),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: Colors.green[700],
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Ready',
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(10),
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Test list
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: responsivePadding),
              itemCount: bannerController.modeltestlist.length,
              itemBuilder: (context, index) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      index * 0.1,
                      1.0,
                      curve: Curves.easeOut,
                    ),
                  )),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ExamStartCard(
                      isUpcoming: false,
                      data: bannerController.modeltestlist[index],
                      isLiveExam: false,
                      isModelTest: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
