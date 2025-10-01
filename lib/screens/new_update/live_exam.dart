import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/update_controllers/banner_controller.dart';
import '../../config/constants.dart';
import '../../widgets/update/exam_start_card.dart';
import '../inner_screens/screens_parts/inner_page_header.dart';

class LiveExamView extends StatefulWidget {
  const LiveExamView({super.key});

  @override
  State<LiveExamView> createState() => _LiveExamViewState();
}

class _LiveExamViewState extends State<LiveExamView>
    with TickerProviderStateMixin {
  BannerController bannerController = Get.find();
  final RxInt currentIndex = 0.obs;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late TabController _tabController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> tabTitles = ['Live Exam', 'Upcoming Exams', 'Archived Exams'];
  final List<IconData> tabIcons = [
    Icons.live_tv_rounded,
    Icons.schedule_rounded,
    Icons.archive_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        currentIndex.value = _tabController.index;
      }
    });
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildModernHeader(size),
            _buildTabBarSection(isTablet),
            _buildTabBarView(isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(Size size) {
    return Container(
      height: size.height * 0.25,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
            Theme.of(context).colorScheme.secondary.withOpacity(0.6),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
          bottomRight: Radius.circular(32.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/final_top_bar.png"),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32.0),
            bottomRight: Radius.circular(32.0),
          ),
        ),
        child: Stack(
          children: [
            // Back Button
            Positioned(
              top: 12,
              left: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            // Dynamic Header Content
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Obx(() => _buildDynamicHeader()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              tabIcons[currentIndex.value],
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tabTitles[currentIndex.value],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getSubtitle(currentIndex.value),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSubtitle(int index) {
    switch (index) {
      case 0:
        return 'Active Examinations';
      case 1:
        return 'Scheduled Tests';
      case 2:
        return 'Past Examinations';
      default:
        return 'Examinations';
    }
  }

  Widget _buildTabBarSection(bool isTablet) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: TabBar(
          controller: _tabController,
          onTap: (index) {
            currentIndex.value = index;
          },
          labelColor: Colors.white,
          unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
          labelStyle: TextStyle(
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w500,
          ),
          indicator: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          indicatorPadding: const EdgeInsets.all(4),
          dividerColor: Colors.transparent,
          tabs: tabTitles.asMap().entries.map((entry) {
            int index = entry.key;
            String title = entry.value;
            return Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tabIcons[index],
                      size: 18,
                    ),
                    if (!isTablet) const SizedBox(width: 4),
                    if (isTablet) const SizedBox(width: 8),
                    if (isTablet)
                      Text(title)
                    else
                      Text(
                        _getShortTitle(title),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getShortTitle(String title) {
    switch (title) {
      case 'Live Exam':
        return 'Live';
      case 'Upcoming Exams':
        return 'Upcoming';
      case 'Archived Exams':
        return 'Archive';
      default:
        return title;
    }
  }

  Widget _buildTabBarView(bool isTablet) {
    return Expanded(
      child: SlideTransition(
        position: _slideAnimation,
        child: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            _buildExamList(
              examList: bannerController.liveExamList,
              isUpcoming: false,
              emptyMessage: 'No live exams available',
              emptyIcon: Icons.tv_off_outlined, // Fixed: Changed from live_tv_off_outlined
              isTablet: isTablet,
            ),
            _buildExamList(
              examList: bannerController.upcomingExamList,
              isUpcoming: true,
              emptyMessage: 'No upcoming exams scheduled',
              emptyIcon: Icons.event_busy_outlined, // Fixed: Changed from schedule_outlined
              isTablet: isTablet,
            ),
            _buildExamList(
              examList: bannerController.archiveExamList,
              isUpcoming: false,
              emptyMessage: 'No archived exams found',
              emptyIcon: Icons.folder_open_outlined, // Fixed: Changed from archive_outlined
              isTablet: isTablet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamList({
    required RxList<dynamic> examList,
    required bool isUpcoming,
    required String emptyMessage,
    required IconData emptyIcon,
    required bool isTablet,
  }) {
    return Obx(() {
      if (examList.isEmpty) {
        return _buildEmptyState(emptyMessage, emptyIcon);
      }

      return RefreshIndicator(
        onRefresh: () async {
          // Add refresh logic here
          await Future.delayed(const Duration(seconds: 1));
        },
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: examList.length,
            itemBuilder: (context, index) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 400 + (index * 150)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ExamStartCard(
                          isUpcoming: isUpcoming,
                          data: examList[index],
                          isLiveExam: true,
                          isModelTest: false,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 80,
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Content Available',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh,
                      size: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pull to refresh',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
