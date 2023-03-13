import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rise/constants.dart';
import 'package:sizer/sizer.dart';

import 'components/signinform.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  void checkPermission() async {
    var locationStatus = await Permission.location.status;
    var storageStatus = await Permission.storage.status;
    if (locationStatus.isGranted) {
    } else if (locationStatus.isDenied) {
      if (await Permission.location.request().isGranted) {}
      if (storageStatus.isGranted) {
      } else if (storageStatus.isDenied) {
        if (await Permission.storage.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
          //// print("Permission was granted");
        }
      }
    }
  }

  @override
  initState() {
    checkPermission();
    super.initState();
  }

  var tap = 0;

  @override
  Widget build(BuildContext context) {
    DateTime pre_backpress = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= const Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          //show snackbar
          const snack = SnackBar(
            backgroundColor: blackColor,
            content: Text('Press Back button again to exit Rise'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: Container(),
        ),
        body: Stack(children: <Widget>[
          Positioned(
            bottom: -5,
            right: -5,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.6,
              child: Image.asset(
                "assets/images/bg.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                  width: double.infinity,
                  height: 100.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SingleChildScrollView(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: 32.0, top: 16.0, right: 32.0, bottom: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.contain,
                                      height: 5.h,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                RichText(
                                  text: TextSpan(
                                    text: 'Welcome, Log in \nto continue\n',
                                    style: GoogleFonts.poppins(
                                        color: blackColor,
                                        fontSize: 24.sp,
                                        wordSpacing: 0.5,
                                        letterSpacing: -1,
                                        fontWeight: FontWeight.w600),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            'Please enter your account credentials',
                                        style: GoogleFonts.poppins(
                                            color: grayColor,
                                            // fontFamily: 'Chillax',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const SignInForm(),
                          ],
                        ),
                      )),
                    ],
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}
