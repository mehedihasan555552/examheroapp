import 'package:flutter/material.dart';

import 'home_screen_parts.dart';
import 'home_stack_design.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // HomePageContainer1(size: size),
        // HomePage2ndPart(),
      ],
    );
  }
}
