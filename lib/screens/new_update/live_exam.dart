import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/update_controllers/banner_controller.dart';

import '../../config/constants.dart';
import '../../widgets/update/exam_start_card.dart';
import '../inner_screens/screens_parts/inner_page_header.dart';

class LiveExamView extends StatefulWidget {
  const LiveExamView({super.key});

  @override
  State<LiveExamView> createState() => _LiveExamViewState();
}

class _LiveExamViewState extends State<LiveExamView> {
  BannerController bannerController = Get.find();
  final RxInt currentIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                // color: kPrimaryColor,
                height: Get.height * .23,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/final_top_bar.png"),
                    // Your top background image
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.0),
                    bottomRight: Radius.circular(24.0),
                  ),
                ),


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
                  Obx(() {
                    // Dynamically update the InnerHeader text based on selected tab
                    return InnerHeader(
                      text: currentIndex.value == 0
                          ? 'Live Exam'
                          : currentIndex.value == 1
                          ? 'Upcoming Exams'
                          : 'Archived Exams',
                      image: Image.asset(
                        'assets/icons/mcqtest.png',
                        height: 80,
                        width: 80,
                      ),
                    );
                  }),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                ],
              ),
            ],
          ),
          DefaultTabController(
            length: 3, // Number of tabs
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child:  TabBar(
                    labelColor: Colors.black,
                    indicatorColor: kPrimaryColor,
                    onTap: (index) {
                      currentIndex.value = index; // Update the tab index
                    },
                    tabs: [
                      Tab(text: "Live Exam"),
                      Tab(text: "Upcoming"),
                      Tab(text: "Archive"),
                    ],
                  ),
                ),
                Container(
                  height: Get.height *
                      0.664, // Adjust this height to fit your layout
                  margin: const EdgeInsets.only(top: 10),
                  child: TabBarView(
                    children: [
                      Center(
                        child: Obx(() {
                          return ListView.builder(
                              itemCount: bannerController.liveExamList.length,
                              itemBuilder: (context, index) {
                                return ExamStartCard(
                                  isUpcoming: false,
                                  data: bannerController.liveExamList[index],
                                  isLiveExam: true,
                                  isModelTest: false,
                                );
                              });
                        }),
                      ),
                      Center(
                        child: Obx(() {
                          return ListView.builder(
                              itemCount:
                                  bannerController.upcomingExamList.length,
                              itemBuilder: (context, index) {
                                return ExamStartCard(
                                  isUpcoming: true,
                                  data:
                                      bannerController.upcomingExamList[index],
                                  isLiveExam: true,
                                  isModelTest: false,
                                );
                              });
                        }),
                      ),
                      Center(
                        child: Obx(() {
                          return ListView.builder(
                              itemCount:
                                  bannerController.archiveExamList.length,
                              itemBuilder: (context, index) {
                                return ExamStartCard(
                                  isUpcoming: false,
                                  data: bannerController.archiveExamList[index],
                                  isLiveExam: true,
                                  isModelTest: false,
                                );
                              });
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
