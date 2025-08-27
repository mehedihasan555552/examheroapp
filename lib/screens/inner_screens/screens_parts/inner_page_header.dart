import 'package:flutter/material.dart';

import '../../../config/constants.dart';

class InnerHeader extends StatelessWidget {
  final String text;
  final Image image;
  const InnerHeader({
    required this.text,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: Row(
        //For header icon text design
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image,
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: kBoldTextStyle,
            ),
          )
        ],
      ),
    );
  }
}
