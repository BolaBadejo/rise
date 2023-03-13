import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rise/constants.dart';
import 'package:sizer/sizer.dart';
import 'components/signupform.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.back, size: 18),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.pushReplacement(context,
                //      MaterialPageRoute(builder: (context) => new OnboardScreen()));
              },
            )),
        actions: [],
      ),
      body: Stack(
        children: <Widget>[
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
            child: SizedBox(
                width: double.infinity,
                height: 100.h,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 94.0, right: 20.0, bottom: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                            const SizedBox(
                              height: 16,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Let’s get you\nstarted\n',
                                style: GoogleFonts.poppins(
                                    wordSpacing: 0.5,
                                    letterSpacing: -1,
                                    color: blackColor,
                                    // fontFamily: 'Chillax',
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        'Please enter your 11 digit phone number below\n08012345678',
                                    style: GoogleFonts.poppins(
                                        // fontFamily: 'Chillax',
                                        color: grayColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            const SignUpForm(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
