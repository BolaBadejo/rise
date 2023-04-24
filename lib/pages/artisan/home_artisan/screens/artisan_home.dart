import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rise/constants.dart';
import 'package:rise/data/model/booking/booking_reponse_model.dart';
import 'package:rise/pages/artisan/home_artisan/screens/new_listing.dart';
import 'package:rise/pages/artisan/view_artisan.dart';
import 'package:rise/pages/user/customer_profile/kyc/user-kyc.dart';
import 'package:rise/services/api_handler.dart';

import 'package:flutter_share/flutter_share.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../../data/model/get_auth_user/get_auth_user_response_model.dart';
import '../../../auth/verify_email.dart';

class ArtisanHomeScreen extends StatefulWidget {
  const ArtisanHomeScreen({super.key});

  @override
  State<ArtisanHomeScreen> createState() => _ArtisanHomeScreenState();
}

class _ArtisanHomeScreenState extends State<ArtisanHomeScreen> {
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

  void updateBookingStatus(context, status, bookingID) async {
    EasyLoading.show();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/booking/update-status"),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'booking_id': bookingID.toString(),
            'status': status
          });

      var data = jsonDecode(response.body.toString());
      // print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        Navigator.pop(context);
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Updated successfully!',
            message: data['message'],
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        // print(data['message']);
        // print("done successfully");
      } else {
        var data = jsonDecode(response.body.toString());
        EasyLoading.dismiss();

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
      EasyLoading.dismiss();
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: 'Something went wrong',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  GetAuthUserResponse? userData;

  var fetchedVendors;
  var fetchedArtisans;
  var fetchedBookings;

  String totalBookings = '0';
  String totalBookingsCompleted = '0';

  // fetchUserDetails()  https://admin.rise.ng/api/fetch_top/{user_type}/{limit?}

  Future<void> fetchUserDetails() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();

    try {
      final response = await get(Uri.parse('https://admin.rise.ng/api/user'),
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _refresh() async {
    fetchUserBookings();
    fetchUserDetails().whenComplete(() {
      setState(() {});
    });
    topVendors();
    fetchDashboardData();
    topArtisans();
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 30), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {});
  }

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
          Uri.parse('https://admin.rise.ng/api/booking/vendor/current'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      // print(response.statusCode);
      var data = jsonDecode(response.body.toString());
      // print('hkhkhkhkhkhkhkhkkhkh');
      // print(data);

      if (response.statusCode == 200) {
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print("Bookings data fetched_uuuuuuuuuuuuu");
        // print(data);
        var result = data['data']['newBooking']['data'];
        List tempList = [];
        if (result != null) {
          for (var v in result) {
            tempList.add(v);
          }
        }

        setState(() {
          fetchedBookings = tempList;
        });
      } else {
        // print((data['message']));
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> topArtisans() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    // print('this is Token: $getToken');
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

  Future<String> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');
    final buffer = byteData.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.absolute.path;
    var filePath = tempPath + '/file_01.tmp';
    return filePath;
    // return File(filePath).writeAsBytes(
    //     buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  Future<void> shareFile() async {
    var image = await getImageFileFromAssets('assets/images/banj.png');
    await FlutterShare.share(
        title: 'Refer a friend',
        text: 'Join me on Rese and discover the best services and products',
        linkUrl: 'www.rise.ng'
        // filePath: image,
        );
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
          return const VerifyEmail(where: '');
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
          Uri.parse("https://admin.rise.ng/api/booking/accept-booking"),
          body: {
            'booking_id': bookingID,
            'amount': bookingID,
            'title': title,
            'description': description
          });
      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
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
    }
  }

  void acceptOffer(context, bookingID, amount) async {
    // print(amount);
    String str = '';
    int amountInteger = 0;
    if (amount.length >= 4) {
      str = amount.substring(0, amount.length - 3);
    }
    amountInteger = int.parse(str);
    // print(amountInteger);
    // print(str);
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    EasyLoading.show();
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/booking/accept-booking"),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'booking_id': bookingID.toString(),
            'amount': amountInteger.toString()
          });
      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        EasyLoading.dismiss();

        // print(str);

        Navigator.pop(context);
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Successful',
            message: data['message'],
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        showOffer(context, data['message']);
        // print("done successfully");
      } else {
        EasyLoading.dismiss();
        Navigator.pop(context);
        // print('error ${response.statusCode.toString()}');
        // print(data);
        // print(data['message']);

        // print(str);
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error ${response.statusCode.toString()}',
            message: response.body,
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {
      EasyLoading.dismiss();
      Navigator.pop(context);
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

      // print(str);
    }
  }

  void renegotiate(BuildContext ctx) {
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

  void show(ctx, booking) {
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfilePicture(
                            name: booking['user']['full_name'] ?? '',
                            radius: 20,
                            fontsize: 18,
                            random: true,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${booking['user']['full_name'] ?? ''} \nwants to negotiate",
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              Text(
                                "for: ${booking['title'] ?? ''}",
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
                      height: 20,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            booking['tentative_amount'] ?? '',
                            style: TextStyle(
                              // fontFamily: 'Chillax',
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                          ),
                          Text(
                            "Tentative Amount",
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
                                  text:
                                      "Accept @ ${booking['tentative_amount']}",
                                  // overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
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
                            acceptOffer(ctx, booking['id'],
                                booking['tentative_amount']);
                          }),
                    ),
                    const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    //   child: RiseButtonNew(
                    //       text: Text(
                    //         "Re-negotiate offer",
                    //         // overflow: TextOverflow.ellipsis,
                    //         style: TextStyle(
                    //           // fontFamily: 'Chillax',
                    //           color: blackColor,
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 14.sp,
                    //         ),
                    //       ),
                    //       buttonColor: secondaryColor.withOpacity(0.3),
                    //       textColor: whiteColor,
                    //       onPressed: () {
                    //         Navigator.pop(context);
                    //         renegotiate(context);
                    //       }),
                    // ),
                    // const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                        updateBookingStatus(context, 'Rejected', booking['id']);
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
                        fontSize: 9.sp,
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
                        fontSize: 9.sp,
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
              const SizedBox(
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const NewListing();
                        }));
                      },
                      child: Row(
                        children: [
                          Text(
                            'new listing',
                            style: TextStyle(
                              // fontFamily: 'Chillax',
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                          const Icon(
                            Icons.control_point,
                          ),
                        ],
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
                                            resendVerification();
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
                            height: 22.h,
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
                                    fontSize: 14.sp,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "Get Verified on Rísé and post unlimited listings. ",
                                        // overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
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
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
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
                                                fontSize: 9.sp,
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
              fetchedBookings == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        height: 12.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: grayColor,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Popularity check!!",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "we are checking if anybody has booked you.",
                                    // overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
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
                  : fetchedBookings.length == 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            height: 12.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: grayColor,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You have no pending bookings.",
                                  style: TextStyle(
                                    // fontFamily: 'Chillax',
                                    color: blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    shareFile();
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "Tap to tell your customers you are on Rise.",
                                          // overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            // fontFamily: 'Chillax',
                                            color: whiteColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                        const WidgetSpan(
                                            child: Icon(Icons.share_location)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Pending Bargains",
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                              width: 100.w,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemExtent: 85.w,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: fetchedBookings!.length ?? 0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var booking = fetchedBookings[index];
                                    return GestureDetector(
                                      onTap: (() => show(context, booking)),
                                      child: Container(
                                          // height: ,
                                          // width: 125,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    grayColor.withOpacity(0.3),
                                                offset: const Offset(
                                                  3.0,
                                                  3.0,
                                                ),
                                                blurRadius: 5.0,
                                                spreadRadius: 2.0,
                                              ), //BoxShadow
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: whiteColor,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ProfilePicture(
                                                name: booking['user']
                                                        ['full_name'] ??
                                                    '',
                                                radius: 20,
                                                fontsize: 18,
                                                random: true,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${booking['user']['full_name'] ?? ''} \nwants to negotiate",
                                                    style: TextStyle(
                                                      // fontFamily: 'Chillax',
                                                      color: blackColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                  Text(
                                                    "for: ${booking['title'] ?? ''}",
                                                    style: TextStyle(
                                                      // fontFamily: 'Chillax',
                                                      color: grayColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 9.sp,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(),
                                                  ),
                                                  Text(
                                                    booking['tentative_amount'] ??
                                                        '',
                                                    style: TextStyle(
                                                      // fontFamily: 'Chillax',
                                                      color: blackColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    );
                                  }),
                            ),
                          ],
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
                        return ListTile(
                            onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ViewArtisanDetailScreen(
                                      dataModel: vendor);
                                })),
                            title: Text(
                              vendor.fullname ?? '',
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
