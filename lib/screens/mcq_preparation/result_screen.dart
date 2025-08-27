import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/screens/mcq_preparation/answered_paper_screen.dart';
import 'package:mission_dmc/screens/mcq_preparation/ranking_screen.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.mcqTest,
  });
  final dynamic mcqTest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('MCQ Test Result'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Marks: ${mcqTest['marks']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Correct Answers: ${mcqTest['correct_answers_count']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'InCorrect Answers: ${mcqTest['incorrect_answers_count']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Negative Marks Rate: ${mcqTest['negative_marks_rate']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Answered Questions: ${mcqTest['answered_questions_count']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Unanswered Questions: ${mcqTest['unanswered_questions_count']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              rPrimaryElevatedButton(
                onPressed: () {
                  Get.to(() => RankingScreen(
                      isSubjectWise: mcqTest['section'] != null,
                      mcqTest: mcqTest['section'] ?? mcqTest['exam']));
                },
                buttonTextColor: Theme.of(context).primaryColor,
                primaryColor: Colors.white,
                buttonText: 'Ranking',
                fontSize: 14,
                borderRadius: 20.0,
              ),
              rPrimaryElevatedButton(
                onPressed: () {
                  Get.to(() => AnsweredPaperScreen(
                      isSubjectWise: mcqTest['section'] != null,
                      testId: mcqTest['id'],
                      mcqTest: mcqTest['section'] ?? mcqTest['exam']));
                },
                buttonTextColor: Theme.of(context).primaryColor,
                primaryColor: Colors.white,
                buttonText: 'Answered paper',
                fontSize: 14,
                borderRadius: 20.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
