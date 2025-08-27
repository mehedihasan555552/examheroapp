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
    super.key,
    required this.isSubjectWise,
    required this.isStartExam,
    required this.mcqTest,
    required this.testId,
  });

  final bool isSubjectWise, isStartExam;
  final dynamic mcqTest;
  final int testId;

  @override
  _MCQListViewState createState() => _MCQListViewState();
}

class _MCQListViewState extends State<MCQListView>
    with TickerProviderStateMixin {
  final AuthController _authController = Get.find();
  final MCQPreparationController _mcqPreparationController =
      Get.put(MCQPreparationController());
  BannerController bannerController = Get.find();

  dynamic _examData;
  Timer? _timerExamDurationLeft;
  int _examTimeLeftInSeconds = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _mcqPreparationController.clearMCQChoosenList();
    
    // Initialize pulse animation for timer
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isStartExam) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (_timerExamDurationLeft != null) {
      _timerExamDurationLeft?.cancel();
    }
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: FutureBuilder(
        future: widget.isSubjectWise
            ? _mcqPreparationController.fetchSectionWiseMCQList(
                sectionId: widget.mcqTest['id'],
                testId: widget.testId,
              )
            : _mcqPreparationController.fetchCategoryWiseMCQList(
                examId: widget.mcqTest['id'],
                testId: widget.testId,
              ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return _buildErrorWidget();
            } else if (snapshot.hasData) {
              final data = snapshot.data as dynamic;
              _examData = data['exam'];
              _initializeTimer();

              return Obx(() {
                return LoadingOverlay(
                  isLoading: _mcqPreparationController.loadingMCQSubmission.value,
                  progressIndicator: _buildLoadingIndicator(),
                  child: Column(
                    children: [
                      if (widget.isStartExam) _buildTimerWidget(),
                      _buildProgressIndicator(data['mcq_list'].length),
                      Expanded(
                        child: _buildMCQList(data['mcq_list']),
                      ),
                      if (widget.isStartExam) _buildSubmitButton(),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              });
            }
          }
          return _buildLoadingScreen();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: Column(
        children: [
          Text(
            widget.isStartExam ? 'পরীক্ষা চলমান' : 'অধ্যয়ন মোড',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            widget.mcqTest['title'],
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => _showExitConfirmation(),
      ),
      actions: [
        if (!widget.isStartExam)
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => _showHelpDialog(),
          ),
      ],
    );
  }

  Widget _buildTimerWidget() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[400]!, Colors.red[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Icon(
                    Icons.access_time_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                const Text(
                  'অবশিষ্ট সময়',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                  _mcqPreparationController.examTimeLeft.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'monospace',
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int totalQuestions) {
    return Obx(() {
      int answered = _mcqPreparationController.listMCQChoosen.length;
      double progress = totalQuestions > 0 ? answered / totalQuestions : 0;
      
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'অগ্রগতি',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '$answered/$totalQuestions উত্তর দিয়েছেন',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
              minHeight: 6,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMCQList(List mcqList) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: mcqList.length,
      itemBuilder: (context, index) => _mcqItem(
        data: mcqList[index],
        context: context,
        serialNumber: index + 1,
        totalQuestions: mcqList.length,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      return _mcqPreparationController.listMCQChoosen.isNotEmpty
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_mcqPreparationController.loadingMCQSubmission.value) return;
                  await _submitExam();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      'উত্তরপত্র জমা দিন',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink();
    });
  }

  Widget _mcqItem({
    required dynamic data,
    required BuildContext context,
    required int serialNumber,
    required int totalQuestions,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuestionHeader(data, serialNumber, totalQuestions),
            const SizedBox(height: 16),
            _buildQuestionText(data['question'], serialNumber),
            const SizedBox(height: 20),
            _buildOptionsSection(data),
            if (!widget.isStartExam && data['hints'] != null) ...[
              const SizedBox(height: 16),
              _buildHintsSection(data['hints']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionHeader(dynamic data, int serialNumber, int totalQuestions) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          child: Text(
            'প্রশ্ন $serialNumber/$totalQuestions',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        if (bannerController.count.value == 0)
          _buildBookmarkButton(data),
      ],
    );
  }

  Widget _buildBookmarkButton(dynamic data) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: bannerController.bookmarkedItems.contains(data['id'])
            ? Colors.amber.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () => bannerController.addBookmarks(mcqId: data['id']),
        icon: Icon(
          bannerController.bookmarkedItems.contains(data['id'])
              ? Icons.bookmark_rounded
              : Icons.bookmark_border_rounded,
          color: bannerController.bookmarkedItems.contains(data['id'])
              ? Colors.amber[700]
              : Colors.grey[600],
          size: 22,
        ),
      ),
    ));
  }

  Widget _buildQuestionText(String question, int serialNumber) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        question,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildOptionsSection(dynamic data) {
    return Column(
      children: [
        _optionItem(data: data, optionName: 'option_one', optionLabel: 'ক'),
        const SizedBox(height: 8),
        _optionItem(data: data, optionName: 'option_two', optionLabel: 'খ'),
        const SizedBox(height: 8),
        _optionItem(data: data, optionName: 'option_three', optionLabel: 'গ'),
        const SizedBox(height: 8),
        _optionItem(data: data, optionName: 'option_four', optionLabel: 'ঘ'),
      ],
    );
  }

  Widget _buildHintsSection(String hints) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: Colors.blue[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'সহায়তা:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hints,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionItem({
    required dynamic data,
    required String optionName,
    required String optionLabel,
  }) {
    if (!widget.isStartExam) {
      // Study mode
      bool isCorrect = data['answer'] == optionName;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCorrect ? Colors.green : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  optionLabel,
                  style: TextStyle(
                    color: isCorrect ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                data[optionName],
                style: TextStyle(
                  fontSize: 15,
                  color: isCorrect ? Colors.green[800] : Colors.black87,
                  fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
                  height: 1.4,
                ),
              ),
            ),
            if (isCorrect)
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 24,
              ),
          ],
        ),
      );
    } else {
      // Exam mode
      return Obx(() {
        bool isAlreadyChosen = _mcqPreparationController.listMCQChoosen
            .any((element) => element['id'] == data['id']);
        bool isSelected = _mcqPreparationController.checkMCQChoosenOption(
            id: data['id'], choosenOption: optionName);

        return InkWell(
          onTap: isAlreadyChosen ? null : () => _selectOption(data['id'], optionName),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      optionLabel,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    data[optionName],
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      height: 1.4,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.radio_button_checked_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      });
    }
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ),
            const SizedBox(height: 24),
            Text(
              'প্রশ্নপত্র লোড হচ্ছে...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitWave(
            color: Theme.of(context).primaryColor,
            size: 40.0,
          ),
          const SizedBox(height: 16),
          const Text(
            'উত্তরপত্র জমা দেওয়া হচ্ছে...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.red[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'কোনো সমস্যা হয়েছে',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'প্রশ্নপত্র লোড করতে সমস্যা হয়েছে',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _initializeTimer() {
    if (widget.isStartExam && _examData != null) {
      _examTimeLeftInSeconds = _examData['duration'] * 60;
      _mcqPreparationController.setFormatedTime(timeInSecond: _examTimeLeftInSeconds);
      _timerExamDurationLeft = Timer.periodic(const Duration(seconds: 1), (timer) {
        _examTimeLeftInSeconds--;
        if (_examTimeLeftInSeconds <= 0) {
          timer.cancel();
          _handleTimeUp();
        }
        _mcqPreparationController.setFormatedTime(timeInSecond: _examTimeLeftInSeconds);
      });
    }
  }

  void _selectOption(int questionId, String optionName) {
    _mcqPreparationController.setMCQChoosenOption(
      id: questionId,
      choosenOption: optionName,
    );
  }

  Future<void> _submitExam() async {
    _timerExamDurationLeft?.cancel();
    dynamic result = await _mcqPreparationController.tryToSubmitMCQTest(
      isSubjectWise: widget.isSubjectWise,
      testId: widget.mcqTest['id'],
    );
    if (result != null) {
      Get.off(() => ResultScreen(mcqTest: result));
    }
  }

  void _handleTimeUp() {
    Get.snackbar(
      'সময় শেষ',
      "পরীক্ষার সময় শেষ হয়ে গেছে।",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
    Navigator.of(context).pop();
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('পরীক্ষা ছেড়ে যেতে চান?'),
        content: Text(widget.isStartExam 
          ? 'আপনার উত্তরগুলো সংরক্ষিত হবে না।' 
          : 'আপনি কি নিশ্চিত যে আপনি বের হতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('না'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('হ্যাঁ'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('সহায়তা'),
        content: const Text('এই মোডে আপনি সঠিক উত্তর দেখতে পারবেন এবং অধ্যয়ন করতে পারবেন।'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বুঝেছি'),
          ),
        ],
      ),
    );
  }
}
