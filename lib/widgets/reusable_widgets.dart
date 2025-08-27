import 'package:flutter/material.dart';

Widget rPrimaryTextButton(
        {required backgroundColor,
        required buttonText,
        buttonTextColor = Colors.white,
        fontSize = 18.0,
        borderRadius = 10.0,
        required onPressed}) =>
    TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(buttonTextColor),
        backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        )),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );

Widget rPrimaryTextField({
  required controller,
  obscureText = false,
  readOnly = false,
  required keyboardType,
  required borderColor,
  prefixIcon,
  required hintText,
  maxLength,
  prefixText,
}) =>
    TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: keyboardType == TextInputType.multiline ? null : 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        labelText: hintText,
        hintText: hintText,
      ),
    );

Widget rPrimaryElevatedButton({
  required VoidCallback onPressed,
  required primaryColor,
  Size? fixedSize,
  required String buttonText,
  Color buttonTextColor = Colors.white,
  required double fontSize,
  FontWeight? fontWeight,
  double borderRadius = 4.0,
}) =>
    ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        fixedSize: fixedSize,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
            fontSize: fontSize, fontWeight: fontWeight, color: buttonTextColor),
      ),
    );

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> rShowSnackBar(
        {required BuildContext context,
        required String title,
        required Color color}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
    );
