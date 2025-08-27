import 'package:flutter/material.dart';
import 'package:mission_dmc/screens/inner_screens/screens_parts/inner_page_header.dart';
import 'package:mission_dmc/screens/inner_screens/screens_parts/maintopics_list.dart';

import '../../config/constants.dart';

class LectureNotes extends StatelessWidget {
  const LectureNotes({super.key});
  static const id = 'video_lecture';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> mainTopic = [
      "Physics 1st Part",
      "Physics 2nd Part",
      "English 1st Part",
    ];
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
                  text: 'Video Lecture',
                  image: Image.asset(
                    'assets/icons/videolecture.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            ListOfTopicsView(
              mainTopic: mainTopic,
              image: Image.asset(
                'assets/icons/videolecture.png',
                height: 100,
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
