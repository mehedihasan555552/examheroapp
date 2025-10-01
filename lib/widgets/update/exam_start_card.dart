import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';

import '../../config/constants.dart';
import '../../screens/mcq_preparation/mcq_list_view.dart';
import '../../screens/mcq_preparation/package_view.dart';
import '../../screens/mcq_preparation/ranking_screen.dart';
import '../reusable_widgets.dart';

class ExamStartCard extends StatefulWidget {
  final bool isUpcoming;
  final bool isModelTest;
  final bool isLiveExam;
  final dynamic data;

  ExamStartCard({
    required this.isModelTest,
    required this.isLiveExam,
    required this.data,
    required this.isUpcoming,
  });

  @override
  _ExamStartCardState createState() => _ExamStartCardState();
}

class _ExamStartCardState extends State<ExamStartCard>
    with SingleTickerProviderStateMixin {
  AuthController authController = Get.find();
  Timer? _timer;
  Duration _remainingTime = const Duration();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // Device responsive detection
  bool get isTablet => MediaQuery.of(context).size.width > 768;
  double get responsivePadding => isTablet ? 24.0 : 16.0;
  double getResponsiveFontSize(double baseFontSize) {
    return isTablet ? baseFontSize * 1.2 : baseFontSize;
  }

  // Safe data access
  String safeGetString(String key, {String defaultValue = ''}) {
    try {
      return widget.data[key]?.toString() ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  int safeGetInt(String key, {int defaultValue = 0}) {
    try {
      final value = widget.data[key];
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _startCountdown();
  }

  void _startCountdown() {
    final endDateString = safeGetString('end_datetime');
    if (endDateString.isNotEmpty) {
      try {
        DateTime endDate = DateTime.parse(endDateString);
        _updateRemainingTime(endDate);

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          _updateRemainingTime(endDate);
        });
      } catch (e) {
        setState(() {
          _remainingTime = Duration.zero;
        });
      }
    } else {
      setState(() {
        _remainingTime = Duration.zero;
      });
    }
  }

  void _updateRemainingTime(DateTime endDate) {
    setState(() {
      _remainingTime = endDate.difference(DateTime.now());
      if (_remainingTime.isNegative) {
        _timer?.cancel();
        _remainingTime = Duration.zero;
      }
    });
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = safeGetString('title', defaultValue: 'Untitled Test');
    final marks = safeGetInt('marks');
    final negativeMarks = safeGetString('negative_marks', defaultValue: '0');
    final duration = safeGetInt('duration');

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(title, marks, negativeMarks, duration),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title, int marks, String negativeMarks, int duration) {
    return Container(
      padding: EdgeInsets.all(responsivePadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF7B68EE),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: isTablet ? 60 : 50,
            height: isTablet ? 60 : 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Icon(
                widget.isModelTest 
                    ? Icons.quiz_rounded
                    : widget.isLiveExam 
                        ? Icons.live_tv_rounded
                        : Icons.school_rounded,
                color: Colors.white,
                size: isTablet ? 28 : 24,
              ),
            ),
          ),
          
          SizedBox(width: 16),
          
          // Title and details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getResponsiveFontSize(18),
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(
                      icon: widget.isLiveExam ? Icons.remove_circle_outline : Icons.stars_rounded,
                      text: widget.isLiveExam ? 'Negative: $negativeMarks' : 'Marks: $marks',
                    ),
                    SizedBox(width: 8),
                    _buildInfoChip(
                      icon: Icons.access_time_rounded,
                      text: '${duration}min',
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Status indicator
          _buildStatusIndicator(),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: getResponsiveFontSize(11),
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    if (widget.isUpcoming) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 14,
              color: Colors.orange[700],
            ),
            SizedBox(width: 4),
            Text(
              'Upcoming',
              style: TextStyle(
                fontSize: getResponsiveFontSize(10),
                color: Colors.orange[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else if (widget.isLiveExam && _remainingTime.inSeconds > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.red[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_rounded,
              size: 14,
              color: Colors.red[700],
            ),
            SizedBox(width: 4),
            Text(
              _formatDuration(_remainingTime),
              style: TextStyle(
                fontSize: getResponsiveFontSize(10),
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_outline_rounded,
              size: 14,
              color: Colors.green[700],
            ),
            SizedBox(width: 4),
            Text(
              'Ready',
              style: TextStyle(
                fontSize: getResponsiveFontSize(10),
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(responsivePadding),
      child: Column(
        children: [
          // Primary action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleStartExam,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isUpcoming ? Colors.grey[400] : Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: responsivePadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.isUpcoming 
                        ? Icons.schedule_rounded
                        : Icons.play_arrow_rounded,
                    size: isTablet ? 24 : 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    widget.isUpcoming ? 'Upcoming' : 'Start Exam',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 12),
          
          // Secondary action buttons
          Row(
            children: [
              // Study/Practice button
              if (!widget.isLiveExam) ...[
                Expanded(
                  child: _buildSecondaryButton(
                    icon: Icons.menu_book_rounded,
                    label: 'Study',
                    onPressed: _handleStudyMode,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(width: 12),
              ],
              
              // Ranking button
              Expanded(
                child: _buildSecondaryButton(
                  icon: Icons.leaderboard_rounded,
                  label: 'Ranking',
                  onPressed: _handleRanking,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
        elevation: 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isTablet ? 20 : 16),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: getResponsiveFontSize(12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _handleStartExam() {
    if (widget.isUpcoming) {
      _showUpcomingDialog();
    } else {
      if (widget.isModelTest) {
        Get.to(() => MCQListView(
              isStartExam: true,
              isSubjectWise: true,
              testId: 0,
              mcqTest: widget.data,
            ));
      } else {
        _checkPackageAndNavigate(
          () => MCQListView(
            isStartExam: true,
            isSubjectWise: true,
            testId: 0,
            mcqTest: widget.data,
          ),
        );
      }
    }
  }

  void _handleStudyMode() {
    if (widget.isModelTest) {
      Get.to(() => MCQListView(
            isStartExam: false,
            isSubjectWise: false,
            testId: 0,
            mcqTest: widget.data,
          ));
    } else {
      _checkPackageAndNavigate(
        () => MCQListView(
          isStartExam: false,
          isSubjectWise: false,
          testId: 0,
          mcqTest: widget.data,
        ),
      );
    }
  }

  void _handleRanking() {
    Get.to(() => RankingScreen(
          isSubjectWise: true,
          mcqTest: widget.data,
        ));
  }

  void _checkPackageAndNavigate(Widget Function() navigationWidget) {
    try {
      final packageValue = authController.profile.value.package?.toString();
      if (packageValue == null || int.tryParse(packageValue) == null) {
        _showPremiumDialog();
      } else {
        Get.to(navigationWidget);
      }
    } catch (e) {
      _showPremiumDialog();
    }
  }

  void _showUpcomingDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(responsivePadding * 1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.orange[100]!, Colors.orange[50]!],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule_rounded,
                size: isTablet ? 60 : 48,
                color: Colors.orange[700],
              ),
              SizedBox(height: responsivePadding),
              Text(
                'Exam Not Started Yet',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please wait until the exam starts. You\'ll be notified when it\'s available.',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(14),
                  color: Colors.orange[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsivePadding),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Got It',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPremiumDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(responsivePadding * 1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.amber[100]!, Colors.amber[50]!],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium_rounded,
                size: isTablet ? 60 : 48,
                color: Colors.amber[700],
              ),
              SizedBox(height: responsivePadding),
              Text(
                'Premium Feature',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'To access this exam, you need to purchase a premium package.',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(14),
                  color: Colors.amber[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsivePadding),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        side: BorderSide(color: Colors.grey[400]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.to(() => PackageView(), fullscreenDialog: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Upgrade',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
