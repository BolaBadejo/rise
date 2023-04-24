import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/artisan/view_artisan.dart';
import 'package:rise/pages/auth/verify_email.dart';
import 'package:rise/pages/user/customer_profile/kyc/user-kyc.dart';
import 'package:rise/pages/user/market_place/product_detail.dart';
import '../../../../data/model/get_auth_user/get_auth_user_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../auth/signin_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  GetAuthUserResponse? userData;
  List names = ['', ''];

  @override
  void initState() {
    fetchDashboardData();
    fetchUserDetails().whenComplete(() {
      setState(() {});
    });
    topVendors();
    topArtisans();
    fetchTopListings();
    super.initState();
  }

  String totalBookings = '0';
  String totalBookingsCompleted = '0';

  Future<void> fetchDashboardData() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();

    try {
      final response = await get(
          Uri.parse('https://admin.rise.ng/api/dashboard/statistics'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print(data);
        // print("Dashboard data fetched");
        setState(() {
          // // print(data.message);
          // print(data['data']['totalBookings']);
          totalBookings = data['data']['totalBookings'].toString();
          totalBookingsCompleted =
              data['data']['totalBookingsCompleted'].toString();
          // // print(userData!.data);
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> fetchTopListings() async {
    // print('fetching listings...');
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      final response = await get(
          Uri.parse('https://admin.rise.ng/api/listing/top-listings/10'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      var data = jsonDecode(response.body.toString().replaceAll("\n", ""));
      // print(data);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString().replaceAll("\n", ""));
        // print(data);
        var result = data['data']['data'];
        List tempList = [];

        if (result != null) {
          for (var v in result) {
            tempList.add(v);
            // print('this is temp list');
            // print(tempList);
          }
        }
        setState(() {
          // fetchedListing = tempList;
        });

        // print(data);
        // print("Listings fetched");
      } else {
        // print(data['message']);

        setState(() {
          // state = '${data['message']}';
          // stateHeader = 'You have no listings here';
        });
      }
    } catch (e) {
      // print(e.toString());
      // print("exception, coundnt retrieve listing");
    }
  }

  var fetchedVendors;
  var fetchedArtisans;

  Future<dynamic> topVendors() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      final response = await get(
        Uri.parse('https://admin.rise.ng/api/fetch_top/Vendor/10?'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $getToken'
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString().replaceAll("\n", ""));
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        var result = data['data']['topUsers']['data'];
        List tempList = [];

        if (result != null) {
          for (var v in result) {
            tempList.add(v);
          }
        }
        setState(() {
          fetchedVendors = tempList;
        });
        // print("this is VENDORRRRRRRR : ${data['data']}");
        // print("this is VENDORRRRRRRR : ${data['data']['data']}");
        print(fetchedVendors);
        // print('Vendors ${response.statusCode}');
      } else {
        // print(response.statusCode);
      }
    } catch (e) {
      // print(e.toString());
      // print("vendors fucked up");
    }
  }

  Future<void> topArtisans() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      final response = await get(
        Uri.parse('https://admin.rise.ng/api/fetch_top/Artisan/10?'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $getToken'
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString().replaceAll("\n", ""));
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        var result = data['data']['topUsers']['data'];
        List tempList = [];
        if (result != null) {
          for (var v in result) {
            tempList.add(v);
          }
        }

        setState(() {
          fetchedArtisans = tempList;
        });
        // print("this is ARTISANNNNNN : ${data['data']}");
        // print("this is ARTISANNNNNN : ${data['data']['data']}");
        // print(data);
        // print("top Artisans fetched");
      } else {
        // print('Artisans ${response.statusCode}');
      }
    } catch (e) {
      // print(e.toString());
      // print("Artisans fucked up");
    }
  }

  Future<void> fetchUserDetails() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();

    try {
      final response = await get(Uri.parse('https://admin.rise.ng/api/user'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print(data);
        // print("user data fetched");
        setState(() {
          // // print(data.message);
          // print(data['data']['full_name']);
          names = data['data']['full_name'].split(' ');
          userData = GetAuthUserResponse.fromJson(data);
        });
      } else if (response.statusCode == 401) {
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print(data);
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Session expired',
            message: data['error'],
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        SharedPreferences sharedPreference =
            await SharedPreferences.getInstance();
        sharedPreference.clear();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SignInScreen();
        }));
      } else {
        // print(response.statusCode);
        // print('this is  data $data');
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> resendVerification() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    EasyLoading.show();

    try {
      final response = await get(
          Uri.parse('https://admin.rise.ng/api/resend/verification/token'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print(data);
        EasyLoading.dismiss();
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Verification sent!!',
            message: data['message'],
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VerifyEmail(where: '');
        }));
        // print("Verification Sent fetched");
      } else {
        // print('error ${response.statusCode.toString()}');
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error ${response.statusCode.toString()}',
            message: data['message'],
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {
      // print(e.toString());
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: e.toString(),
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      EasyLoading.dismiss();
    }
  }

  var fetchedListings;
  final TextEditingController searchMarketEditingController =
      TextEditingController();

  Position? _currentPosition;
  double getLatitude = 0.0;
  double getLongitude = 0.0;
  double distance = 25;
  bool ignore = false;

  bool isSearching = false;
  bool isLoading = false;

  Future<dynamic> _getCurrentLocation() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          getLatitude = _currentPosition!.latitude;
          getLongitude = _currentPosition!.longitude;
          isLoading = true;
          // _getAddressFromLatLng();
        });
      }
    }).catchError((e) {
      //// print(e);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _refresh() async {
    fetchDashboardData();
    fetchUserDetails().whenComplete(() {
      setState(() {});
    });
    topVendors();
    topArtisans();
    fetchTopListings();
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 30), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: LiquidPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        showChildOpacityTransition: false,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Welcome back\n',
                          style: GoogleFonts.poppins(
                              color: blackColor,
                              // fontFamily: 'Chillax',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(
                              text: names[1] ?? '',
                              style: GoogleFonts.poppins(
                                  color: blackColor,
                                  // fontFamily: 'Chillax',
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: blackColor,
                      radius: 25,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.message),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              userData != null
                  ? userData!.data.emailVerified
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            height: 13.h,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You have not verified your email, kindly verify your email to access your account features.",
                                  style: TextStyle(
                                    // fontFamily: 'Chillax',
                                    color: whiteColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9.sp,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "Can't find your verification email? ",
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          // fontFamily: 'Chillax',
                                          color: whiteColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 8.sp,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            resendVerification();
                                          },
                                          child: Text(
                                            "resend email",
                                            style: TextStyle(
                                              // fontFamily: 'Chillax',
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 8.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                  : Container(),
              userData != null
                  ? userData!.data.kycVerified
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            height: 10.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You have not done your KYC.",
                                  style: TextStyle(
                                    // fontFamily: 'Chillax',
                                    color: blackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9.sp,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "Tap here to fill your KYC forms >> ",
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          // fontFamily: 'Chillax',
                                          color: blackColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 8.sp,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: (() => Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return UserKYCHome(
                                                  type: userData!.data.userType,
                                                );
                                              }))),
                                          child: Text(
                                            "goto KYC",
                                            style: TextStyle(
                                              // fontFamily: 'Chillax',
                                              color: primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 8.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Dashboard",
                  style: TextStyle(
                    // fontFamily: 'Chillax',
                    color: blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 25.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                        width: 300,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: grayColor.withOpacity(0.3),
                              offset: const Offset(
                                3.0,
                                3.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: whiteColor,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -100,
                              top: 0,
                              bottom: 0,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.3,
                                height: 25.h,
                                child: Image.asset(
                                  "assets/images/bg_dash.png",
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    totalBookings,
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 53.sp,
                                    ),
                                  ),
                                  Text(
                                    "Bookings",
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: grayColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Container(
                        width: 300,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: grayColor.withOpacity(0.3),
                              offset: const Offset(
                                3.0,
                                3.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: whiteColor,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -100,
                              top: 0,
                              bottom: 0,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.3,
                                height: 25.h,
                                child: Image.asset(
                                  "assets/images/bg_dash.png",
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    totalBookingsCompleted,
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 53.sp,
                                    ),
                                  ),
                                  Text(
                                    "Bookings Completed",
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: grayColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Top Services",
                  style: TextStyle(
                    // fontFamily: 'Chillax',
                    color: blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 25.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                        width: 300,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        padding: const EdgeInsets.only(left: 20, bottom: 20),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/one.png",
                              ),
                              fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                              color: grayColor.withOpacity(0.3),
                              offset: const Offset(
                                3.0,
                                3.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: whiteColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Carpenters",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              "20,000 members",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: grayColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        )),
                    Container(
                        width: 300,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        padding: const EdgeInsets.only(left: 20, bottom: 20),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/walkthrough.png",
                              ),
                              fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                              color: grayColor.withOpacity(0.3),
                              offset: const Offset(
                                3.0,
                                3.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: whiteColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gaffers",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              "20,000 members",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: grayColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        )),
                    Container(
                        width: 300,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        padding: const EdgeInsets.only(left: 20, bottom: 20),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/three.png",
                              ),
                              fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                              color: grayColor.withOpacity(0.3),
                              offset: const Offset(
                                3.0,
                                3.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: whiteColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Electricians",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              "20,000 members",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: grayColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        )),
                    Container(
                        width: 300,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        padding: const EdgeInsets.only(left: 20, bottom: 20),
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/two.png",
                              ),
                              fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                              color: grayColor.withOpacity(0.3),
                              offset: const Offset(
                                3.0,
                                3.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: whiteColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Caterers",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: secondaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              "20,000 members",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: grayColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Top Vendors",
                  style: TextStyle(
                    // fontFamily: 'Chillax',
                    color: blackColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              fetchedVendors == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        height: 13.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "There are no Top Vendors at this time",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Check back later ",
                                    // overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: whiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemExtent: 70,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: fetchedVendors.length,
                      itemBuilder: (BuildContext context, int index) {
                        var vendor = fetchedVendors[index];
                        print(vendor);
                        return ListTile(
                            onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ViewArtisanDetailScreen(
                                      dataModel: vendor);
                                })),
                            title: Text(
                              vendor['full_name'] ?? '',
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            leading: ProfilePicture(
                              name: vendor['full_name'] ?? '',
                              radius: 20,
                              fontsize: 18,
                              random: true,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                            ));
                      }),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Top Artisans",
                  style: TextStyle(
                    // fontFamily: 'Chillax',
                    color: blackColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              fetchedArtisans == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        height: 13.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "There are no Top Artisans at this time",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Check back later ",
                                    // overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: whiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  // WidgetSpan(
                                  //   child: GestureDetector(
                                  //     onTap: () {
                                  //       // resend
                                  //     },
                                  //     child: Text(
                                  //       "resend email",
                                  //       style: TextStyle(
                                  //         // fontFamily: 'Chillax',
                                  //         color: secondaryColor,
                                  //         fontWeight: FontWeight.w500,
                                  //         fontSize: 10.sp,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemExtent: 70,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: fetchedArtisans!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var artisan = fetchedArtisans[index];
                        return ListTile(
                            onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ViewArtisanDetailScreen(
                                      dataModel: artisan);
                                })),
                            title: Text(
                              artisan['full_name'] ?? '',
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            leading: ProfilePicture(
                              name: artisan['full_name'] ?? '',
                              radius: 20,
                              fontsize: 18,
                              random: true,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                            ));
                      }),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
