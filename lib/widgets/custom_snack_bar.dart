import 'package:flutter/material.dart';

void showCustomSnackBar(
    BuildContext context, String text, Color color, Color textColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      elevation: 0.0,
      content: Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            // fontFamily: 'Chillax',
          ),
        ),
      ),
    ),
  );
}
