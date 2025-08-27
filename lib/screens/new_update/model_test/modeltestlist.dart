import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../update_controllers/banner_controller.dart';
import '../../../widgets/update/exam_start_card.dart';

class ModelTestListView extends StatefulWidget {
  const ModelTestListView({super.key});

  @override
  State<ModelTestListView> createState() => _ModelTestListViewState();
}

class _ModelTestListViewState extends State<ModelTestListView> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    BannerController bannerController = Get.find();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.18), // Adjust height
        child: Stack(
          children: [
            Container(
              height: Get.height * 0.3,
              decoration: const BoxDecoration(
                color: Colors.red,
                image: DecorationImage(
                  image: AssetImage("assets/final_top_bar.png"),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icon3-removebg-preview.png",
                      height: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "MEDICAL QUESTION BANK",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "LAST 20 YEARS MBBS QUESTION",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10, // Adjust based on your layout
              left: 4,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white,size: 30,),
                onPressed: () {
                  // Navigate back
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stack(
          //   children: [
          //     Container(
          //       color: kPrimaryColor,
          //       height: Get.height * .23,
          //       width: double.infinity,
          //     ),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       //main colum started
          //       children: [
          //         IconButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           icon: const Icon(
          //             Icons.arrow_back,
          //             size: 40,
          //             color: Colors.white,
          //           ),
          //         ),
          //         //Container For header icon and text
          //         InnerHeader(
          //           text: 'Model Test',
          //           image: Image.asset(
          //             'assets/icons/mcqtest.png',
          //             height: 80,
          //             width: 80,
          //           ),
          //         ),
          //         // const SizedBox(
          //         //   height: 16,
          //         // ),
          //       ],
          //     ),
          //   ],
          // ),
          Obx(() {
            return FutureBuilder(
                future: bannerController.fetchModelList(),
                builder: (context, snapshot) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: bannerController.modeltestlist.length,
                        itemBuilder: (context, index) {
                          return ExamStartCard(
                            isUpcoming: false,
                            data: bannerController.modeltestlist[index],
                            isLiveExam: false,
                            isModelTest: true,
                          );
                        }),
                  );
                });
          }),
        ],
      ),
    );
  }
}
