import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RiseButton extends StatelessWidget {
  const RiseButton({
    Key? key,
    required this.text,
    required this.buttonColor,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.h),
        color: buttonColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  // fontFamily: 'Chillax',
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

class RiseButtonNew extends StatelessWidget {
  const RiseButtonNew({
    Key? key,
    required this.text,
    required this.buttonColor,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  final Widget text;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.h),
        color: buttonColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(child: text),
        ),
      ),
    );
  }
}
