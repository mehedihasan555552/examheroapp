import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/screens/mcq_preparation/answered_paper_screen.dart';
import 'package:mission_dmc/screens/mcq_preparation/ranking_screen.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    Key? key,
    required this.mcqTest,
  }) : super(key: key);
  
  final dynamic mcqTest;

  // Device type detection for responsive design
  bool get isTablet => Get.width > 768;
  double get screenWidth => Get.width;
  double get screenHeight => Get.height;
  
  // Responsive dimensions
  double get responsivePadding => isTablet ? 24.0 : 16.0;
  double get responsiveFontSize => isTablet ? 1.2 : 1.0;

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
                width: double.infinity,
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
                    padding: EdgeInsets.all(responsivePadding),
                    child: Column(
                      children: [
                        SizedBox(height: responsivePadding),
                        _buildResultHeader(),
                        SizedBox(height: responsivePadding * 1.5),
                        _buildScoreCard(),
                        SizedBox(height: responsivePadding),
                        _buildStatisticsGrid(),
                        SizedBox(height: responsivePadding * 1.5),
                        _buildActionButtons(),
                        SizedBox(height: responsivePadding),
                      ],
                    ),
                  ),
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
      padding: EdgeInsets.all(responsivePadding),
      child: Row(
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
                'Test Results',
                style: TextStyle(
                  fontSize: 20 * responsiveFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: isTablet ? 56 : 48), // Balance the layout
        ],
      ),
    );
  }

  Widget _buildResultHeader() {
    final percentage = _calculatePercentage();
    final performanceLevel = _getPerformanceLevel(percentage);
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(responsivePadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                performanceLevel['color'].withOpacity(0.1),
                performanceLevel['color'].withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: performanceLevel['color'].withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                performanceLevel['icon'],
                size: isTablet ? 80 : 64,
                color: performanceLevel['color'],
              ),
              SizedBox(height: responsivePadding),
              Text(
                performanceLevel['title'],
                style: TextStyle(
                  fontSize: 24 * responsiveFontSize,
                  fontWeight: FontWeight.bold,
                  color: performanceLevel['color'],
                ),
              ),
              SizedBox(height: 8),
              Text(
                performanceLevel['message'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14 * responsiveFontSize,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard() {
    final totalQuestions = mcqTest['correct_answers_count'] + 
                          mcqTest['incorrect_answers_count'] + 
                          mcqTest['unanswered_questions_count'];
    final percentage = totalQuestions > 0 
        ? (mcqTest['correct_answers_count'] / totalQuestions * 100)
        : 0.0;
    
    return Container(
      padding: EdgeInsets.all(responsivePadding * 1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF7B68EE),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4A90E2).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'Your Score',
                  style: TextStyle(
                    fontSize: 16 * responsiveFontSize,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${mcqTest['marks']}',
                  style: TextStyle(
                    fontSize: 36 * responsiveFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Marks',
                  style: TextStyle(
                    fontSize: 14 * responsiveFontSize,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: isTablet ? 80 : 60,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Accuracy',
                  style: TextStyle(
                    fontSize: 16 * responsiveFontSize,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 36 * responsiveFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Correct',
                  style: TextStyle(
                    fontSize: 14 * responsiveFontSize,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid() {
  // Define stats with proper typing
  final List<Map<String, dynamic>> stats = [
    {
      'icon': Icons.check_circle_rounded,
      'value': '${mcqTest['correct_answers_count']}',
      'label': 'Correct\nAnswers',
      'color': Colors.green,
    },
    {
      'icon': Icons.cancel_rounded,
      'value': '${mcqTest['incorrect_answers_count']}',
      'label': 'Incorrect\nAnswers',
      'color': Colors.red,
    },
    {
      'icon': Icons.help_outline_rounded,
      'value': '${mcqTest['unanswered_questions_count']}',
      'label': 'Unanswered\nQuestions',
      'color': Colors.orange,
    },
    {
      'icon': Icons.quiz_rounded,
      'value': '${mcqTest['answered_questions_count']}',
      'label': 'Total\nAnswered',
      'color': Color(0xFF4A90E2),
    },
    {
      'icon': Icons.trending_down_rounded,
      'value': '${mcqTest['negative_marks_rate'] ?? 0}',
      'label': 'Negative\nMarks Rate',
      'color': Colors.purple,
    },
    {
      'icon': Icons.timer_rounded,
      'value': _getFormattedTime(),
      'label': 'Time\nTaken',
      'color': Colors.teal,
    },
  ];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: isTablet ? 3 : 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isTablet ? 1.2 : 1.1,
    ),
    itemCount: stats.length,
    itemBuilder: (context, index) {
      final stat = stats[index];
      // Properly cast the values to their expected types
      final statColor = stat['color'] as Color;
      final statIcon = stat['icon'] as IconData;
      final statValue = stat['value'] as String;
      final statLabel = stat['label'] as String;
      
      return Container(
        padding: EdgeInsets.all(responsivePadding),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statColor.withOpacity(0.1), // Now properly typed
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                statIcon,
                color: statColor,
                size: isTablet ? 28 : 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              statValue,
              style: TextStyle(
                fontSize: 18 * responsiveFontSize,
                fontWeight: FontWeight.bold,
                color: statColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              statLabel,
              style: TextStyle(
                fontSize: 11 * responsiveFontSize,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    },
  );
}


  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.analytics_rounded,
              color: Colors.grey[700],
              size: isTablet ? 28 : 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Detailed Analysis',
              style: TextStyle(
                fontSize: 18 * responsiveFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        SizedBox(height: responsivePadding),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.leaderboard_rounded,
                label: 'View Ranking',
                description: 'See your position',
                color: Colors.purple,
                onPressed: () {
                  Get.to(() => RankingScreen(
                    isSubjectWise: mcqTest['section'] != null,
                    mcqTest: mcqTest['section'] ?? mcqTest['exam']
                  ));
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.article_rounded,
                label: 'Review Paper',
                description: 'Check answers',
                color: Colors.teal,
                onPressed: () {
                  Get.to(() => AnsweredPaperScreen(
                    isSubjectWise: mcqTest['section'] != null,
                    testId: mcqTest['id'],
                    mcqTest: mcqTest['section'] ?? mcqTest['exam']
                  ));
                },
              ),
            ),
          ],
        ),
        SizedBox(height: responsivePadding),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.back();
              Get.back(); // Go back to main screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: responsivePadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 16 * responsiveFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
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
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(responsivePadding),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isTablet ? 32 : 28,
                ),
              ),
              SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14 * responsiveFontSize,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12 * responsiveFontSize,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods
  double _calculatePercentage() {
    final totalQuestions = mcqTest['correct_answers_count'] + 
                          mcqTest['incorrect_answers_count'] + 
                          mcqTest['unanswered_questions_count'];
    return totalQuestions > 0 
        ? (mcqTest['correct_answers_count'] / totalQuestions * 100)
        : 0.0;
  }

  Map<String, dynamic> _getPerformanceLevel(double percentage) {
    if (percentage >= 90) {
      return {
        'title': 'Excellent!',
        'message': 'Outstanding performance! Keep it up!',
        'icon': Icons.emoji_events_rounded,
        'color': Colors.amber,
      };
    } else if (percentage >= 75) {
      return {
        'title': 'Great Job!',
        'message': 'Very good performance! You\'re doing well!',
        'icon': Icons.thumb_up_rounded,
        'color': Colors.green,
      };
    } else if (percentage >= 60) {
      return {
        'title': 'Good Work!',
        'message': 'Nice effort! Keep practicing to improve!',
        'icon': Icons.trending_up_rounded,
        'color': Colors.blue,
      };
    } else if (percentage >= 40) {
      return {
        'title': 'Keep Trying!',
        'message': 'You can do better! Practice more!',
        'icon': Icons.school_rounded,
        'color': Colors.orange,
      };
    } else {
      return {
        'title': 'Need Practice!',
        'message': 'Don\'t worry! More practice will help!',
        'icon': Icons.book_rounded,
        'color': Colors.red,
      };
    }
  }

  String _getFormattedTime() {
    // If time data is available in mcqTest, format it
    // Otherwise return a placeholder
    return mcqTest['time_taken'] != null 
        ? '${mcqTest['time_taken']}m'
        : 'N/A';
  }
}
