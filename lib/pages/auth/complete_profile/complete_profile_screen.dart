import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../constants.dart';
import 'components/complete_profile_form.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key, required this.phoneNumber})
      : super(key: key);
  final String phoneNumber;

  @override
  State<StatefulWidget> createState() {
    return CompleteProfileScreenState();
  }
}

class CompleteProfileScreenState extends State<CompleteProfileScreen> {
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: 4.h,
                ),
              ],
            ),
          ),
        ],
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
                height: 100.h,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 32.0,
                            top: 32.0,
                            right: 32.0,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "This won't take time",
                              style: GoogleFonts.poppins(
                                  wordSpacing: 0.5,
                                  letterSpacing: -1,
                                  color: blackColor,
                                  // fontFamily: 'Chillax',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Let’s create your account!",
                              style: GoogleFonts.poppins(
                                  wordSpacing: 0.5,
                                  letterSpacing: -1,
                                  color: blackColor,
                                  // fontFamily: 'Chillax',
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: defaultPadding / 2.0,
                            ),
                            Text(
                              "Input the information below to create your log on credentials ",
                              style: TextStyle(
                                  // fontFamily: 'Outfit',
                                  color: grayColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: defaultPadding * 2.0),
                            CompleteProfileForm(
                                phoneNumber: widget.phoneNumber),
                            // const Expanded(child: SizedBox())
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
