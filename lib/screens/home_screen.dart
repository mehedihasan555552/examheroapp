import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/screens/chat/chat_list_view.dart';
import 'package:mission_dmc/screens/menu_screen.dart';
import 'package:mission_dmc/screens/new_update/routine.dart';
import 'package:mission_dmc/screens/profile/profile_screen.dart';
import 'package:mission_dmc/screens/screen_parts/archive.dart';
import 'package:mission_dmc/screens/screen_parts/home_page_full.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/screens/screen_parts/live_exam.dart';
import 'package:mission_dmc/screens/screen_parts/pdfLIst.dart';
import 'package:mission_dmc/screens/screen_parts/upcoming.dart';
import '../controllers/auth_controller.dart';
import '../update_controllers/banner_controller.dart';
import '../widgets/IconLargeButtonWithText.dart';
import '../widgets/icon_button_with_text.dart';
import 'mcq_preparation/mcq_test.dart';
import 'mcq_preparation/package_view.dart';
import 'mcq_preparation/performace_screen.dart';
import 'new_update/bookmarkslist.dart';
import 'new_update/live_exam.dart';
import 'new_update/model_test/modeltestlist.dart';
import 'mcq_preparation/board_cqs.dart';
import 'mcq_preparation/board_mcqs.dart';

import 'package:mission_dmc/screens/chat/chat_list_view.dart';


class HomeScreen extends StatefulWidget {
  static const id = "home_screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = Get.find();
  final bannerController = Get.put(BannerController());
  
  int currentIndex = 0; // This will control the bottom navigation

  @override
  void initState() {
    bannerController.fetchLiveExamList();
    super.initState();
  }

  // Method to handle bottom navigation tap
  void _onBottomNavTap(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0: // Home
        // Already on home screen, no navigation needed
        break;
      case 1: // Package
        if (int.tryParse(_authController.profile.value.package.toString()) != null) {
          Get.defaultDialog(
            title: 'Notice',
            middleText: 'You have already purchased this package.',
            textConfirm: 'OK',
            onConfirm: () {
              Get.back();
            },
            confirmTextColor: Colors.white,
          );
        } else {
          Get.to(PackageView());
        }
        break;
      case 2: // Teacher Panel
        // Navigate to teacher panel (replace with your teacher panel screen)
        // Get.to(() => TeacherPanelScreen());
        Get.snackbar('Coming Soon', 'Teacher Panel will be available soon!');
        break;
      case 3: // Live Chat
        Get.to(ChatListView());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get proper MediaQuery data
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final padding = mediaQuery.padding;
    final viewInsets = mediaQuery.viewInsets;
    
    // Calculate responsive dimensions
    final screenWidth = size.width;
    final screenHeight = size.height;
    final isSmallDevice = screenHeight < 700;
    final isVerySmallDevice = screenHeight < 600;
    
    // Calculate proper bottom padding
    final systemBottomPadding = padding.bottom;
    final keyboardHeight = viewInsets.bottom;
    final bottomNavHeight = kBottomNavigationBarHeight + 40; // Include rounded corners
    
    // Add extra padding for small devices to prevent overlap
    final extraBottomPadding = isVerySmallDevice ? 50.0 : (isSmallDevice ? 35.0 : 25.0);
    final totalBottomPadding = bottomNavHeight + systemBottomPadding + keyboardHeight + extraBottomPadding;
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Light background
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * (isSmallDevice ? 0.16 : 0.188)),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                  Color(0xFFEC4899),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * (isSmallDevice ? 0.01 : 0.015)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back! 👋',
                              style: TextStyle(
                                fontSize: screenWidth * (isSmallDevice ? 0.032 : 0.035),
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 4),
                            Obx(() {
                              String userClass = _authController.profile.value.student_class?.toUpperCase() ?? 'বিজ্ঞান';
                              String userDepartment = _authController.profile.value.department?.toUpperCase() ?? 'এইচএসসি';
                              String title = 'ExamHero';
                              return Text(
                                "$title | $userClass | $userDepartment",
                                style: TextStyle(
                                  fontSize: screenWidth * (isSmallDevice ? 0.035 : 0.045),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            size: screenWidth * (isSmallDevice ? 0.06 : 0.07),
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * (isSmallDevice ? 0.008 : 0.004)),
                Center(
                  child: Container(
                    width: size.width * .9,
                    // --- Smaller height ---
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.008, // less horizontal padding
                      vertical: screenWidth * 0.007, // much less vertical padding!
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18), // slightly smaller radius for compactness
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _buildTopActionButton(
                            onPressed: () {
                              if (int.tryParse(_authController.profile.value.package.toString()) != null) {
                                Get.defaultDialog(
                                  title: 'Notice',
                                  middleText: 'You have already purchased this package.',
                                  textConfirm: 'OK',
                                  onConfirm: () {
                                    Get.back();
                                  },
                                  confirmTextColor: Colors.white,
                                );
                              } else {
                                Get.to(PackageView());
                              }
                            },
                            text: 'Course',
                            icon: Icons.school,
                            color: Colors.blue,
                            screenWidth: screenWidth,
                            isSmallDevice: isSmallDevice,
                            // next argument doesn't exist by default but will be ignored.
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.006), // less spacing
                        Expanded(
                          child: _buildTopActionButton(
                            onPressed: () {
                              Get.to(() => ProfileScreen(userId: _authController.profile.value.user!.uid!));
                            },
                            text: 'Profile',
                            icon: Icons.person,
                            color: Colors.green,
                            screenWidth: screenWidth,
                            isSmallDevice: isSmallDevice,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.006), // less spacing
                        Expanded(
                          child: _buildTopActionButton(
                            onPressed: () {
                              Get.to(() => PerformanceScreen(), fullscreenDialog: true);
                            },
                            text: 'Performance',
                            icon: Icons.analytics,
                            color: Colors.orange,
                            screenWidth: screenWidth,
                            isSmallDevice: isSmallDevice,
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
        
        // Body with proper bottom padding
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: totalBottomPadding, // THIS IS THE KEY FIX
          ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * (isSmallDevice ? 0.015 : 0.02)),
              
              // Board MCQ Section with enhanced design
              _buildSectionContainer(
                title: "বোর্ড MCQ প্রশ্ন",
                icon: Icons.quiz,
                screenWidth: screenWidth,
                isSmallDevice: isSmallDevice,
                child: SizedBox(
                  height: screenHeight * (isSmallDevice ? 0.45 : 0.55),
                  child: BoardMCQListView(
                    categoryData: {
                      'title': 'বোর্ড MCQ',
                      'id': 'board_mcqs'
                    },
                  ),
                ),
              ),

              SizedBox(height: screenHeight * (isSmallDevice ? 0.015 : 0.02)),

              // Board CQ Section with enhanced design
              _buildSectionContainer(
                title: "বোর্ড CQ প্রশ্ন",
                icon: Icons.article,
                screenWidth: screenWidth,
                isSmallDevice: isSmallDevice,
                child: SizedBox(
                  height: screenHeight * (isSmallDevice ? 0.45 : 0.55),
                  child: FilteredExamListView(
                    categoryData: {
                      'title': 'বোর্ড CQ',
                      'id': 'board_cqs'
                    },
                  ),
                ),
              ),

              SizedBox(height: screenHeight * (isSmallDevice ? 0.015 : 0.02)),

              // Enhanced LIVE section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Obx(() => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03,
                                    vertical: screenWidth * 0.015,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: bannerController.liveExamList.isEmpty 
                                          ? [Colors.grey, Colors.grey[600]!]
                                          : [Colors.red, Colors.redAccent],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (bannerController.liveExamList.isEmpty ? Colors.grey : Colors.red).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'LIVE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * (isSmallDevice ? 0.025 : 0.03),
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                'Live Exams Available',
                                style: TextStyle(
                                  fontSize: screenWidth * (isSmallDevice ? 0.035 : 0.04),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => LiveExamView());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenWidth * 0.015,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.blue.withOpacity(0.3)),
                          ),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: screenWidth * (isSmallDevice ? 0.025 : 0.03),
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * (isSmallDevice ? 0.015 : 0.02)),

              // Enhanced Banner Carousel
              GestureDetector(
                onTap: () {
                  Get.to(() => LiveExamm(bannerController: bannerController));
                },
                child: FutureBuilder(
                  future: bannerController.fetchTopBannerList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingBanner(screenWidth, screenHeight, isSmallDevice);
                    } else if (snapshot.hasError) {
                      return _buildErrorBanner(screenWidth, screenHeight, isSmallDevice);
                    } else {
                      return Obx(() {
                        if (bannerController.topBannerList.isEmpty) {
                          return _buildEmptyBanner(screenWidth, screenHeight, isSmallDevice);
                        }
                        return _buildBannerCarousel(screenWidth, screenHeight, isSmallDevice);
                      });
                    }
                  },
                ),
              ),

              SizedBox(height: screenHeight * (isSmallDevice ? 0.015 : 0.02)),

              // Enhanced Package section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Container(
                  height: screenHeight * (isSmallDevice ? 0.1 : 0.12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF667eea),
                        Color(0xFF764ba2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF667eea).withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative elements
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -30,
                        bottom: -30,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: EdgeInsets.all(screenWidth * 0.03), // Reduced from 0.05 to 0.03
                        child: Row(
                          children: [
                            Container(
                              width: screenWidth * (isSmallDevice ? 0.08 : 0.1), // Reduced from 0.12/0.15 to 0.08/0.1
                              height: screenWidth * (isSmallDevice ? 0.08 : 0.1), // Reduced from 0.12/0.15 to 0.08/0.1
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10), // Reduced from 15 to 10
                              ),
                              child: Icon(
                                Icons.workspace_premium,
                                color: Colors.white,
                                size: screenWidth * (isSmallDevice ? 0.04 : 0.05), // Reduced from 0.06/0.075 to 0.04/0.05
                              ),
                            ),
                            SizedBox(width: 12), // Same spacing
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Unlock Premium Package',
                                    style: TextStyle(
                                      fontSize: screenWidth * (isSmallDevice ? 0.028 : 0.032), // Reduced from 0.035/0.04 to 0.028/0.032
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2), // Reduced from 4 to 2
                                  Text(
                                    'Get full access to all features',
                                    style: TextStyle(
                                      fontSize: screenWidth * (isSmallDevice ? 0.02 : 0.024), // Reduced from 0.025/0.03 to 0.02/0.024
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => PackageView(), fullscreenDialog: true);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * (isSmallDevice ? 0.03 : 0.035), // Reduced from 0.04/0.05 to 0.03/0.035
                                  vertical: screenWidth * 0.015, // Reduced from 0.02 to 0.015
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15), // Reduced from 20 to 15
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08), // Reduced from 0.1 to 0.08
                                      blurRadius: 4, // Reduced from 5 to 4
                                      offset: Offset(0, 1), // Reduced from (0, 2) to (0, 1)
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "Get Package",
                                  style: TextStyle(
                                    color: Color(0xFF667eea),
                                    fontSize: screenWidth * (isSmallDevice ? 0.02 : 0.024), // Reduced from 0.025/0.03 to 0.02/0.024
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * (isSmallDevice ? 0.015 : 0.02)),

              // Enhanced Features grid section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Study Features',
                      style: TextStyle(
                        fontSize: screenWidth * (isSmallDevice ? 0.045 : 0.05),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    
                    // First Row - Chapter Test & Batch MCQ
                    Row(
                      children: [
                        Expanded(
                          child: _buildFeatureCard(
                            onTap: () {
                              // Navigate to Chapter Test
                              // Get.to(() => ChapterTestView());
                            },
                            title: 'অধ্যায়ের পরীক্ষা',
                            subtitle: 'বই → অধ্যায়ের সিলেক্ট করে\nপরীক্ষা দিন',
                            icon: Icons.book_outlined,
                            color: Colors.blue,
                            screenWidth: screenWidth,
                            isSmallDevice: isSmallDevice,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildFeatureCard(
                            onTap: () {
                              // Navigate to Batch MCQ
                              // Get.to(() => BatchMCQView());
                            },
                            title: 'ব্যাচ MCQ',
                            subtitle: 'বই → ব্যাচ → সাল সিলেক্ট\nকরে পরীক্ষা দিন',
                            icon: Icons.groups_outlined,
                            color: Colors.green,
                            screenWidth: screenWidth,
                            isSmallDevice: isSmallDevice,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    
                    // Second Row - Batch CQ & Live MCQ
                    Row(
                      children: [
                        Expanded(
                          child: _buildFeatureCard(
                            onTap: () {
                              // Navigate to Batch CQ
                              // Get.to(() => BatchCQView());
                            },
                            title: 'ব্যাচ CQ',
                            subtitle: 'বই → অধ্যায় → ব্যাচ → সাল\nসিলেক্ট করে লেখা',
                            icon: Icons.edit_outlined,
                            color: Colors.purple,
                            screenWidth: screenWidth,
                            isSmallDevice: isSmallDevice,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildFeatureCard(
                            onTap: () {
                              // Navigate to Live MCQ
                              // Get.to(() => LiveMCQView());
                            },
                            title: 'লাইভ MCQ',
                            subtitle: 'লাইভ পরীক্ষা নিন\nUpcoming/Archive দেখুন',
                            icon: Icons.live_tv_outlined,
                            color: Colors.red,
                            screenWidth: screenWidth,
                            isSmallDevice: isSmallDevice,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    
                    // Third Row - PDF & Bookmark
                    Row(
                      children: [
                        Expanded(
                          child: _buildFeatureCard(
                            onTap: () {
                              bannerController.fetchFreePdfLists();
                              bannerController.fetchPaidPdfLists();
                              Get.to(() => PdfListPageView(
                                bannerController: bannerController,
                                authController: _authController,
                              ));
                            },
                            title: 'PDF',
                            subtitle: 'ফ্রি ও পেইড বইয়ের\nPDF পড়ুন',
                            icon: Icons.picture_as_pdf_outlined,
                            color: Colors.orange,
                            screenWidth: screenWidth,
                            isSmallDevice: isSmallDevice,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildFeatureCard(
                            onTap: () => Get.to(const BookMarksView()),
                            title: 'Bookmark',
                            subtitle: 'মার্ক করা MCQ\nগুলো দেখুন',
                            icon: Icons.bookmark_outline,
                            color: Colors.teal,
                            screenWidth: screenWidth,
                            isSmallDevice: isSmallDevice,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    
                    // Original features (if you want to keep them)
                    Row(
                      children: [
                        Expanded(
                          child: _buildFeatureCard(
                            onTap: () => Get.to(() => ModelTestListView()),
                            title: 'Model Test',
                            subtitle: 'Medical standard\nQuestions(100 marks)',
                            icon: Icons.quiz,
                            color: Colors.indigo,
                            screenWidth: screenWidth,
                            isSmallDevice: isSmallDevice,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildFeatureCard(
                            onTap: () => Navigator.pushNamed(context, MCQTest.id),
                            title: 'MCQ Preparation',
                            subtitle: 'Medical & University\nQuestion bank',
                            icon: Icons.help_outline,
                            color: Colors.pink,
                            screenWidth: screenWidth,
                            isSmallDevice: isSmallDevice,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                ),
              ),

              // NO MORE SIZED BOX HERE - THE PADDING HANDLES IT
            ],
          ),
        ),

        // Enhanced Bottom Navigation Bar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, -5),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: _onBottomNavTap,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: kPrimaryColor,
              unselectedItemColor: Colors.grey[400],
              selectedFontSize: screenWidth * (isSmallDevice ? 0.025 : 0.03),
              unselectedFontSize: screenWidth * (isSmallDevice ? 0.02 : 0.025),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(screenWidth * 0.015),
                    decoration: currentIndex == 0 ? BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ) : null,
                    child: Icon(Icons.home_rounded, size: screenWidth * (isSmallDevice ? 0.055 : 0.06)),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(screenWidth * 0.015),
                    decoration: currentIndex == 1 ? BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ) : null,
                    child: Icon(Icons.workspace_premium_rounded, size: screenWidth * (isSmallDevice ? 0.055 : 0.06)),
                  ),
                  label: 'Package',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(screenWidth * 0.015),
                    decoration: currentIndex == 2 ? BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ) : null,
                    child: Icon(Icons.school_rounded, size: screenWidth * (isSmallDevice ? 0.055 : 0.06)),
                  ),
                  label: 'Teacher Panel',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: EdgeInsets.all(screenWidth * 0.015),
                    decoration: currentIndex == 3 ? BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ) : null,
                    child: Icon(Icons.chat_rounded, size: screenWidth * (isSmallDevice ? 0.055 : 0.06)),
                  ),
                  label: 'Live Chat',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build top action buttons
  Widget _buildTopActionButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
    required Color color,
    required double screenWidth,
    required bool isSmallDevice,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * (isSmallDevice ? 0.01 : 0.012), // much less vertical padding
          horizontal: screenWidth * 0.01, // less horizontal padding
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10), // even smaller corner radius
          border: Border.all(color: color.withOpacity(0.18), width: 0.8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: screenWidth * (isSmallDevice ? 0.038 : 0.045), // smaller icon!
            ),
            SizedBox(height: screenWidth * 0.002), // less space
            Text(
              text,
              style: TextStyle(
                fontSize: screenWidth * (isSmallDevice ? 0.018 : 0.02), // smaller font size!
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }


  // Helper method to build section containers
  Widget _buildSectionContainer({
    required String title,
    required IconData icon,
    required Widget child,
    required double screenWidth,
    required bool isSmallDevice,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * (isSmallDevice ? 0.04 : 0.05)),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: kPrimaryColor, size: screenWidth * (isSmallDevice ? 0.04 : 0.05)),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * (isSmallDevice ? 0.04 : 0.045),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  // Helper method to build feature cards
  Widget _buildFeatureCard({
    required VoidCallback onTap,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double screenWidth,
    required bool isSmallDevice,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenWidth * (isSmallDevice ? 0.25 : 0.3),
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.8),
              color,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: screenWidth * (isSmallDevice ? 0.05 : 0.06)),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * (isSmallDevice ? 0.03 : 0.035),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Expanded(
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: screenWidth * (isSmallDevice ? 0.022 : 0.025),
                  color: Colors.white.withOpacity(0.8),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for banner states
  Widget _buildLoadingBanner(double screenWidth, double screenHeight, bool isSmallDevice) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      height: screenHeight * (isSmallDevice ? 0.12 : 0.15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: CircularProgressIndicator(color: kPrimaryColor),
      ),
    );
  }

  Widget _buildErrorBanner(double screenWidth, double screenHeight, bool isSmallDevice) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      height: screenHeight * (isSmallDevice ? 0.12 : 0.15),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: screenWidth * (isSmallDevice ? 0.06 : 0.08)),
            SizedBox(height: 8),
            Text(
              "Failed to load banners",
              style: TextStyle(fontSize: screenWidth * (isSmallDevice ? 0.03 : 0.035), color: Colors.red[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyBanner(double screenWidth, double screenHeight, bool isSmallDevice) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      height: screenHeight * (isSmallDevice ? 0.12 : 0.15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: screenWidth * (isSmallDevice ? 0.06 : 0.08)),
            SizedBox(height: 8),
            Text(
              "No banners available",
              style: TextStyle(fontSize: screenWidth * (isSmallDevice ? 0.03 : 0.035), color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(double screenWidth, double screenHeight, bool isSmallDevice) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: bannerController.topBannerList.length,
            options: CarouselOptions(
              height: screenHeight * (isSmallDevice ? 0.12 : 0.15),
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 4),
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                bannerController.currentIndexTop.value = index;
              },
            ),
            itemBuilder: (context, index, realIdx) {
              final banner = bannerController.topBannerList[index];
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: banner['banner'] != null && banner['banner'].isNotEmpty
                      ? Image.network(
                          banner['banner'],
                          fit: BoxFit.cover,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purple, Colors.blue],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'No Banner Available',
                              style: TextStyle(
                                fontSize: screenWidth * (isSmallDevice ? 0.035 : 0.04),
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
          SizedBox(height: 12),
          // Enhanced Dot Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              bannerController.topBannerList.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: bannerController.currentIndexTop.value == index ? 24.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: bannerController.currentIndexTop.value == index 
                      ? kPrimaryColor
                      : Colors.grey.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomGradientButton extends StatelessWidget {
  final String text;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const CustomGradientButton({
    super.key, 
    required this.text,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = MediaQuery.of(context).size.height < 700;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.24,
        height: screenWidth * (isSmallDevice ? 0.08 : 0.1),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * (isSmallDevice ? 0.03 : 0.035),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
