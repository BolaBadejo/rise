import 'package:flutter/material.dart';
import 'package:rise/pages/auth/signin_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../constants.dart';
import '../../../widgets/rise_button.dart';

class AccountVerificationScreen extends StatelessWidget {
  const AccountVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   leading: Container(),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 16.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           Image.asset(
      //             'assets/images/logo.png',
      //             fit: BoxFit.contain,
      //             height: 30,
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/images/bg.png",
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: defaultPadding * 9.0),
                Image.asset("assets/images/unlock.png"),
                const SizedBox(height: defaultPadding * 2.0),
                Center(
                  child: Text(
                    "Your account has\nsuccessfully been created!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                Center(
                  child: Text(
                    "Begin getting clients in minutes by\nfilling your bio data.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: grayColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp),
                  ),
                ),
                const SizedBox(height: defaultPadding * 2.0),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0, left: 32.0),
                  child: RiseButton(
                    text: "Return to Login",
                    buttonColor: primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
                          (route) => false);
                    },
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
