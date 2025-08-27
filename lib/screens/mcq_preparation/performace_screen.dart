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

class PerformanceScreen extends GetView {
  static const id = 'performance_screen';

  PerformanceScreen({super.key});
  final AuthController _authController = Get.find();
  final MCQPreparationController _mcqPreparationController =
      Get.put(MCQPreparationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(_authController.profile.value.full_name!),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _mcqPreparationController.fetchMyPerformace(),
          builder: (context, snapshot) {
            // Checking if future is resolved
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Error occurred',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                // Extracting data from snapshot object
                final data = snapshot.data as dynamic;
                return _performaceWidget(data: data, context: context);
              }
            }
            // Displaying LoadingSpinner to indicate waiting state
            return Center(
              child: SpinKitCubeGrid(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _performaceWidget(
      {required dynamic data, required BuildContext context}) {
    double width = MediaQuery.of(context).size.width;

    return data['my_exams_count'] == 0
        ? Center(
            child: Text(
              "You haven't participated any exam yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          )
        : Column(
            children: [
              Column(
                children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [

                          SizedBox(
                          // Adjust to match the required size
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: CircularProgressIndicator(
                                    value:double.parse(data['accuracy'].toString())/100 ,// Adjust the progress here
                                    strokeWidth: 8,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red,
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                  Text(
                                  '${double.parse(data['accuracy'].toString()).toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                               Positioned(
                                 bottom: 20,
                                 child:  Text('Accuracy'),)

                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * .31,
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '${data['answered_questions_count']}',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text('Answered'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * .31,
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '${data['correct_answers_count']}',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text('Correct'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * .31,
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '${data['incorrect_answers_count']}',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text('InCorrect'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * .31,
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '${data['my_exams_count']} / ${data['all_exams_count']}',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text('Participated'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * .31,
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '${double.parse(data['marks_rate'].toString()).toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text('Marks'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * .31,
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  '${double.parse(data['inaccuracy'].toString()).toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Text('InAccuracy'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: data['mcq_test_histories'].length,
                      itemBuilder: ((context, index) {
                        return _mcqTestItem(
                            data: data['mcq_test_histories'][index],
                            context: context);
                      }))),
            ],
          );
  }

  Widget _mcqTestItem({required dynamic data, required BuildContext context}) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${data['section'] != null ? data['section']['title'] : data['exam']['title']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Submitted on: ${DateFormat.yMEd().add_jms().format(DateTime.parse(data['datetime']).toLocal())}',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '${data['marks']}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text('Marks'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${data['correct_answers_count']}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text('Correct'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${data['incorrect_answers_count']}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text('InCorrect'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${data['unanswered_questions_count']}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text('Not Answered'),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                rPrimaryElevatedButton(
                  onPressed: () {
                    Get.to(() => ResultScreen(mcqTest: data));
                  },
                  primaryColor: Theme.of(context).primaryColor,
                  buttonText: 'Result',
                  fontSize: 14.0,
                  borderRadius: 20,
                ),
                rPrimaryElevatedButton(
                  onPressed: () {
                    Get.to(() => AnsweredPaperScreen(
                        isSubjectWise: data['section'] != null,
                        testId: data['id'],
                        mcqTest: data['section'] ?? data['exam']));
                  },
                  primaryColor: Theme.of(context).primaryColor,
                  buttonText: 'Answered Paper',
                  fontSize: 14.0,
                  borderRadius: 20,
                ),
                rPrimaryElevatedButton(
                  onPressed: () {
                    Get.to(() => RankingScreen(
                        isSubjectWise: data['section'] != null,
                        mcqTest: data['section'] ?? data['exam']));
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
