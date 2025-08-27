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

  const ExamStartCard({super.key, 
    required this.isModelTest,
    required this.isLiveExam,
    required this.data,
    required this.isUpcoming,
  });

  @override
  _ExamStartCardState createState() => _ExamStartCardState();
}

class _ExamStartCardState extends State<ExamStartCard> {
  AuthController authController = Get.find();
  Timer? _timer;
  Duration _remainingTime = const Duration();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    if (widget.data['end_datetime'] != null) {
      DateTime endDate = DateTime.parse(widget.data['end_datetime']);
      _updateRemainingTime(endDate);

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateRemainingTime(endDate);
      });
    } else {
      setState(() {
        _remainingTime = Duration.zero; // Or any default behavior you prefer
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              horizontalTitleGap: 4,
              leading: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(80),
                ),
                child: Image.asset(
                  'assets/icons/centraltest.png',
                  height: 32,
                  width: 32,
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  widget.isLiveExam
                      ? Text(
                          'Negative Marks: ${widget.data['negative_marks']} | Duration: ${widget.data['duration']} minutes',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        )
                      : Text(
                          'Marks: ${widget.data['marks']} | Duration: ${widget.data['duration']} minutes',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                rPrimaryElevatedButton(
                  onPressed: () {
                    if (widget.isUpcoming) {
                      Get.defaultDialog(
                        title: 'Notice',
                        middleText: 'Please wait until the exam started.',
                        textConfirm: 'OK',
                        onConfirm: () {
                          Get.back(); // Closes the dialog
                        },
                        confirmTextColor: Colors.white,
                      );
                    } else {
                      if (widget.isModelTest) {
                        Get.to(() => MCQListView(
                              isStartExam: true,
                              isSubjectWise: true,
                              testId: 0,
                              mcqTest: widget.data,
                            ));
                      } else {
                        if (int.tryParse(authController.profile.value.package
                                .toString()) ==
                            null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Premium Feature',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                  'To unlock this course you have to purchase it.',
                                ),
                                actions: [
                                  // Cancel Button
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the popup
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  // OK Button
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the popup
                                      Get.to(() => PackageView(), fullscreenDialog: true); // Redirect
                                    },
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                        } else {
                          Get.to(() => MCQListView(
                                isStartExam: true,
                                isSubjectWise: true,
                                testId: 0,
                                mcqTest: widget.data,
                              ));
                        }
                      }
                    }
                  },
                  primaryColor: Theme.of(context).primaryColor,
                  buttonText: 'Start Exam',
                  fontSize: 14.0,
                  borderRadius: 20,
                ),
                widget.isLiveExam
                    ? Row(
                        children: [
                          const Icon(Icons.punch_clock),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(_remainingTime),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      )
                    : rPrimaryElevatedButton(
                        onPressed: () {
                          if (widget.isModelTest) {
                            Get.to(() => MCQListView(
                                  isStartExam: false,
                                  isSubjectWise: false,
                                  testId: 0,
                                  mcqTest: widget.data,
                                ));
                          } else {
                            if (int.tryParse(authController
                                    .profile.value.package
                                    .toString()) ==
                                null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Premium Feature',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    content: const Text(
                                      'To unlock this course you have to purchase it.',
                                    ),
                                    actions: [
                                      // Cancel Button
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the popup
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      // OK Button
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the popup
                                          Get.to(() => PackageView(), fullscreenDialog: true); // Redirect
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(color: kPrimaryColor),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                            } else {
                              Get.to(() => MCQListView(
                                    isStartExam: false,
                                    isSubjectWise: false,
                                    testId: 0,
                                    mcqTest: widget.data,
                                  ));
                            }
                          }
                        },
                        primaryColor: Theme.of(context).primaryColor,
                        buttonText: 'Study',
                        fontSize: 14.0,
                        borderRadius: 20,
                      ),
                rPrimaryElevatedButton(
                  onPressed: () {
                    Get.to(() => RankingScreen(
                          isSubjectWise: true,
                          mcqTest: widget.data,
                        ));
                  },
                  primaryColor: Theme.of(context).primaryColor,
                  buttonText: 'Ranking',
                  fontSize: 14.0,
                  borderRadius: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
