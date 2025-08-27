import 'package:flutter/material.dart';

import '../../config/constants.dart';

class HomePageContainer1 extends StatelessWidget {
  const HomePageContainer1({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * .2,
      //padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF388CF4),
            Color(0xFF388CFC), // Left-side blue// Left-side blue
            Color(0xFF3894E4), // Left-side blue
            Color(0xFF389CCC), // Right-side greenish tint
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),

      //child Section Start
    );
  }
}
