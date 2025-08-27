import 'package:flutter/material.dart';
import 'package:mission_dmc/screens/inner_screens/sub_topics_screen.dart';

import '../../../config/constants.dart';

class ListOfTopicsView extends StatelessWidget {
  final Image image;

  const ListOfTopicsView({
    super.key,
    required this.image,
    required this.mainTopic,
  });

  final List<String> mainTopic;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      //Full Container For ListView
      margin: EdgeInsets.only(top: size.height * .24),
      color: kPrimaryLightColor,
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            //for A single ListView
            margin: const EdgeInsets.only(bottom: 7),

            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              child: Container(
                //Inner margin Padding
                padding: const EdgeInsets.all(15),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubTopicScrenn(
                          subImage: image,
                          subText: mainTopic[index],
                        ),
                      ),
                    );
                  },
                  leading: image,
                  title: Text(
                    mainTopic[index],
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: mainTopic.length,
      ),
    );
  }
}
