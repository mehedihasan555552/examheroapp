
// class HomePage2ndPart extends StatelessWidget {
//   HomePage2ndPart({
//     Key? key,
//   }) : super(key: key);
//
//   final AuthController _authController = Get.find();
//   final bannerController = Get.put(BannerController());
//
//   @override
//   Widget build(BuildContext context) {
//
//     Size size = MediaQuery.of(context).size;
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //Ends Of 1st Parts
//       children: [
//         //Ends of 1st Parts
//         // Container(
//         //   margin: const EdgeInsets.symmetric(vertical: 10),
//         //   child: Column(
//         //     crossAxisAlignment: CrossAxisAlignment.start,
//         //     children: [
//         //       Padding(
//         //         padding: const EdgeInsets.symmetric(horizontal: 10),
//         //         child: Row(
//         //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //           children: [
//         //           Text("prepMed",style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),),
//         //
//         //           Row(children: [
//         //             Icon(Icons.notifications,size: 35,color: Colors.white,),
//         //             IconButton(icon: Icon(Icons.menu,size: 35,color: Colors.white,),onPressed: (){
//         //                  MenuScreen();
//         //             },)
//         //           ],)
//         //
//         //
//         //         ],)
//         //       ),
//         //
//         //       Container(),
//         //       // Obx(() {
//         //       //   return Row(
//         //       //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         //       //     crossAxisAlignment: CrossAxisAlignment.center,
//         //       //     children: [
//         //       //       _authController.profile.value.profile_image == null
//         //       //           ? ClipRRect(
//         //       //               borderRadius: BorderRadius.circular(100),
//         //       //               child: Image.asset(
//         //       //                 'assets/default/profile.jpg',
//         //       //                 width: 70,
//         //       //               ),
//         //       //             )
//         //       //           : ClipRRect(
//         //       //               borderRadius: BorderRadius.circular(100),
//         //       //               child: CachedNetworkImage(
//         //       //                 imageUrl:
//         //       //                     _authController.profile.value.profile_image!,
//         //       //                 width: 70,
//         //       //               ),
//         //       //             ),
//         //       //       Column(
//         //       //         mainAxisAlignment: MainAxisAlignment.center,
//         //       //         crossAxisAlignment: CrossAxisAlignment.start,
//         //       //         children: [
//         //       //           Text(
//         //       //             _authController.profile.value.full_name!,
//         //       //             style: kBoldTextStyle,
//         //       //           ),
//         //       //           Text(
//         //       //             _authController.profile.value.user!.phone!,
//         //       //             style: kNormalTextStyle,
//         //       //           ),
//         //       //           Text(
//         //       //             'Package Status: ${int.tryParse(_authController.profile.value.package.toString()) != null ? 'Active' : 'Not Active'}',
//         //       //             style: kNormalTextStyle,
//         //       //           ),
//         //       //         ],
//         //       //       ),
//         //       //       Column(
//         //       //         mainAxisAlignment: MainAxisAlignment.center,
//         //       //         children: [
//         //       //           IconButton(
//         //       //             onPressed: () {
//         //       //               // Get.snackbar(
//         //       //               //   'Coming soon',
//         //       //               //   "This feature will be available soon.",
//         //       //               //   backgroundColor: Colors.green,
//         //       //               //   colorText: Colors.white,
//         //       //               //   snackPosition: SnackPosition.BOTTOM,
//         //       //               // );
//         //       //               Get.to(() => const ChatListView());
//         //       //             },
//         //       //             icon: const Icon(
//         //       //               Icons.message,
//         //       //               size: 40,
//         //       //               color: kWhiteColor,
//         //       //             ),
//         //       //           ),
//         //       //           const Text(
//         //       //             "Check Inbox",
//         //       //             style: TextStyle(fontSize: 12, color: Colors.white),
//         //       //           ),
//         //       //         ],
//         //       //       ),
//         //       //     ],
//         //       //   );
//         //       // }),
//         //       //First Row Ended
//         //       SizedBox(
//         //         height: 20,
//         //       ),
//         //       Center(
//         //         child: Container(
//         //           width: size.width * .9,
//         //           padding: const EdgeInsets.only(
//         //             top: 5,
//         //             left: 2,
//         //             right: 2,
//         //             bottom: 10,
//         //           ),
//         //           decoration: BoxDecoration(
//         //             borderRadius: BorderRadius.circular(50),
//         //             color: Colors.white,
//         //           ),
//         //           child: Row(
//         //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         //             crossAxisAlignment: CrossAxisAlignment.center,
//         //             children: [
//         //               IconeButtonWithText(
//         //                 press: () {
//         //                   if (int.tryParse(_authController.profile.value.package
//         //                           .toString()) !=
//         //                       null) {
//         //                     Get.defaultDialog(
//         //                       title: 'Notice',
//         //                       middleText:
//         //                           'You have already purchased this package.',
//         //                       textConfirm: 'OK',
//         //                       onConfirm: () {
//         //                         Get.back(); // Closes the dialog
//         //                       },
//         //                       confirmTextColor: Colors.white,
//         //                     );
//         //                   } else {
//         //                     Get.to(PackageView());
//         //                   }
//         //                 },
//         //                 text: 'Course',
//         //                 assetImagePath: 'assets/Course.png',
//         //               ),
//         //               IconeButtonWithText(
//         //                 press: () {
//         //                   // Navigator.pushNamed(context, ProfileScreen.id);
//         //                   Get.to(() => ProfileScreen(
//         //                       userId: _authController.profile.value.user!.uid!));
//         //                 },
//         //                 text: 'Profile',
//         //                  assetImagePath: 'assets/pro.png',
//         //               ),
//         //               IconeButtonWithText(
//         //                 press: () {
//         //                   Get.to(
//         //                     () => PerformanceScreen(),
//         //                     fullscreenDialog: true,
//         //                   );
//         //                 },
//         //                 text: 'Performance',
//         //                 assetImagePath: 'assets/Performance.png',
//         //               ),
//         //             ],
//         //           ),
//         //         ),
//         //       ),
//         //     ],
//         //   ),
//         // ),
//
//
//
//
//
//
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//               // "LIVE" badge
//               Row(
//                 children: [
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
//                     decoration: BoxDecoration(
//                       color: bannerController.liveExamList.isEmpty?Colors.grey:Colors.red,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child:  Row(
//                       children: [
//
//
//                         Text(
//                           'LIVE',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(width: 4),
//                         Icon(
//                           Icons.circle,
//                           size: 12,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // InkWell(
//                   //   onTap: (){
//                   //     Get.to(()=> ModelTestListView());
//                   //   },
//                   //   child: const Text(
//                   //     'MODEL TEST',
//                   //     style: TextStyle(
//                   //       fontSize: 16,
//                   //       fontWeight: FontWeight.bold,
//                   //       color: kPrimaryColor,
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//
//               // "More>" link
//               InkWell(
//                 onTap: (){
//                   Get.to(() =>LiveExamView());
//                 },
//                 child: Text(
//                   'More>',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ],
//           )),
//         ),
//
//
//         //Slide
//         GestureDetector(
//           onTap: (){
//             Get.to(()=>LiveExamm(bannerController: bannerController,));
//           },
//           child: FutureBuilder(
//               future: bannerController.fetchTopBannerList(),
//               builder: (context, snapshot) {
//                 return Container(
//                   margin: const EdgeInsets.only(top: 3),
//                   //Slider Container
//                   child: CarouselSlider(
//                     options: CarouselOptions(
//                       height: 100.0,
//                       aspectRatio: 2.0,
//                       enlargeCenterPage: true,
//                       scrollDirection: Axis.horizontal,
//                       autoPlay: true,
//                     ),
//                     items: bannerController.topBannerList.map(
//                           (i) {
//                         return Builder(
//                           builder: (BuildContext context) {
//                             return Container(
//                               width: MediaQuery.of(context).size.width,
//                               decoration: const BoxDecoration(
//                                 color: Colors.amber,
//                               ),
//                               child: i['banner'] != null && i['banner'].isNotEmpty
//                                   ? Image.network(
//                                 i['banner'],
//                                 fit: BoxFit.cover,
//                               )
//                                   : Center(
//                                 child: Text(
//                                   'No Banner Available',
//                                   style: TextStyle(fontSize: 16, color: Colors.white),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ).toList()
//
//                   ),
//                 );
//               }),
//         ),
//         SizedBox(
//           height: 3,
//         ),
//
//         //Package
//         Obx(() {
//           return int.tryParse(
//               _authController.profile.value.package.toString()) ==
//               null
//               ?   Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Center(
//               child: Container(
//                 height: 45,
//                 decoration: const BoxDecoration(
//                   color: kPrimaryColor,
//
//                   image: DecorationImage(
//                     image: AssetImage("assets/final_top_bar.png"), // Your top background image
//                     fit: BoxFit.fill,
//
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(29.0),
//                     topLeft: Radius.circular(29.0) ,
//                     topRight:  Radius.circular(29.0),
//                     bottomRight: Radius.circular(29.0),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     // Overlapping images on the left
//                     SizedBox(
//                       width: 90, // Adjust width for the stack of images
//                       child: Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           Positioned(
//                             left: -6,
//                        bottom: -10,
//
//                             child: ClipOval(
//                               child:Image.asset(
//                                 'assets/logo_pack.png',
//                                 height: 80,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//                         Text(
//                           'Unlock Your package for',
//                           textAlign: TextAlign.center,
//                           maxLines: 3,
//                           style: TextStyle(fontSize: 10,color: Colors.white),
//                         ),
//
//                         Text(
//                           'your full preparation with prepMED',
//                           textAlign: TextAlign.center,
//                           maxLines: 3,
//                           style: TextStyle(fontSize: 10,color: Colors.white),
//                         ),
//                       ],
//                     ),
//                     // "See more" text on the right
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: kWhiteColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(40.0),
//                         ),
//                         // fixedSize: Size(100, 40),
//                       ),
//                       onPressed: () {
//                         // Get.to(() => PackageView(), fullscreenDialog: true);
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text(
//                                 'Premium Feature',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               content: const Text(
//                                 'To unlock this course you have to purchase it.',
//                               ),
//                               actions: [
//                                 // Cancel Button
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop(); // Close the popup
//                                   },
//                                   child: const Text(
//                                     'Cancel',
//                                     style: TextStyle(color: Colors.red),
//                                   ),
//                                 ),
//                                 // OK Button
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop(); // Close the popup
//                                     Get.to(() => PackageView(), fullscreenDialog: true); // Redirect
//                                   },
//                                   child: const Text(
//                                     'OK',
//                                     style: TextStyle(color: kPrimaryColor),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                       child: const Text(
//                         'Package',
//                         style: TextStyle(
//                           color: kPrimaryColor,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )
//               : Container();
//         }),
//
//
//
//
//     SizedBox(
//       height: 3,
//     ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: Container(
//             height: size.height * 0.230,
//             decoration: const BoxDecoration(
//               color: Colors.red,
//               image: DecorationImage(
//                 image: AssetImage("assets/final_top_bar.png"),
//                 // Your top background image
//                 fit: BoxFit.fill,
//               ),
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(24.0),
//                 topLeft: Radius.circular(24.0),
//                 bottomLeft: Radius.circular(24.0),
//                 bottomRight: Radius.circular(24.0),
//               ),
//             ),
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 6),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 2,
//                     ),
//                     Container(
//                       child: Row(
//                         children: [
//                           InkWell(
//                             onTap: (){
//                               Get.to(() => ModelTestListView());
//                             },
//                             child: IconeLargeWithText(
//                               title: 'Model Test',
//                               press: () {
//                                 // Navigator.pushNamed(context, CentralTest.id);
//
//                               },
//                               image: Image.asset(
//                                 'assets/mt.png',
//                                 height: 60,
//                               ),
//                               subTitile: 'Medical standard model',
//                               subTitile2: 'Question(100 marks)',
//                             ),
//                           ),
//                           InkWell(
//                             onTap: (){
//                               bannerController.fetchFreePdfLists();
//                               bannerController.fetchPaidPdfLists();
//                               Get.to(()=> PdfListPageView(bannerController: bannerController,));
//
//
//                             },
//                             child: IconeLargeWithText(
//                               title: 'Library Room',
//                               press: () {
//                                 // Navigator.pushNamed(context, VideoLecture.id);
//                                 //Get.to(const LiveExamView());
//                               },
//                               image: Image.asset(
//                                 'assets/lr.png',
//                                 height: 60,
//                               ),
//                               subTitile: 'Marked Book, Hand Notes',
//                               subTitile2: 'GKE bulletines & PDF',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.only(top: 2),
//                       child: Row(
//                         children: [
//                           InkWell(
//                             onTap: (){
//                               Navigator.pushNamed(context, MCQTest.id);
//                             },
//                             child: IconeLargeWithText(
//                               title: 'MCQ Preparation',
//                               press: () {
//                                 Navigator.pushNamed(context, MCQTest.id);
//                               },
//                               image: Image.asset(
//                                 'assets/mcqp.png',
//                                 height: 60,
//                               ),
//                               subTitile: 'Medical & University ',
//                               subTitile2: 'Question bank',
//                             ),
//                           ),
//                           InkWell(
//                             onTap: (){
//                               Get.to(const BookMarksView());
//                             },
//                             child: IconeLargeWithText(
//                               title: 'BookMarks',
//                               press: () {
//                                 // Navigator.pushNamed(context, FlashCard.id);
//                                 Get.to(const BookMarksView());
//                               },
//                               image: Image.asset(
//                                 'assets/bm.png',
//                                 height: 60,
//
//                               ),
//                               subTitile: 'Learn from your',
//                               subTitile2: 'mistakes',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 2,
//         ),
//         Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomGradientButton(
//                 text: "Live Exam",
//                 gradientColors: [
//                   Color(0xFF388CF4),
//                   Color(0xFF3894CC)],
//                 onTap: () {
//                   Get.to(()=>LiveExamm(bannerController: bannerController,));
//                 },
//               ),
//               SizedBox(width: 10),
//               CustomGradientButton(
//                 text: "Upcoming",
//                 gradientColors: [
//                   Color(0xFF388CF4),
//                   Color(0xFF3894CC)],
//                 onTap: () {
//                   Get.to(()=>UpComing(bannerController: bannerController,));
//                   // Action for Upcoming
//                 },
//               ),
//               SizedBox(width: 10),
//               CustomGradientButton(
//                 text: "Archive",
//                 gradientColors: [Color(0xFF388CF4), Color(0xFF3894E4)],
//                 onTap: () {
//                   // Action for Archive
//                   Get.to(()=>Archive(bannerController: bannerController,));
//
//                 },
//               ),
//             ],
//           ),
//         ),
//         FutureBuilder(
//             future: bannerController.fetchBannerList(),
//             builder: (context, snapshot) {
//               return Container(
//                 margin: const EdgeInsets.only(top: 5),
//                 //Slider Container
//                 child: CarouselSlider(
//                   options: CarouselOptions(
//                     height: 98.0,
//                     aspectRatio: 2.0,
//                     enlargeCenterPage: true,
//                     scrollDirection: Axis.horizontal,
//                     autoPlay: true,
//                   ),
//                   items: bannerController.bannerList.map(
//                         (i) {
//                       return Builder(
//                         builder: (BuildContext context) {
//                           return Container(
//                             width: MediaQuery.of(context).size.width,
//                             decoration: const BoxDecoration(
//                               color: Colors.amber,
//                             ),
//                             child: i['bannersecond'] != null && i['bannersecond'].isNotEmpty
//                                 ? Image.network(
//                               i['bannersecond'],
//                               fit: BoxFit.cover,
//                             )
//                                 : Center(
//                               child: Text(
//                                 'No Banner Available',
//                                 style: TextStyle(fontSize: 16, color: Colors.white),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ).toList()
//
//                 ),
//               );
//             }),
//         SizedBox(height: Get.height* 0.004,),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: Container(
//             width: Get.width* double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
//             decoration: const BoxDecoration(
//               color: Colors.red,
//               image: DecorationImage(
//                 image: AssetImage("assets/final_top_bar.png"),
//                 // Your top background image
//                 fit: BoxFit.fill,
//               ),
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(24.0),
//                 topLeft: Radius.circular(24.0),
//                 bottomLeft: Radius.circular(24.0),
//                 bottomRight: Radius.circular(24.0),
//               ),
//             ),
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // "Hi, Zunaed" Section
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color(0xFF60DCE4),
//                           Color(0xFF349CD0),
//                           Color(0xFF2054B4),
//                         ],
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         // "Hi, Zunaed" Section
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(2),
//
//                               child: Image.asset("assets/window.png",height: 25,)
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               _authController.profile.value.full_name!,
//                               style: TextStyle(fontSize: 16,color: Colors.white)
//                             ),
//                             SizedBox(
//                               width: 20,
//                             )
//                           ],
//                         ),
//
//                       ],
//                     ),
//                   ),
//                   // Container(
//                   //   height: 120.0,
//                   //   width: 120.0,
//                   //   decoration: BoxDecoration(
//                   //     image: DecorationImage(
//                   //       image: AssetImage(
//                   //           'assets/assets/alucard.jpg'),
//                   //       fit: BoxFit.fill,
//                   //     ),
//                   //     shape: BoxShape.circle,
//                   //   ),
//                   // )
//
//                   // Calendar Icon
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>  ExamRoutine(),
//                         ),
//                       );
//
//
//                     },
//                     child: Container(
//                         height: 50,
//                         child: Image.asset('assets/st.png',)),
//                   ),
//
//
//                   // Chat Icon
//                   IconButton(
//                     onPressed: (){},
//                     icon: Image.asset('assets/text_sms-removebg-preview(2).png',color: Colors.white,height: 25,),
//                   ),
//
//                   // Profile Icon
//                   const Icon(
//                     Icons.search,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//
//
//
//
//
//         // Add the TabBar and TabBarView for Live Exam, Archive, and Upcoming
//         // DefaultTabController(
//         //   length: 3, // Number of tabs
//         //   child: Column(
//         //     children: [
//         //       Container(
//         //         margin: const EdgeInsets.only(top: 20),
//         //         child: const TabBar(
//         //           labelColor: Colors.black,
//         //           indicatorColor: kPrimaryColor,
//         //           tabs: [
//         //             Tab(text: "Live Exam"),
//         //             Tab(text: "Upcoming"),
//         //             Tab(text: "Archive"),
//         //           ],
//         //         ),
//         //       ),
//         //       Container(
//         //         height: 200, // Adjust this height to fit your layout
//         //         margin: const EdgeInsets.only(top: 10),
//         //         child: TabBarView(
//         //           children: [
//         //             Center(
//         //               child: Obx(() {
//         //                 return ListView.builder(
//         //                     itemCount: bannerController.liveExamList.length,
//         //                     itemBuilder: (context, index) {
//         //                       return ExamStartCard(
//         //                           isUpcoming: false,
//         //                           data: bannerController.liveExamList[index],
//         //                           isModelTest: false,
//         //                           isLiveExam: true);
//         //                     });
//         //               }),
//         //             ),
//         //             Center(
//         //               child: Obx(() {
//         //                 return ListView.builder(
//         //                     itemCount: bannerController.upcomingExamList.length,
//         //                     itemBuilder: (context, index) {
//         //                       return ExamStartCard(
//         //                           data:
//         //                               bannerController.upcomingExamList[index],
//         //                           isModelTest: false,
//         //                           isUpcoming: true,
//         //                           isLiveExam: true);
//         //                     });
//         //               }),
//         //             ),
//         //             Center(
//         //               child: Obx(() {
//         //                 return ListView.builder(
//         //                     itemCount: bannerController.archiveExamList.length,
//         //                     itemBuilder: (context, index) {
//         //                       return ExamStartCard(
//         //                           isUpcoming: false,
//         //                           data: bannerController.archiveExamList[index],
//         //                           isModelTest: false,
//         //                           isLiveExam: true);
//         //                     });
//         //               }),
//         //             ),
//         //           ],
//         //         ),
//         //       ),
//         //     ],
//         //   ),
//         // ),
//       ],
//     );
//   }
// }

// class LiveExam extends StatelessWidget {
//   const LiveExam({
//     super.key,
//     required this.bannerController,
//   });
//
//   final BannerController bannerController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Obx(()=>ListView.builder(
//               itemCount: bannerController.liveExamList.length,
//               itemBuilder: (context, index) {
//                 return ExamStartCard(
//                     isUpcoming: false,
//                     data: bannerController.liveExamList[index],
//                     isModelTest: false,
//                     isLiveExam: true);
//               }))
//         ],
//       ),
//     );
//   }
// }

