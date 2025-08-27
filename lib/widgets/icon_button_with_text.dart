import 'package:flutter/material.dart';
import 'package:mission_dmc/config/constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
class IconeButtonWithText extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final String assetImagePath; // Path to the asset image

  const IconeButtonWithText({
    required this.press,
    required this.assetImagePath,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: press,
          child: Image.asset(
            assetImagePath,
            width: 55, // Adjust size as needed
            height: Get.height * 0.054, // Adjust size as needed
          ),
        ),
        Text(text,style: TextStyle(color: kPrimaryColor),),
      ],
    );
  }
}

