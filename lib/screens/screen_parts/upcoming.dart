import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../update_controllers/banner_controller.dart';
import '../../widgets/update/exam_start_card.dart';

final AuthController _authController = Get.find();
final bannerController = Get.put(BannerController());
class UpComing extends StatelessWidget {
  const UpComing({super.key,required this.bannerController,});
  final BannerController bannerController;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.18), // Adjust height
        child: Container(
            height: Get.height * 0.3,
            decoration: const BoxDecoration(
              color: Colors.red,
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
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(width: Get.width*0.1,),
                    Image.asset(
                      "assets/icon1-removebg-preview.png",
                      height: 70,
                      color: Colors.white,
                    ),
                    SizedBox(width: Get.width*0.02,),
                    Text(
                      "UPCOMING EXAM",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            )),
      ),
      body: Center(
        child: Obx(() {
          return ListView.builder(
              itemCount: bannerController.upcomingExamList.length,
              itemBuilder: (context, index) {
                return ExamStartCard(
                    data:
                    bannerController.upcomingExamList[index],
                    isModelTest: false,
                    isUpcoming: true,
                    isLiveExam: true);
              });
        }),
      ),
    );
  }
}