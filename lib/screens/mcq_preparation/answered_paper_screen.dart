import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/controllers/mcq_preparation_controller.dart';

class AnsweredPaperScreen extends GetView {
  static const id = 'performance_screen';

  AnsweredPaperScreen({
    super.key,
    required this.isSubjectWise,
    required this.mcqTest,
    required this.testId,
  });
  final bool isSubjectWise;
  final dynamic mcqTest;
  final int testId;
  final AuthController _authController = Get.find();
  final MCQPreparationController _mcqPreparationController =
      Get.put(MCQPreparationController());
  dynamic _examData;
  List<dynamic> _listSubmittedAnswer = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Answered Paper: ${mcqTest['title']}'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: isSubjectWise
              ? _mcqPreparationController.fetchSectionWiseMCQList(
                  sectionId: mcqTest['id'],
                  testId: testId,
                )
              : _mcqPreparationController.fetchCategoryWiseMCQList(
                  examId: mcqTest['id'],
                  testId: testId,
                ),
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
                _examData = data['exam'];
                _listSubmittedAnswer = data['list_submission'];

                return ListView.builder(
                  itemCount: data['mcq_list'].length,
                  itemBuilder: ((context, index) => _mcqItem(
                        data: data['mcq_list'][index],
                        context: context,
                        serialNumber: index + 1,
                      )),
                );
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

  Widget _mcqItem(
      {required dynamic data,
      required BuildContext context,
      required int serialNumber}) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$serialNumber. ${data['question']}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Container(
              height: .5,
              color: Colors.grey,
              margin: EdgeInsets.symmetric(vertical: 8),
            ),
            _optionItem(data: data, optionName: 'option_one'),
            _optionItem(data: data, optionName: 'option_two'),
            _optionItem(data: data, optionName: 'option_three'),
            _optionItem(data: data, optionName: 'option_four'),
            SizedBox(
              height: 4,
            ),
            data['hints'] != null
                ? Text('Hints: ${data['hints']}')
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _optionItem({required dynamic data, required String optionName}) =>
      Row(
        children: [
          SizedBox(
            width: 8,
          ),
          Icon(
            data['answer'] == optionName
                ? Icons.radio_button_checked_outlined
                : Icons.radio_button_off_outlined,
            color: _mcqPreparationController.checkOptionExistsInAnswerList(
                        listAnswer: _listSubmittedAnswer,
                        questionId: data['id'],
                        choosenOption: optionName) &&
                    data['answer'] != optionName
                ? Colors.red
                : data['answer'] == optionName
                    ? Colors.green
                    : Colors.grey,
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
              child: Text(
            data[optionName],
            style: TextStyle(
              color: _mcqPreparationController.checkOptionExistsInAnswerList(
                          listAnswer: _listSubmittedAnswer,
                          questionId: data['id'],
                          choosenOption: optionName) &&
                      data['answer'] != optionName
                  ? Colors.red
                  : data['answer'] == optionName
                      ? Colors.green
                      : Colors.black87,
            ),
          )),
        ],
      );
}
