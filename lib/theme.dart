import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: whiteColor,
    fontFamily: "Chillax",
    appBarTheme: appBarTheme(),
    primarySwatch: Colors.red,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryColor, //thereby
    ),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.transparent),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    // floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: whiteColor,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle:
        TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Outfit'),
    toolbarTextStyle:
        TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Outfit'),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}
