import 'package:flutter/material.dart';
import 'package:mission_dmc/screens/inner_screens/screens_parts/inner_page_header.dart';
import 'package:mission_dmc/screens/inner_screens/screens_parts/sub_topic_list_view.dart';

import '../../config/constants.dart';

class SubTopicScrenn extends StatelessWidget {
  static const id = 'sub_topic_screen';
  final Image subImage;
  final String subText;
  const SubTopicScrenn(
      {super.key, required this.subImage, required this.subText});
  @override
  Widget build(BuildContext context) {
    List<String> mainTopic = [
      "Biology 1st Part",
      "Biology 2nd Part",
      "Physics 1st Part",
      "Physics 2nd Part",
      "English 1st Part",
    ];
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
                  text: subText,
                  image: subImage,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            subTopicsListView(
                size: size, subImage: subImage, mainTopic: mainTopic),
          ],
        ),
      ),
    );
  }
}
