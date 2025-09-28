import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/controllers/mcq_preparation_controller.dart';
import 'package:mission_dmc/screens/mcq_preparation/answered_paper_screen.dart';
import 'package:mission_dmc/screens/mcq_preparation/ranking_screen.dart';
import 'package:mission_dmc/screens/mcq_preparation/result_screen.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class PerformanceScreen extends GetView {
  static const id = 'performance_screen';

  PerformanceScreen({Key? key}) : super(key: key);
  
  final AuthController _authController = Get.find();
  final MCQPreparationController _mcqPreparationController = Get.put(MCQPreparationController());

  // Device type detection for responsive design
  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width > 768;
  bool isMobile(BuildContext context) => MediaQuery.of(context).size.width <= 768;

  // Responsive dimensions
  double getResponsivePadding(BuildContext context) {
    return isTablet(context) ? 24.0 : 16.0;
  }

  double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    return isTablet(context) ? baseFontSize * 1.2 : baseFontSize;
  }

  // Safe parsing utility
  double safeParseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed ?? defaultValue;
    }
    return defaultValue;
  }

  int safeParseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed ?? defaultValue;
    }
    return defaultValue;
  }

  @override
  Widget build(BuildContext context) {
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
                child: FutureBuilder(
                  future: _mcqPreparationController.fetchMyPerformace(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingState(context);
                    }

                    if (snapshot.hasError) {
                      return _buildErrorState(context);
                    }

                    if (snapshot.hasData) {
                      final data = snapshot.data as dynamic;
                      return _performanceWidget(data: data, context: context);
                    }

                    return _buildEmptyState(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getResponsivePadding(context)),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: isTablet(context) ? 28 : 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Performance',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: isTablet(context) ? 56 : 48), // Balance the layout
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitPulse(
            color: Color(0xFF4A90E2),
            size: isTablet(context) ? 60 : 50,
          ),
          SizedBox(height: getResponsivePadding(context)),
          Text(
            'Loading performance data...',
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, 16),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: isTablet(context) ? 80 : 64,
            color: Colors.red[400],
          ),
          SizedBox(height: getResponsivePadding(context)),
          Text(
            'Error loading performance',
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, 14),
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: isTablet(context) ? 80 : 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: getResponsivePadding(context)),
          Text(
            'No performance data available',
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _performanceWidget({required dynamic data, required BuildContext context}) {
    final myExamsCount = safeParseInt(data['my_exams_count']);
    
    if (myExamsCount == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: isTablet(context) ? 80 : 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: getResponsivePadding(context)),
            Text(
              "You haven't participated in any exam yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, 16),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: getResponsivePadding(context)),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A90E2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Start Taking Exams',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(getResponsivePadding(context)),
        child: Column(
          children: [
            _buildOverallPerformanceCard(data, context),
            SizedBox(height: getResponsivePadding(context)),
            _buildStatisticsGrid(data, context),
            SizedBox(height: getResponsivePadding(context) * 1.5),
            _buildExamHistorySection(data, context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallPerformanceCard(dynamic data, BuildContext context) {
    final accuracy = safeParseDouble(data['accuracy']);
    
    return Container(
      padding: EdgeInsets.all(getResponsivePadding(context) * 1.5),
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
          Text(
            'Overall Performance',
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, 20),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: getResponsivePadding(context) * 1.5),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: isTablet(context) ? 180 : 150,
                height: isTablet(context) ? 180 : 150,
                child: CircularProgressIndicator(
                  value: accuracy / 100,
                  strokeWidth: isTablet(context) ? 12 : 10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    accuracy >= 70 ? Colors.green : 
                    accuracy >= 50 ? Colors.orange : Colors.red,
                  ),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              Column(
                children: [
                  Text(
                    '${accuracy.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 28),
                      fontWeight: FontWeight.bold,
                      color: accuracy >= 70 ? Colors.green : 
                             accuracy >= 50 ? Colors.orange : Colors.red,
                    ),
                  ),
                  Text(
                    'Accuracy',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 14),
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: getResponsivePadding(context)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: accuracy >= 70 ? Colors.green[50] : 
                     accuracy >= 50 ? Colors.orange[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: accuracy >= 70 ? Colors.green[200]! : 
                       accuracy >= 50 ? Colors.orange[200]! : Colors.red[200]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  accuracy >= 70 ? Icons.trending_up_rounded : 
                  accuracy >= 50 ? Icons.trending_flat_rounded : Icons.trending_down_rounded,
                  color: accuracy >= 70 ? Colors.green : 
                         accuracy >= 50 ? Colors.orange : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  accuracy >= 70 ? 'Keep Practicing!' : 
                  accuracy >= 50 ? 'Good Progress!' : 'Need More Practice!',
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(context, 12),
                    fontWeight: FontWeight.w600,
                    color: accuracy >= 70 ? Colors.green[700] : 
                           accuracy >= 50 ? Colors.orange[700] : Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid(dynamic data, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallDevice = screenWidth < 360;
    final bool isTabletDevice = screenWidth > 768;
    
    // Define stats with proper null safety
    final List<Map<String, dynamic>> stats = [
      {
        'icon': Icons.quiz_outlined,
        'value': '${safeParseInt(data['answered_questions_count'])}',
        'label': 'Answered',
        'color': Color(0xFF4A90E2),
      },
      {
        'icon': Icons.check_circle_outline_rounded,
        'value': '${safeParseInt(data['correct_answers_count'])}',
        'label': 'Correct',
        'color': Colors.green,
      },
      {
        'icon': Icons.cancel_outlined,
        'value': '${safeParseInt(data['incorrect_answers_count'])}',
        'label': 'Wrong',
        'color': Colors.red,
      },
      {
        'icon': Icons.event_note_rounded,
        'value': '${safeParseInt(data['my_exams_count'])}/${safeParseInt(data['all_exams_count'])}',
        'label': 'Tests',
        'color': Colors.purple,
      },
      {
        'icon': Icons.star_outline_rounded,
        'value': '${safeParseDouble(data['marks_rate']).toStringAsFixed(1)}%',
        'label': 'Marks',
        'color': Colors.teal,
      },
      {
        'icon': Icons.warning_amber_rounded,
        'value': '${safeParseDouble(data['inaccuracy']).toStringAsFixed(1)}%',
        'label': 'Miss Rate',
        'color': Colors.orange,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTabletDevice ? 3 : 2,
        crossAxisSpacing: isSmallDevice ? 8 : 12,
        mainAxisSpacing: isSmallDevice ? 8 : 12,
        childAspectRatio: _getChildAspectRatio(screenWidth),
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        final statColor = stat['color'] as Color;
        final statIcon = stat['icon'] as IconData;
        final statValue = stat['value'] as String;
        final statLabel = stat['label'] as String;
        
        return Container(
          padding: EdgeInsets.all(_getCardPadding(screenWidth)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isSmallDevice ? 12 : 16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: isSmallDevice ? 6 : 10,
                offset: Offset(0, isSmallDevice ? 1 : 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container - smaller for small devices
              Container(
                padding: EdgeInsets.all(_getIconPadding(screenWidth)),
                decoration: BoxDecoration(
                  color: statColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isSmallDevice ? 8 : 12),
                ),
                child: Icon(
                  statIcon,
                  color: statColor,
                  size: _getIconSize(screenWidth),
                ),
              ),
              SizedBox(height: isSmallDevice ? 4 : 8),
              // Value text - responsive font size
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  statValue,
                  style: TextStyle(
                    fontSize: _getValueFontSize(screenWidth),
                    fontWeight: FontWeight.bold,
                    color: statColor,
                  ),
                  maxLines: 1,
                ),
              ),
              SizedBox(height: isSmallDevice ? 2 : 4),
              // Label text - responsive and truncated if needed
              Text(
                statLabel,
                style: TextStyle(
                  fontSize: _getLabelFontSize(screenWidth),
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper methods for responsive sizing
  double _getChildAspectRatio(double screenWidth) {
    if (screenWidth < 320) return 0.9; // Very small devices
    if (screenWidth < 360) return 1.0; // Small devices
    if (screenWidth < 400) return 1.1; // Medium small devices
    if (screenWidth > 768) return 1.3; // Tablets
    return 1.2; // Default mobile
  }

  double _getCardPadding(double screenWidth) {
    if (screenWidth < 360) return 8.0;
    if (screenWidth > 768) return 16.0;
    return 12.0;
  }

  double _getIconPadding(double screenWidth) {
    if (screenWidth < 360) return 6.0;
    if (screenWidth > 768) return 12.0;
    return 8.0;
  }

  double _getIconSize(double screenWidth) {
    if (screenWidth < 320) return 16.0; // Very small devices
    if (screenWidth < 360) return 18.0; // Small devices
    if (screenWidth > 768) return 28.0; // Tablets
    return 20.0; // Default mobile
  }

  double _getValueFontSize(double screenWidth) {
    if (screenWidth < 320) return 14.0; // Very small devices
    if (screenWidth < 360) return 16.0; // Small devices
    if (screenWidth > 768) return 24.0; // Tablets
    return 18.0; // Default mobile
  }

  double _getLabelFontSize(double screenWidth) {
    if (screenWidth < 320) return 9.0;  // Very small devices
    if (screenWidth < 360) return 10.0; // Small devices
    if (screenWidth > 768) return 14.0; // Tablets
    return 12.0; // Default mobile
  }

  Widget _buildExamHistorySection(dynamic data, BuildContext context) {
    final historyList = data['mcq_test_histories'] as List<dynamic>? ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history_rounded,
              color: Colors.grey[700],
              size: isTablet(context) ? 28 : 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Exam History',
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, 20),
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF4A90E2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Recent',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, 12),
                  color: Color(0xFF4A90E2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: getResponsivePadding(context)),
        historyList.isEmpty 
            ? Center(
                child: Container(
                  padding: EdgeInsets.all(getResponsivePadding(context) * 2),
                  child: Column(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No exam history available',
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(context, 16),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: historyList.length,
                itemBuilder: (context, index) {
                  return _buildExamHistoryItem(
                    data: historyList[index],
                    context: context,
                  );
                },
              ),
      ],
    );
  }

  Widget _buildExamHistoryItem({required dynamic data, required BuildContext context}) {
    // Get exam name with fallback
    String examName = 'Exam'; // Default name
    if (data['section'] != null && data['section']['title'] != null) {
      examName = data['section']['title'].toString();
    } else if (data['exam'] != null && data['exam']['title'] != null) {
      examName = data['exam']['title'].toString();
    }

    final correctAnswers = safeParseInt(data['correct_answers_count']);
    final incorrectAnswers = safeParseInt(data['incorrect_answers_count']);
    final unansweredQuestions = safeParseInt(data['unanswered_questions_count']);
    final totalQuestions = correctAnswers + incorrectAnswers + unansweredQuestions;
    final percentage = totalQuestions > 0 ? (correctAnswers / totalQuestions * 100) : 0.0;

    // Safe date parsing
    DateTime? submissionDate;
    try {
      if (data['datetime'] != null) {
        submissionDate = DateTime.parse(data['datetime'].toString()).toLocal();
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: EdgeInsets.all(getResponsivePadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF4A90E2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.quiz_rounded,
                    color: Color(0xFF4A90E2),
                    size: isTablet(context) ? 24 : 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        examName,
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        submissionDate != null
                            ? 'Submitted: ${DateFormat('EEE, M/d/yyyy h:mm a').format(submissionDate)}'
                            : 'Submission date unavailable',
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(context, 12),
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
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 12),
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getResponsivePadding(context)),
            Row(
              children: [
                _buildStatChip(
                  icon: Icons.star_rounded,
                  value: '${safeParseInt(data['marks'])}',
                  label: 'Marks',
                  color: Colors.teal,
                  context: context,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  icon: Icons.check_circle_rounded,
                  value: '$correctAnswers',
                  label: 'Correct',
                  color: Colors.green,
                  context: context,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  icon: Icons.cancel_rounded,
                  value: '$incorrectAnswers',
                  label: 'Wrong',
                  color: Colors.red,
                  context: context,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  icon: Icons.remove_circle_outline_rounded,
                  value: '$unansweredQuestions',
                  label: 'Skipped',
                  color: Colors.orange,
                  context: context,
                ),
              ],
            ),
            SizedBox(height: getResponsivePadding(context)),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.bar_chart_rounded,
                    label: 'Result',
                    color: Color(0xFF4A90E2),
                    onPressed: () => Get.to(() => ResultScreen(mcqTest: data)),
                    context: context,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.visibility_rounded,
                    label: 'Review',
                    color: Colors.green,
                    onPressed: () => Get.to(() => AnsweredPaperScreen(
                      isSubjectWise: data['section'] != null,
                      testId: safeParseInt(data['id']),
                      mcqTest: data['section'] ?? data['exam']
                    )),
                    context: context,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.leaderboard_rounded,
                    label: 'Ranking',
                    color: Colors.purple,
                    onPressed: () => Get.to(() => RankingScreen(
                      isSubjectWise: data['section'] != null,
                      mcqTest: data['section'] ?? data['exam']
                    )),
                    context: context,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required BuildContext context,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: isTablet(context) ? 20 : 16,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, 14),
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, 10),
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isTablet(context) ? 20 : 16,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, 10),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
