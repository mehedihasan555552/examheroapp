import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/controllers/mcq_preparation_controller.dart';
import 'package:mission_dmc/screens/mcq_preparation/result_screen.dart';
import 'package:mission_dmc/update_controllers/banner_controller.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class MCQListView extends StatefulWidget {
  const MCQListView({
    Key? key,
    required this.isSubjectWise,
    required this.isStartExam,
    required this.mcqTest,
    required this.testId,
  }) : super(key: key);

  final bool isSubjectWise, isStartExam;
  final dynamic mcqTest;
  final int testId;

  @override
  _MCQListViewState createState() => _MCQListViewState();
}

class _MCQListViewState extends State<MCQListView>
    with SingleTickerProviderStateMixin {
  final AuthController _authController = Get.find();
  final MCQPreparationController _mcqPreparationController =
      Get.put(MCQPreparationController());
  BannerController bannerController = Get.find();

  dynamic _examData;
  Timer? _timerExamDurationLeft;
  int _examTimeLeftInSeconds = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Device responsive detection
  bool get isTablet => MediaQuery.of(context).size.width > 768;
  double get responsivePadding => isTablet ? 24.0 : 16.0;
  double getResponsiveFontSize(double baseFontSize) {
    return isTablet ? baseFontSize * 1.2 : baseFontSize;
  }

  // Safe data access
  String safeGetString(dynamic data, String key, {String defaultValue = ''}) {
    try {
      return data[key]?.toString() ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  int safeGetInt(dynamic data, String key, {int defaultValue = 0}) {
    try {
      final value = data[key];
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
    _mcqPreparationController.clearMCQChoosenList();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    _timerExamDurationLeft?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testTitle = safeGetString(widget.mcqTest, 'title', defaultValue: 'Test');

    return Scaffold(
      backgroundColor: Color(0xFF4A90E2),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, testTitle),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: _buildMainContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, String testTitle) {
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
                    onPressed: () {
                      _timerExamDurationLeft?.cancel();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.isStartExam ? 'Exam Mode' : 'Study Mode',
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
                      widget.isStartExam ? Icons.quiz_rounded : Icons.menu_book_rounded,
                      color: Colors.white,
                      size: isTablet ? 24 : 20,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: responsivePadding),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Text(
                testTitle,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(14),
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return FutureBuilder(
      future: widget.isSubjectWise
          ? _mcqPreparationController.fetchSectionWiseMCQList(
              sectionId: safeGetInt(widget.mcqTest, 'id'),
              testId: widget.testId,
            )
          : _mcqPreparationController.fetchCategoryWiseMCQList(
              examId: safeGetInt(widget.mcqTest, 'id'),
              testId: widget.testId,
            ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState();
        }

        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data as dynamic;
          _examData = data['exam'];
          
          if (widget.isStartExam && _timerExamDurationLeft == null) {
            _startExamTimer();
          }

          final mcqList = data['mcq_list'] as List<dynamic>? ?? [];
          
          if (mcqList.isEmpty) {
            return _buildEmptyState();
          }

          return _buildQuestionsList(mcqList);
        }

        return _buildEmptyState();
      },
    );
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
            'Loading questions...',
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
              'Error Loading Questions',
              style: TextStyle(
                fontSize: getResponsiveFontSize(18),
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Unable to load the questions. Please try again.',
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
              'No Questions Available',
              style: TextStyle(
                fontSize: getResponsiveFontSize(18),
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This test doesn\'t have any questions yet.',
              style: TextStyle(
                fontSize: getResponsiveFontSize(14),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsList(List<dynamic> mcqList) {
    return Obx(() {
      return LoadingOverlay(
        isLoading: _mcqPreparationController.loadingMCQSubmission.value,
        progressIndicator: SpinKitPulse(
          color: Color(0xFF4A90E2),
          size: 50.0,
        ),
        child: Column(
          children: [
            // Timer bar for exam mode
            if (widget.isStartExam) _buildTimerBar(),
            
            // Questions list
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(responsivePadding),
                  itemCount: mcqList.length,
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
                      child: _buildMCQItem(
                        data: mcqList[index],
                        context: context,
                        serialNumber: index + 1,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Submit button for exam mode
            if (widget.isStartExam) _buildSubmitButton(),
          ],
        ),
      );
    });
  }

  Widget _buildTimerBar() {
    return Container(
      padding: EdgeInsets.all(responsivePadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[400]!, Colors.green[600]!],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_rounded,
            color: Colors.white,
            size: isTablet ? 24 : 20,
          ),
          SizedBox(width: 8),
          Obx(() => Text(
                _mcqPreparationController.examTimeLeft.value,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: getResponsiveFontSize(18),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildMCQItem({
    required dynamic data,
    required BuildContext context,
    required int serialNumber,
  }) {
    final question = safeGetString(data, 'question');
    final hints = safeGetString(data, 'hints');
    final questionId = safeGetInt(data, 'id');

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
        padding: EdgeInsets.all(responsivePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '$serialNumber',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: getResponsiveFontSize(14),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: getResponsiveFontSize(16),
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Bookmark button (only in study mode)
                if (!widget.isStartExam) _buildBookmarkButton(questionId),
              ],
            ),
            
            SizedBox(height: responsivePadding),
            
            // Options
            Column(
              children: [
                _buildOptionItem(data: data, optionName: 'option_one', optionLabel: 'A'),
                SizedBox(height: 8),
                _buildOptionItem(data: data, optionName: 'option_two', optionLabel: 'B'),
                SizedBox(height: 8),
                _buildOptionItem(data: data, optionName: 'option_three', optionLabel: 'C'),
                SizedBox(height: 8),
                _buildOptionItem(data: data, optionName: 'option_four', optionLabel: 'D'),
              ],
            ),
            
            // Hints section (only in study mode)
            if (!widget.isStartExam && hints.isNotEmpty) ...[
              SizedBox(height: responsivePadding),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          color: Colors.amber[700],
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Hint',
                          style: TextStyle(
                            fontSize: getResponsiveFontSize(12),
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      hints,
                      style: TextStyle(
                        fontSize: getResponsiveFontSize(12),
                        color: Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkButton(int questionId) {
    return Obx(() {
      return bannerController.count.value == 0
          ? Container(
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () {
                  bannerController.addBookmarks(mcqId: questionId);
                },
                icon: Icon(
                  bannerController.bookmarkedItems.contains(questionId)
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: bannerController.bookmarkedItems.contains(questionId)
                      ? Colors.amber
                      : Colors.grey[400],
                  size: isTablet ? 24 : 20,
                ),
              ),
            )
          : Container();
    });
  }

  Widget _buildOptionItem({
    required dynamic data,
    required String optionName,
    required String optionLabel,
  }) {
    final optionText = safeGetString(data, optionName);
    final correctAnswer = safeGetString(data, 'answer');
    final questionId = safeGetInt(data, 'id');

    if (!widget.isStartExam) {
      // Study mode: Show correct answer
      final isCorrect = correctAnswer == optionName;
      
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCorrect ? Colors.green[50] : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCorrect ? Colors.green[300]! : Colors.grey[200]!,
            width: isCorrect ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCorrect ? Colors.green[400]! : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  optionLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getResponsiveFontSize(12),
                    color: isCorrect ? Colors.green[700] : Colors.grey[700],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                optionText,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(14),
                  color: isCorrect ? Colors.green[800] : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isCorrect)
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green[600],
                size: isTablet ? 24 : 20,
              ),
          ],
        ),
      );
    } else {
      // Exam mode: Allow selection
      return Obx(() {
        bool isAlreadyChosen = _mcqPreparationController.listMCQChoosen
            .any((element) => element['id'] == questionId);
        bool isThisOptionSelected = _mcqPreparationController
            .checkMCQChoosenOption(id: questionId, choosenOption: optionName);

        return GestureDetector(
          onTap: isAlreadyChosen
              ? null
              : () => _mcqPreparationController.setMCQChoosenOption(
                    id: questionId,
                    choosenOption: optionName,
                  ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isThisOptionSelected ? Color(0xFF4A90E2).withOpacity(0.1) : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isThisOptionSelected ? Color(0xFF4A90E2) : Colors.grey[200]!,
                width: isThisOptionSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isThisOptionSelected ? Color(0xFF4A90E2).withOpacity(0.2) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isThisOptionSelected ? Color(0xFF4A90E2) : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      optionLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getResponsiveFontSize(12),
                        color: isThisOptionSelected ? Color(0xFF4A90E2) : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    optionText,
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(14),
                      color: isThisOptionSelected ? Color(0xFF4A90E2) : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isThisOptionSelected)
                  Icon(
                    Icons.radio_button_checked_rounded,
                    color: Color(0xFF4A90E2),
                    size: isTablet ? 24 : 20,
                  ),
              ],
            ),
          ),
        );
      });
    }
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      return _mcqPreparationController.listMCQChoosen.isNotEmpty
          ? Container(
              padding: EdgeInsets.all(responsivePadding),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _mcqPreparationController.loadingMCQSubmission.value
                      ? null
                      : _handleSubmitExam,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
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
                        Icons.send_rounded,
                        size: isTablet ? 24 : 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Submit Answer',
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container();
    });
  }

  void _startExamTimer() {
    if (_examData != null) {
      // Changed defaultValue from 60 to 30 (30 minutes)
      _examTimeLeftInSeconds = safeGetInt(_examData, 'duration', defaultValue: 30) * 60;
      _mcqPreparationController.setFormatedTime(timeInSecond: _examTimeLeftInSeconds);
      
      _timerExamDurationLeft = Timer.periodic(const Duration(seconds: 1), (timer) {
        _examTimeLeftInSeconds = _examTimeLeftInSeconds - 1;
        if (_examTimeLeftInSeconds <= 0) {
          timer.cancel();
          _showTimeUpDialog();
        }
        _mcqPreparationController.setFormatedTime(timeInSecond: _examTimeLeftInSeconds);
      });
    }
  }


  void _showTimeUpDialog() {
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
              colors: [Colors.red[100]!, Colors.red[50]!],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_off_rounded,
                size: isTablet ? 60 : 48,
                color: Colors.red[700],
              ),
              SizedBox(height: responsivePadding),
              Text(
                'Time\'s Up!',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your exam time has expired and has been automatically submitted.',
                style: TextStyle(
                  fontSize: getResponsiveFontSize(14),
                  color: Colors.red[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: responsivePadding),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _handleSubmitExam() async {
    if (_mcqPreparationController.loadingMCQSubmission.value) {
      return;
    }
    
    _timerExamDurationLeft?.cancel();
    
    try {
      dynamic result = await _mcqPreparationController.tryToSubmitMCQTest(
        isSubjectWise: widget.isSubjectWise,
        testId: safeGetInt(widget.mcqTest, 'id'),
      );
      
      if (result != null) {
        Get.off(() => ResultScreen(mcqTest: result));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit exam. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
