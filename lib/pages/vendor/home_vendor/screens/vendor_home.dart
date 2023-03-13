import 'dart:convert';
import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart';
import 'package:rise/constants.dart';
import 'package:rise/data/model/booking/booking_reponse_model.dart';
import 'package:rise/pages/user/customer_profile/kyc/user-kyc.dart';
import 'package:rise/services/api_handler.dart';
import 'package:rise/utils/shared_preferences.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:rise/data/model/login/login_response_model.dart';

import '../../../../data/model/get_auth_user/get_auth_user_response_model.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  List names = ['', ''];
  var pendingBargain = [];

  @override
  initState() {
    fetchUserBookings();
    fetchUserDetails().whenComplete(() {
      setState(() {});
    });
    topVendors();
    fetchDashboardData();
    topArtisans();
    super.initState();
  }

  Future<void> fetchBookings() async {
    BookingResponse res = await APIHandler().fetchMyBookings();
    // print('This is booking');
    // print(res);

    setState(() {
      // pendingBargain = res.data.newBooking;
    });
  }

  GetAuthUserResponse? userData;

  // fetchUserDetails()  https://test.rise.ng/api/fetch_top/{user_type}/{limit?}

  Future<void> fetchUserDetails() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();

    try {
      final response = await get(Uri.parse('https://test.rise.ng/api/user'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
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
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  String totalBookings = '0';
  String totalBookingsCompleted = '0';

  Future<void> fetchDashboardData() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();

    try {
      final response = await get(
          Uri.parse('https://test.rise.ng/api/dashboard/statistics'),
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
          totalBookingsCompleted = data['data']['totalBookings'].toString();
          // // print(userData!.data);
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> fetchUserBookings() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    // print('fetching user bookings');

    try {
      final response = await get(
          Uri.parse('https://test.rise.ng/api/booking/current'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      // print(response.statusCode);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print("Bookings data fetched");
        // print(data);
        setState(() {
          // // // print(data.message);
          // // print(data['data']['totalBookings']);
          // totalBookings = data['data']['totalBookings'].toString();
          // totalBookingsCompleted = data['data']['totalBookings'].toString();
          // // print(userData!.data);
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> topArtisans() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      final response = await get(
        Uri.parse('https://test.rise.ng/api/fetch_top/Vendor/10?'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $getToken'
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString().replaceAll("\n", ""));
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        var result = data['data']['data'];
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

  var fetchedVendors;
  var fetchedArtisans;

  Future<dynamic> topVendors() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      final response = await get(
        Uri.parse('https://test.rise.ng/api/fetch_top/Vendor/10?'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $getToken'
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString().replaceAll("\n", ""));
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        var result = data['data']['data'];
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
        // print(data);
        // print('Vendors ${response.statusCode}');
      } else {
        // print(response.statusCode);
      }
    } catch (e) {
      // print(e.toString());
      // print("vendors fucked up");
    }
  }

  TextEditingController priceOfferEditingController = TextEditingController();

  void setNewPriceOffer(context, bookingID, title, description, amount) async {
    try {
      Response response = await post(
          Uri.parse("https://test.rise.ng/api/booking/accept-booking"),
          body: {
            'booking_id': bookingID,
            'amount': bookingID,
            'title': title,
            'description': description
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        Navigator.pop(context);
        showOffer(context, data['message']);
        // print("done successfully");
      } else {
        // print('error ${response.statusCode.toString()}');
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error ${response.statusCode.toString()}',
            message: 'There was an error setting new price offer',
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
    }
  }

  void acceptOffer(context, bookingID, amount) async {
    try {
      Response response = await post(
          Uri.parse("https://test.rise.ng/api/booking/accept-booking"),
          body: {'booking_id': bookingID, 'amount': bookingID});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // print(data['data']);
        // print('logged in');
        await Preferences.saveUserData(data['data']['user']);

        Navigator.pop(context);
        showOffer(context, data['message']);
        // print("done successfully");
      } else {
        // print('error ${response.statusCode.toString()}');
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error ${response.statusCode.toString()}',
            message: 'There was an error setting new price offer',
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
    }
  }

  void renegotiate(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            // <-- SEE HERE
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        )),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20,
                  top: 30,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Bargain (in naira)",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      // fontFamily: 'Chillax',
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 7.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.h),
                      color: grayColor.withOpacity(0.2),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "30,000",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // fontFamily: 'Chillax',
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Vendor's price (in naira)",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      // fontFamily: 'Chillax',
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: priceOfferEditingController,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        // fontFamily: 'Chillax',
                        color: const Color(0xffb5b5b5).withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                      fillColor: whiteColor,
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(18.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: blackColor),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: blackColor),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                    ),
                    validator: RequiredValidator(
                        errorText: "you can't search a blank field"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21.0),
                    child: Text(
                      "Kevin Udanz wants to margain with you.",
                      style: TextStyle(
                        // fontFamily: 'Chillax',
                        color: blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                      softWrap: false,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: RiseButtonNew(
                        text: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Send offer  ",
                                // overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                              const WidgetSpan(
                                child: Icon(
                                  Icons.check,
                                  size: 22,
                                  color: greenColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        buttonColor: blackColor,
                        textColor: whiteColor,
                        onPressed: () {
                          var number = "";
                          var randomnumber = Random();
                          //chnage i < 15 on your digits need
                          for (var i = 0; i < 12; i++) {
                            number =
                                number + randomnumber.nextInt(9).toString();
                          }
                          setNewPriceOffer(
                              context,
                              number,
                              'title',
                              'description',
                              priceOfferEditingController.text.toString());
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void show(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        shape: const RoundedRectangleBorder(
            // <-- SEE HERE
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        )),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20,
                  top: 30,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 100.w,
                      height: 10.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 15.h,
                            width: 15.h,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage("assets/images/banj.png"),
                            )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kevin Udang wants to\nnegotiate",
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                "for: Electric cooker",
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: grayColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "N15,000,00",
                            style: TextStyle(
                              // fontFamily: 'Chillax',
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                          ),
                          Text(
                            "from N20,000",
                            style: TextStyle(
                              // fontFamily: 'Chillax',
                              color: grayColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 9.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RiseButtonNew(
                          text: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Accept offer  ",
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    // fontFamily: 'Chillax',
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.check,
                                    size: 22,
                                    color: greenColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          buttonColor: blackColor,
                          textColor: whiteColor,
                          onPressed: () {
                            var number = "";
                            var randomnumber = Random();
                            //chnage i < 15 on your digits need
                            for (var i = 0; i < 12; i++) {
                              number =
                                  number + randomnumber.nextInt(9).toString();
                            }
                            acceptOffer(ctx, number, "2000");
                          }),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RiseButtonNew(
                          text: Text(
                            "Re-negotiate offer",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              // fontFamily: 'Chillax',
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          buttonColor: secondaryColor.withOpacity(0.3),
                          textColor: whiteColor,
                          onPressed: () {
                            Navigator.pop(context);
                            renegotiate(context);
                          }),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          "Reject Offer",
                          style: TextStyle(
                            // fontFamily: 'Chillax',
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showOffer(ctx, response) {
    showModalBottomSheet(
        context: ctx,
        shape: const RoundedRectangleBorder(
            // <-- SEE HERE
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        )),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Image.asset(
                    'assets/images/rise-check.gif',
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21.0),
                    child: Text(
                      'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                      style: TextStyle(
                        // fontFamily: 'Chillax',
                        color: blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                      softWrap: false,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "take me back",
                      style: TextStyle(
                        // fontFamily: 'Chillax',
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          style: TextStyle(
                              color: blackColor,
                              // fontFamily: 'Chillax',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                          children: <TextSpan>[
                            TextSpan(
                              text: names[1] ?? 'Bolarinwa',
                              style: TextStyle(
                                  color: blackColor,
                                  // fontFamily: 'Chillax',
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w500),
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
                                    fontSize: 12.sp,
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
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            // resend
                                          },
                                          child: Text(
                                            "resend email",
                                            style: TextStyle(
                                              // fontFamily: 'Chillax',
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10.sp,
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
                                    fontSize: 14.sp,
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
                                          fontSize: 10.sp,
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
                                              fontSize: 10.sp,
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
                  ? userData!.data.riseVerified
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            height: 18.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: blackColor,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Go Premium",
                                  style: TextStyle(
                                    // fontFamily: 'Chillax',
                                    color: whiteColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "Get Verified on Rísé and post unlimited listings. ",
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          // fontFamily: 'Chillax',
                                          color: whiteColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.sp,
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
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              "get premium",
                                              style: TextStyle(
                                                // fontFamily: 'Chillax',
                                                color: whiteColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.sp,
                                              ),
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
                        )),
                    Container(
                        width: 300,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        padding: const EdgeInsets.only(left: 20, bottom: 20),
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
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Pending Bargains",
                  style: TextStyle(
                    // fontFamily: 'Chillax',
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (() => show(context)),
                      child: Container(
                          width: 350,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
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
                            borderRadius: BorderRadius.circular(30),
                            color: whiteColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10.h,
                                width: 10.h,
                                child: const Image(
                                    image:
                                        AssetImage('assets/images/banj.png')),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Kevin wants to negotiate",
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  Text(
                                    "for: Electric cooker",
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: grayColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Text(
                                    "N15,000,00",
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                    Container(
                        width: 350,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
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
                          borderRadius: BorderRadius.circular(30),
                          color: whiteColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10.h,
                              width: 10.h,
                              child: const Image(
                                  image: AssetImage('assets/images/banj.png')),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kevin wants to negotiate",
                                  style: TextStyle(
                                    // fontFamily: 'Chillax',
                                    color: blackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Text(
                                  "for: Electric cooker",
                                  style: TextStyle(
                                    // fontFamily: 'Chillax',
                                    color: grayColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9.sp,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                Text(
                                  "N45,000,00",
                                  style: TextStyle(
                                    // fontFamily: 'Chillax',
                                    color: blackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Top Vendors",
                  style: TextStyle(
                    // fontFamily: 'Chillax',
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
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
                      itemCount: fetchedVendors.length,
                      itemBuilder: (BuildContext context, int index) {
                        var vendor = fetchedVendors[index];
                        ListTile(
                            title: Text(
                              vendor.fullname ?? '',
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            leading: const CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage("assets/images/banj.png")),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                            ));
                      }),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Top Artisans",
                  style: TextStyle(
                    // fontFamily: 'Chillax',
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              fetchedArtisans == null
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
                        ListTile(
                            title: Text(
                              artisan.fullname ?? '',
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            leading: const CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage("assets/images/banj.png")),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: primaryColor,
                            ));
                      }),
            ],
          ),
        ),
      )),
    );
  }
}
