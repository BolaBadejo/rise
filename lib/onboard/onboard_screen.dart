import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rise/constants.dart';
import 'package:sizer/sizer.dart';
import '../../data/model/onboarding/onboard_content_model.dart';
import 'dart:io' show Platform;

import '../../pages/auth/signin_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OnBoardingScreenState();
  }
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  PageController? _controller;
  var indicatorValue = 0.0;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          controller: _controller,
          itemCount: contents.length,
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (_, i) {
            return Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(contents[i].image),
                ),
                Positioned(
                  top: Platform.isAndroid ? 0 : 20,
                  left: MediaQuery.of(context).size.width / 1.35,
                  right: 0,
                  bottom: MediaQuery.of(context).size.height / 1.12,
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()));
                        },
                        child: Row(
                          children: [
                            Text(
                              "Skip",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp),
                            ),
                            const SizedBox(width: 4.0),
                            const Icon(Icons.arrow_forward, color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height - 350,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 400,
                    color: primaryColor.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding * 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contents[i].title,
                            style: TextStyle(
                                // fontFamily: 'Outfit',
                                color: whiteColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: defaultPadding * 2.0,
                          ),
                          Text(
                            contents[i].description,
                            style: TextStyle(
                                // fontFamily: 'Outfit',
                                color: whiteColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height - 85,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: const LinearProgressIndicator(
                    value: 5.0,
                    color: Colors.amber,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height - 80,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      if (currentIndex == contents.length - 1) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignInScreen(),
                            ),
                            (route) => false);
                      }
                      _controller?.nextPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: Container(
                      height: 50,
                      color: whiteColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            currentIndex == contents.length - 1
                                ? "Get Started"
                                : "Next",
                            style: TextStyle(
                                // fontFamily: 'Outfit',
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp),
                          ),
                          const Icon(
                            CupertinoIcons.forward,
                            color: primaryColor,
                          ),
                          const SizedBox(width: defaultPadding),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
