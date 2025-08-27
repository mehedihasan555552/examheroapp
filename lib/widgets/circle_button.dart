import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;
  final Color iconColor;
  final Color? backgroundColor;

  const CircleButton({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.onPressed,
    this.iconColor = Colors.black,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon),
        iconSize: iconSize,
        color: iconColor,
        onPressed: onPressed,
      ),
    );
  }
}
