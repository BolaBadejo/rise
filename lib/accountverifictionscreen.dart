import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/auth/signin_screen.dart';
import 'package:rise/pages/auth/verify_email.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:sizer/sizer.dart';

class AccountVerificationScreen extends StatelessWidget {
  const AccountVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Container(),
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
        children: [
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
            child: Column(
              children: [
                const SizedBox(height: defaultPadding * 10.0),
                Image.asset("assets/images/rise-check.gif"),
                const SizedBox(height: defaultPadding * 2.0),
                Center(
                  child: Text(
                    "Your account has\nbeen created\nsuccessfully!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp),
                  ),
                ),
                const SizedBox(height: defaultPadding * 2.0),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0, left: 32.0),
                  child: RiseButton(
                    text: "verify email",
                    buttonColor: blackColor,
                    textColor: whiteColor,
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const VerifyEmail(where: 'registration')),
                          (route) => false);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
                          (route) => false);
                    },
                    child: Text(
                      "Return to Login",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
