import 'package:flutter/material.dart';

import '../config/constants.dart';

class RoundedButton extends StatelessWidget {
  final Color textColor;
  final String text;
  final VoidCallback pressed;
  final double? width; // Add optional width parameter
  final double? height; // Add optional height parameter
  final Color? backgroundColor; // Allow customization of the background color

  const RoundedButton({
    super.key,
    this.textColor = Colors.black,
    required this.text,
    required this.pressed,
    this.width, // Optional width
    this.height, // Optional height
    this.backgroundColor, // Optional background color
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: width ?? size.width * 0.8, // Default to 80% of screen width
      child: GestureDetector(
          onTap: pressed,
          child: Container(
                width: width ?? size.width * 0.7,
                height: height ?? size.height * 0.06,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:AssetImage("assets/field design.png"),
                      fit: BoxFit.fill
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(29.0),
                    topLeft: Radius.circular(29.0) ,
                    topRight:  Radius.circular(29.0),
                    bottomRight: Radius.circular(29.0),
                  ),
              ),

              child: Center(
                child: Text(
                        text,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: textColor,
                        ),
                ),
              )
          )
      )
      // Container(
      //   decoration: const BoxDecoration(
      //     color: kPrimaryColor,
      //
      //     image: DecorationImage(
      //       image: AssetImage("assets/field design.png"), // Your top background image
      //       fit: BoxFit.fill,
      //
      //     ),
      //     borderRadius: BorderRadius.only(
      //       bottomLeft: Radius.circular(29.0),
      //       topLeft: Radius.circular(29.0) ,
      //       topRight:  Radius.circular(29.0),
      //       bottomRight: Radius.circular(29.0),
      //     ),
      //   ),
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       minimumSize: Size(
      //         width ?? size.width * 0.7, // Default to 70% of screen width
      //         height ?? size.height * 0.06, // Default to 6% of screen height
      //       ),
      //     ),
      //     onPressed: pressed,
      //     child: Text(
      //       text,
      //       style: TextStyle(
      //         fontWeight: FontWeight.normal,
      //         color: textColor,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
