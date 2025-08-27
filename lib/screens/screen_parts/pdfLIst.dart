import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mission_dmc/config/constants.dart';
import 'package:mission_dmc/screens/screen_parts/pdf_viewPage.dart';

import '../../controllers/auth_controller.dart';
import '../../update_controllers/banner_controller.dart';
import '../mcq_preparation/package_view.dart';

class PdfListPageView extends StatelessWidget {
  const PdfListPageView({
    super.key,
    required this.bannerController,
    required this.authController,
  });

  final BannerController bannerController;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.12), // Adjust height
        child: Stack(
          children: [
            Container(
              height: Get.height * 0.2,
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
              child: const Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text(
                      "LIBRARY ROOM",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Positioned(
              top: 10, // Adjust based on your layout
              left: 4,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white,size: 30,),
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
          SizedBox(
            height: 20,
          ),

          Center(child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text("Marked Book (PDF)",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
              SizedBox(width: 6,),
              Container(
              
                height: 20,
                width: 50,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(2)
                ),

                child: Center(child: Text("Free")),
              )
            ],
          )),
          SizedBox(
            height: 5,
          ),
          Obx(() {
            if (bannerController.freePdfList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                height: 200,
               
                decoration: BoxDecoration(
                  color: pdfContainer,
                  borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: kPrimaryColor,
                      width: 2.5
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.builder(
                    gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of columns
                      crossAxisSpacing: 4, // Horizontal spacing between items
                      mainAxisSpacing: 4,
                      childAspectRatio: 2/3
                      // Vertical spacing between items// Aspect ratio of each item
                    ),
                    itemCount: bannerController.freePdfList.length,
                    itemBuilder: (context, index) {
                      final pdf = bannerController.freePdfList[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ShowNoticePDFView(pdfUrl: pdf.file));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red, // Icon color
                              size: 64, // Icon size
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pdf.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 30,),
          Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Text("ExamHero Special (PDF)",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            SizedBox(width: 6,),
            Container(

              height: 20,
              width: 50,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(2)
              ),

              child: Center(child: Text("Paid")),
            )

          ],)),

          SizedBox(
            height: 5,
          ),

          Obx(()=>int.tryParse(authController.profile.value.package
              .toString()) !=
              null?bannerController.paidPdfList.isEmpty? CircularProgressIndicator():
           Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(

                  height: 200,
                  decoration: BoxDecoration(
                      color: pdfContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: kPrimaryColor,
                          width: 2.5
                      )
                  ),
                  child:  GridView.builder(
                    gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Number of columns
                        crossAxisSpacing: 4, // Horizontal spacing between items
                        mainAxisSpacing: 4,
                        childAspectRatio: 2/3
                      // Vertical spacing between items// Aspect ratio of each item
                    ),
                    itemCount: bannerController.paidPdfList.length,
                    itemBuilder: (context, index) {
                      final pdf = bannerController.paidPdfList[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ShowNoticePDFView(pdfUrl: pdf.file));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red, // Icon color
                              size: 64, // Icon size
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pdf.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )



                // ListView.builder(
                //   itemCount: bannerController.paidPdfList.length,
                //   itemBuilder: (context, index) {
                //     final pdf = bannerController.paidPdfList[index];
                //     return ListTile(
                //       leading: Icon(
                //         Icons.picture_as_pdf,
                //         color: pdf.isFree ? Colors.green : Colors.red,
                //       ),
                //       title: Text(pdf.title),
                //       subtitle: Text("Topic: ${pdf.topic}"),
                //       onTap: () {
                //         Get.to(() => ShowNoticePDFView(pdfUrl: pdf.file));
                //       },
                //     );
                //   },
                // ),
              ),
            )
         : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(

                height: 200,
                decoration: BoxDecoration(
                    color: pdfContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: kPrimaryColor,
                        width: 2.5
                    )
                ),
                child:  GridView.builder(
                  gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of columns
                      crossAxisSpacing: 4, // Horizontal spacing between items
                      mainAxisSpacing: 4,
                      childAspectRatio: 2/3
                    // Vertical spacing between items// Aspect ratio of each item
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    //final pdf = bannerController.paidPdfList[index];
                    return GestureDetector(
                      onTap: () {
                        // Get.to(() => ShowNoticePDFView(pdfUrl: pdf.file));
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

                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red, // Icon color
                            size: 64, // Icon size
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'pdf-$index',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )



              // ListView.builder(
              //   itemCount: bannerController.paidPdfList.length,
              //   itemBuilder: (context, index) {
              //     final pdf = bannerController.paidPdfList[index];
              //     return ListTile(
              //       leading: Icon(
              //         Icons.picture_as_pdf,
              //         color: pdf.isFree ? Colors.green : Colors.red,
              //       ),
              //       title: Text(pdf.title),
              //       subtitle: Text("Topic: ${pdf.topic}"),
              //       onTap: () {
              //         Get.to(() => ShowNoticePDFView(pdfUrl: pdf.file));
              //       },
              //     );
              //   },
              // ),
            ),
          ))




        ],
      )
    );
  }
}
