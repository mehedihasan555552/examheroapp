import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';
import 'package:mission_dmc/controllers/mcq_preparation_controller.dart';
import 'package:mission_dmc/screens/inner_screens/screens_parts/inner_page_header.dart';
import 'package:mission_dmc/screens/mcq_preparation/mcq_list_view.dart';
import 'package:mission_dmc/screens/mcq_preparation/package_view.dart';
import 'package:mission_dmc/screens/mcq_preparation/ranking_screen.dart';
import 'package:mission_dmc/widgets/reusable_widgets.dart';

class ExamListView extends StatelessWidget {
  ExamListView({
    super.key,
    required this.categoryData,
  });
  final dynamic categoryData;
  final MCQPreparationController _mcqPreparationController =
      Get.put(MCQPreparationController());
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: kPrimaryColor,
              height: size.height * .23,
              width: double.infinity,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //main colum started
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                //Container For header icon and text
                InnerHeader(
                  text: categoryData['title'],
                  image: Image.asset(
                    'assets/icons/centraltest.png',
                    height: 80,
                    width: 80,
                  ),
                ),
                // const SizedBox(
                //   height: 16,
                // ),
              ],
            ),
            Positioned(
              top: 180,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: _mcqPreparationController.fetchExamList(
                        categoryId: categoryData['id']),
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
                          final listData = snapshot.data as List<dynamic>;
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listData.length,
                            itemBuilder: ((context, index) => _categoryItem(
                                  data: listData[index],
                                  context: context,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryItem({
    required dynamic data,
    required BuildContext context,
  }) =>
      Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          //set border radius more than 50% of height and width to make circle
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
                      data['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Marks: ${data['marks']} | Duration: ${data['duration']} minutes',
                      style: TextStyle(
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
                      if (int.tryParse(_authController.profile.value.package
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
                              isSubjectWise: false,
                              testId: 0,
                              mcqTest: data,
                            ));
                      }
                    },
                    primaryColor: Theme.of(context).primaryColor,
                    buttonText: 'Start Exam',
                    fontSize: 14.0,
                    borderRadius: 20,
                  ),
                  rPrimaryElevatedButton(
                    onPressed: () {
                      if (int.tryParse(_authController.profile.value.package
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
                              mcqTest: data,
                            ));
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
                            isSubjectWise: false,
                            mcqTest: data,
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
