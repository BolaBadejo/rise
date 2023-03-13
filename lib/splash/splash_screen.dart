import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rise/business_logic/update_fcm_token/update_fcm_token_bloc.dart';
import 'package:rise/pages/artisan/home_artisan/home_nav_screen.dart';
import 'package:rise/pages/user/home/home_nav_screen.dart';
import 'package:rise/pages/vendor/home_vendor/home_nav_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../constants.dart';
import '../onboard/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  AnimationController? animationController;
  Animation<double>? logoAnimation;
  Animation<double>? textAnimation;
  Animation<double>? imageAnimation;
  Animation<Offset>? imageOffsetAnimation;

  bool isLoggedIn = false;

  void navigateUser() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    // DateTime expiration =
    //     sharedPreference.containsKey('expiration_time') as DateTime;
    // var difference = DateTime.now().difference(expiration);
    // if (!difference.isNegative) {
    if (sharedPreference.containsKey('access_token')) {
      var type = sharedPreference.get('user_type').toString();
      if (type == 'Artisan' || type == 'artisan') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeNavScreenArtisan()));
      } else if (type == 'Vendor' || type == 'vendor') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeNavScreenArtisan()));
      } else if (type == 'Default' || type == 'default') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeNavScreen()));
      } else {}
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      //// print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });

    Timer(const Duration(seconds: 5), () => navigateUser());

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<UpdateFcmTokenBloc>().add(LoadUpdateFcmTokenEvent());
    // });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: -5,
            right: -5,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Image.asset(
                "assets/images/bg_transparent.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/ic_launcher.png',
              height: 130,
              // fit: BoxFit.contain,
              // height: 5.h,
            ),
          ),
        ],
      ),
    );
  }
}
