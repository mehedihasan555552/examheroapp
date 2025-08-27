import 'package:flutter/material.dart';

import '../../../config/constants.dart';

class subTopicsListView extends StatelessWidget {
  const subTopicsListView({
    super.key,
    required this.size,
    required this.subImage,
    required this.mainTopic,
  });

  final Size size;
  final Image subImage;
  final List<String> mainTopic;

  @override
  Widget build(BuildContext context) {
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
                  onTap: () {},
                  leading: subImage,
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
