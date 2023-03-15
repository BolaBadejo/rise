import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:rise/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ArtisanTask extends StatefulWidget {
  const ArtisanTask({super.key});

  @override
  State<ArtisanTask> createState() => _ArtisanTaskState();
}

class _ArtisanTaskState extends State<ArtisanTask> {
  final TextEditingController searchMarketEditingController =
      TextEditingController();

  @override
  initState() {
    fetchUserBookings();

    super.initState();
  }

  void updateBookingStatus(context, status, bookingID) async {
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

        var running = data['data']['ongoingBooking']['data'];
        List ongoingList = [];
        if (running != null) {
          for (var v in running) {
            ongoingList.add(v);
          }
        }

        setState(() {
          fetchedBookings = tempList;
          ongoingBookings = ongoingList;
        });
      } else {
        // print((data['message']));
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  var fetchedBookings = [];
  var ongoingBookings = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _refresh() async {
    fetchUserBookings();
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
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tasks",
                      style: TextStyle(
                        // fontFamily: 'Chillax',
                        color: blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                    ),
                    const Icon(
                      Icons.filter_alt_outlined,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              fetchedBookings == null
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
                              "We are fetching your bookings",
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
                                    text: "Please wait... ",
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
                  : Container(),
              ExpansionTile(
                  title: Text('Pending bookings (${fetchedBookings.length})'),
                  children: [
                    fetchedBookings.length == 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              height: 10.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Center(
                                child: Text(
                                  "You have no booking here",
                                  style: TextStyle(
                                    // fontFamily: 'Chillax',
                                    color: whiteColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemExtent: 26.h,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: fetchedBookings.length,
                            itemBuilder: (BuildContext context, int index) {
                              var booking = fetchedBookings[index];
                              return Container(
                                height: 25.h,
                                width: 100.w,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(30),
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
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ProfilePicture(
                                          name: booking['user']['full_name'] ??
                                              '',
                                          radius: 20,
                                          fontsize: 18,
                                          random: true,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              booking['title'] ?? '',
                                              // overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                // fontFamily: 'Chillax',
                                                color: blackColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "customer: ",
                                                    // overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      // fontFamily: 'Chillax',
                                                      color: blackColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 9.sp,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: booking['user']
                                                            ['full_name'] ??
                                                        '',
                                                    // overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      // fontFamily: 'Chillax',
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 9.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      booking['tentative_amount'] ?? '',
                                      // overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        // fontFamily: 'Chillax',
                                        color: blackColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: primaryColor),
                                          child: Text(
                                            booking['status'] ?? '',
                                            style: TextStyle(
                                              // fontFamily: 'Chillax',
                                              fontWeight: FontWeight.w500,
                                              color: whiteColor,
                                              fontSize: 9.sp,
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder: (BuildContext context) =>
                                              [
                                            PopupMenuItem<String>(
                                              value: 'Rejected',
                                              child: Text('Reject'),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'Arrived',
                                              child: Text('Arrived'),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'Started',
                                              child: Text('Started'),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'Completed',
                                              child: Text('Completed'),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'Cancelled',
                                              child: Text('Cancelled'),
                                            ),
                                          ],
                                          onSelected: (String value) {
                                            // Do something with the selected value
                                            updateBookingStatus(
                                                context, value, booking['id']);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                  ]),
              ExpansionTile(
                  title: Text('Ongoing bookings (${ongoingBookings.length})'),
                  children: [
                    ongoingBookings.length == 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              height: 10.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Center(
                                child: Text(
                                  "You have no booking here",
                                  style: TextStyle(
                                    // fontFamily: 'Chillax',
                                    color: whiteColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemExtent: 26.h,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: ongoingBookings.length,
                            itemBuilder: (BuildContext context, int index) {
                              var booking = ongoingBookings[index];
                              return Container(
                                height: 25.h,
                                width: 100.w,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(30),
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
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ProfilePicture(
                                          name: booking['user']['full_name'] ??
                                              '',
                                          radius: 20,
                                          fontsize: 18,
                                          random: true,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              booking['title'] ?? '',
                                              // overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                // fontFamily: 'Chillax',
                                                color: blackColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "customer: ",
                                                    // overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      // fontFamily: 'Chillax',
                                                      color: blackColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 9.sp,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: booking['user']
                                                            ['full_name'] ??
                                                        '',
                                                    // overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      // fontFamily: 'Chillax',
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 9.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      booking['tentative_amount'] ?? '',
                                      // overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        // fontFamily: 'Chillax',
                                        color: blackColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: primaryColor),
                                          child: Text(
                                            booking['status'] ?? '',
                                            style: TextStyle(
                                              // fontFamily: 'Chillax',
                                              fontWeight: FontWeight.w500,
                                              color: whiteColor,
                                              fontSize: 9.sp,
                                            ),
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert),
                                          itemBuilder: (BuildContext context) =>
                                              [
                                            PopupMenuItem<String>(
                                              value: 'Rejected',
                                              child: Text('Reject'),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'Arrived',
                                              child: Text('Arrived'),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'Started',
                                              child: Text('Started'),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'Completed',
                                              child: Text('Completed'),
                                            ),
                                            PopupMenuItem<String>(
                                              value: 'Cancelled',
                                              child: Text('Cancelled'),
                                            ),
                                          ],
                                          onSelected: (String value) {
                                            // Do something with the selected value
                                            updateBookingStatus(
                                                context, value, booking['id']);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
