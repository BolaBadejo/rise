import 'package:flutter/material.dart';
import 'package:rise/constants.dart';

class FilterCard extends StatelessWidget {
  const FilterCard(
      {Key? key,
      required this.text,
      required this.isSelected,
      required this.onPressed})
      : super(key: key);
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 100,
      margin: const EdgeInsets.only(top: 16.0, left: 0.0, right: 8.0),
      decoration: BoxDecoration(
        color: isSelected == true ? primaryColor : const Color(0xfff3f3f3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onPressed();
          },
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.0,
                color: isSelected == true ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
