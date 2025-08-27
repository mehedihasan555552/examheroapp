import 'package:flutter/material.dart';
import '../config/constants.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
class IconeLargeWithText extends StatelessWidget {
  final String title;
  final String subTitile;
  final String subTitile2;
  final VoidCallback press;
  final Image image;

  const IconeLargeWithText({
    required this.image,
    required this.title,
    required this.subTitile,
    required this.subTitile2,
    required this.press,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height*0.07,
      width: Get.width*0.42,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10)
            
      ),

      child: Row(
        children: [
          IconButton(
            onPressed: press,
            icon: image,
          ),
         Container(

           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Center(
                 child: Text(
                   title,
                   style:  TextStyle(
                     fontSize: 12,
                     fontWeight: FontWeight.bold
                   ),
                 ),
               ),
               Center(
                 child: Text(
                   subTitile,
                   maxLines: 2,
                   style:  TextStyle(
                     fontSize: 8,
                   ),
                 ),
               ),
               Center(
                 child: Text(
                   subTitile2,
                   maxLines: 2,
                   style:  TextStyle(
                     fontSize: 8,
                   ),
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
