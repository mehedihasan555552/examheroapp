import 'package:flutter/material.dart';

import '../config/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;

  const TextFieldContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),


      decoration: const BoxDecoration(
        color: kPrimaryColor,

        image: DecorationImage(
          image: AssetImage("assets/field design.png"), // Your top background image
          fit: BoxFit.fill,

        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(29.0),
          topLeft: Radius.circular(29.0) ,
          topRight:  Radius.circular(29.0),
          bottomRight: Radius.circular(29.0),
        ),
      ),

      child: child,
    );
  }
}
