import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rise/constants.dart';
import 'package:sizer/sizer.dart';

import 'components/otpform.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.back, size: 18),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 64),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
      body: Stack(children: <Widget>[
        SizedBox(),
        SafeArea(
          child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 65.0, right: 20.0, bottom: 4.0),
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
                                  color: blackColor,
                                  // fontFamily: 'Chillax',
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      'Please enter the four (4) digit code we have sent to your number',
                                  style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: const Color(0xff313131)
                                          .withOpacity(0.49),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Text(
                                "+234${widget.phoneNumber.substring(1)}",
                                style: GoogleFonts.poppins(
                                    // fontFamily: 'Chillax',
                                    color: const Color(0xff919191),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: defaultPadding),
                              //  GestureDetector(
                              //    onTap: (){
                              //      Navigator.of(context).pop();
                              //    },
                              //   child: SvgPicture.asset(
                              //     "assets/icons/edit.svg",
                              //     width: 24,
                              //     height: 24,
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          OtpForm(phoneNumber: widget.phoneNumber),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ]),
    );
  }
}
