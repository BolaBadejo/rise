// booking['listing_id'],
// booking['bargained_amount'],
// booking['task_id'],
// booking['id']);

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
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../payment/payment_screen.dart';

class CustomerOrders extends StatefulWidget {
  const CustomerOrders({super.key});

  @override
  State<CustomerOrders> createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String _phone = '';

  @override
  initState() {
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
    fetchUserBookings();
    getDropOff();
    super.initState();
  }

  var price = "N0.00";
  var routeID = '--Route ID--';

  var fetchedBookings = [];

  var ongoingBookings = [];
  var options = ['Rejected', 'Arrived', 'Started', 'Completed', 'Cancelled'];

  var dropOffList = [];

  var selectedDropOff;

  var singleSelectedPickUp;

  var routeDetail;

  Future<void> selectRoute() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    print('fetching route');

    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/pick_up/select-route"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'pick_up': selectedPickUp[0],
            'drop_off': selectedDropOff,
          });

      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        print(response);
        // print("States fetched");
        setState(() {
          routeDetail = data['data']['routesFee'];
          // print(lgaList);
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> getDropOff() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    print('fetching locations');

    try {
      final response = await get(
          Uri.parse('https://admin.rise.ng/api/pick_up/drop-off-routes'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      print(getToken);

      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        print(response);
        // print("States fetched");
        setState(() {
          dropOffList = data['data']['availableDropOffRoutes'];
          // print(lgaList);
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  var selectedPickUp = [];

  Future<void> getPickUp(id) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    print('fetching locations');

    try {
      final response = await get(
          Uri.parse(
              'https://admin.rise.ng/api/pick_up/find-listings-pick-up-route/${id.toString()}'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      print(getToken);

      print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        print(response);
        // print("States fetched");
        setState(() {
          selectedPickUp = data['data']['vendorAvailablePickUps'];
          // print(lgaList);
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  void payDirectWithRoute(
      ctxt, listing_id, route, price, task, bookingID, booking) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    EasyLoading.show();
    print("this is $price");
    print('make payment sup');
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/payment/initialize/purchase"),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'listing_ids': listing_id.toString(),
            'task_id': task,
            'amount': price.toString(),
            'booking_id': bookingID.toString(),
            'route_id': route.toString(),
          });
      var data = jsonDecode(response.body.toString());
      print(data);
      if (response.statusCode == 200) {
        // print(data);
        // print(data['data']);
        EasyLoading.dismiss();
        Navigator.pop(context);
        showOffer(
            context,
            data['message'],
            data['data']['data']['data']['authorization_url'],
            booking['title'],
            booking['description']);
      } else {
        // print('error ${response.statusCode.toString()}');
        EasyLoading.dismiss();
        Navigator.pop(context);
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error ${response.statusCode.toString()}',
            message: data['message'].toString(),
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
          message: e.toString(),
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(ctxt)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  void payDirect(ctxt, listing_id, price, task, bookingID, booking) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    EasyLoading.show();
    print("this is $price");
    print('make payment sup');
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/payment/initialize/purchase"),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'listing_ids': listing_id.toString(),
            'task_id': task,
            'amount': price.toString(),
            'booking_id': bookingID.toString(),
          });
      var data = jsonDecode(response.body.toString());
      print(data);
      if (response.statusCode == 200) {
        // print(data);
        // print(data['data']);
        EasyLoading.dismiss();
        Navigator.pop(context);
        showOffer(
            context,
            data['message'],
            data['data']['data']['data']['authorization_url'],
            booking['title'],
            booking['description']);
      } else {
        // print('error ${response.statusCode.toString()}');
        EasyLoading.dismiss();
        Navigator.pop(context);
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error ${response.statusCode.toString()}',
            message: data['message'].toString(),
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
          message: e.toString(),
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(ctxt)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  var now = "0";
  void showLogistics(ctx, bookings) {
    if (bookings['bargained_amount'] != null &&
        bookings['bargained_amount'].length >= 3) {
      var str = bookings['bargained_amount']
          .substring(0, bookings['bargained_amount'].length - 3);
      setState(() {
        now = str;
      });
    }
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            // <-- SEE HERE
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        )),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.4,
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
                      Text(
                        "Pickup Address",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
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
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 3, bottom: 3),
                        decoration: BoxDecoration(
                            color: whiteColor.withOpacity(0.29),
                            borderRadius: BorderRadius.circular(50.0),
                            border: const Border(
                              top: BorderSide(width: 2, color: grayColor),
                              left: BorderSide(width: 2, color: grayColor),
                              right: BorderSide(width: 2, color: grayColor),
                              bottom: BorderSide(width: 2, color: grayColor),
                            )),
                        child: DropdownButton(
                          hint: Text(
                            "--Select Pick Up Address--",
                            style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: grayColor.withOpacity(0.9)),
                          ),
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 22,
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 16.sp),
                          value: singleSelectedPickUp,
                          onChanged: (newValue) async {
                            setState(() {
                              singleSelectedPickUp = newValue;
                            });
                          },
                          items: selectedPickUp
                              .map<DropdownMenuItem<String>>((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Dropoff Address",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
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
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 3, bottom: 3),
                        decoration: BoxDecoration(
                            color: whiteColor.withOpacity(0.29),
                            borderRadius: BorderRadius.circular(50.0),
                            border: const Border(
                              top: BorderSide(width: 2, color: grayColor),
                              left: BorderSide(width: 2, color: grayColor),
                              right: BorderSide(width: 2, color: grayColor),
                              bottom: BorderSide(width: 2, color: grayColor),
                            )),
                        child: DropdownButton(
                          hint: Text(
                            "--Select Drop Off Address--",
                            style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: grayColor.withOpacity(0.9)),
                          ),
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 22,
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 16.sp),
                          value: selectedDropOff,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedDropOff = newValue;
                            });
                            await selectRoute().then((value) => {
                                  setState(() {
                                    routeDetail = routeDetail;
                                  })
                                });
                          },
                          items: dropOffList
                              .map<DropdownMenuItem<String>>((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Value Offer",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
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
                              "N${bookings['bargained_amount']}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
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
                        "Shipping Cost",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
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
                              routeDetail == null
                                  ? "0.00"
                                  : "${routeDetail['amount']}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
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
                        "Route ID",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
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
                              routeDetail == null
                                  ? "0"
                                  : "${routeDetail['id']}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
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
                                    text: routeDetail == null
                                        ? "pay N${int.parse(now)} "
                                        : "pay N${int.parse(now) + routeDetail['amount']} ",
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
                              payDirectWithRoute(
                                  context,
                                  bookings['id'],
                                  int.parse(now) + routeDetail['amount'],
                                  routeDetail['id'],
                                  bookings['task_id'],
                                  bookings['id'],
                                  bookings);
                            }),
                      ),
                      const SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void showOffer(ctx, text, link, title, description) {
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 12,
                        child: Image.asset(
                          'assets/images/rise-check.gif',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21.0),
                      child: Text(
                        "Congratulations, you have Initialized payment to $title for $description",
                        style: GoogleFonts.poppins(
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
                        // print(link);
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PaymentScreen(
                            link: link!,
                          );
                        }));

                        final snackBar = SnackBar(
                          /// need to set following properties for best effect of awesome_snackbar_content
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Payment initialized!',
                            message: text,

                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                            contentType: ContentType.success,
                          ),
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      },
                      child: Text(
                        "click here to complete payment",
                        style: GoogleFonts.poppins(
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
            ),
          );
        });
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
            message: data['message'].toString(),
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        // print(data);
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
            message: data['message'].toString(),
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        // print(data);
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
          Uri.parse('https://admin.rise.ng/api/booking/current'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void show(ctx, booking) {
    print(booking);
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      booking['title'],
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        // fontFamily: 'Chillax',
                        color: blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      booking['description'],
                      style: GoogleFonts.poppins(
                        // fontFamily: 'Chillax',
                        color: blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                      softWrap: false,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            child: Icon(Icons.store, size: 18),
                          ),
                          TextSpan(
                            text: " ${booking['user']['full_name']}",
                            // overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              // fontFamily: 'Chillax',
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            child: Icon(Icons.payments, size: 18),
                          ),
                          TextSpan(
                            text: " N${booking['tentative_amount']}",
                            // overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              // fontFamily: 'Chillax',
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            child: Icon(Icons.price_change, size: 18),
                          ),
                          TextSpan(
                            text: " N${booking['bargained_amount']}",
                            // overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              // fontFamily: 'Chillax',
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 45),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RiseButtonNew(
                          text: Text(
                            "Chat with Vendor",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              // fontFamily: 'Chillax',
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                          buttonColor: whiteColor,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(ctx);
                            // showOffer(context);
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RiseButtonNew(
                        text: Text(
                          "Call Vendor",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            // fontFamily: 'Chillax',
                            color: whiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                        buttonColor: blackColor,
                        textColor: Colors.white,
                        onPressed: () => setState(() {
                          _launched = _makePhoneCall("08187702425");
                        }),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RiseButtonNew(
                          text: Text(
                            "Make Payment",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              // fontFamily: 'Chillax',
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                          buttonColor: secondaryColor.withOpacity(0.3),
                          textColor: whiteColor,
                          onPressed: () {
                            // if (booking['user']['user_type'] == "Vendor") {
                            //   getPickUp(booking['id']);
                            //   showLogistics(context, booking);
                            // } else {
                            payDirect(
                                context,
                                booking['listing_id'],
                                booking['bargained_amount'],
                                booking['task_id'],
                                booking['id'],
                                booking);
                            // showOffer(context);
                            // }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _refresh() async {
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
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
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Orders",
                  style: GoogleFonts.poppins(
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
                              style: GoogleFonts.poppins(
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
                                  style: GoogleFonts.poppins(
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
                            itemExtent: 30.h,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: fetchedBookings.length,
                            itemBuilder: (BuildContext context, int index) {
                              var booking = fetchedBookings[index];
                              String createdTime = booking['created_at']
                                  .substring(
                                      0, booking['created_at'].length - 17);
                              // String acceptedTime = booking['accepted_at']
                              //     .substring(
                              //         0, booking['accepted_at'].length - 17);
                              return Container(
                                height: 25.h,
                                width: 100.w,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                padding: const EdgeInsets.symmetric(
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    text: "Artisan: ",
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
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Booked on: ",
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
                                                    text: createdTime,
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
                                            // RichText(
                                            //   text: TextSpan(
                                            //     children: [
                                            //       TextSpan(
                                            //         text: "Accepted at: ",
                                            //         // overflow: TextOverflow.ellipsis,
                                            //         style: GoogleFonts.poppins(
                                            //           // fontFamily: 'Chillax',
                                            //           color: blackColor,
                                            //           fontWeight: FontWeight.w500,
                                            //           fontSize: 9.sp,
                                            //         ),
                                            //       ),
                                            //       TextSpan(
                                            //         text: acceptedTime,
                                            //         // overflow: TextOverflow.ellipsis,
                                            //         style: GoogleFonts.poppins(
                                            //           // fontFamily: 'Chillax',
                                            //           color: primaryColor,
                                            //           fontWeight: FontWeight.w500,
                                            //           fontSize: 9.sp,
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
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
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
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
                                  style: GoogleFonts.poppins(
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
                            itemExtent: 30.h,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: ongoingBookings.length,
                            itemBuilder: (BuildContext context, int index) {
                              var booking = ongoingBookings[index];
                              String createdTime = booking['created_at']
                                  .substring(
                                      0, booking['created_at'].length - 17);
                              String acceptedTime = booking['accepted_at']
                                  .substring(
                                      0, booking['accepted_at'].length - 17);
                              return GestureDetector(
                                onTap: () => show(context, booking),
                                child: Container(
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
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
                                                      text: "Artisan: ",
                                                      // overflow: TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
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
                                                      style:
                                                          GoogleFonts.poppins(
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
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Booked at: ",
                                                      // overflow: TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        // fontFamily: 'Chillax',
                                                        color: blackColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 9.sp,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: createdTime,
                                                      // overflow: TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
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
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Accepted at: ",
                                                      // overflow: TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        // fontFamily: 'Chillax',
                                                        color: blackColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 9.sp,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: acceptedTime,
                                                      // overflow: TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
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
                                            itemBuilder:
                                                (BuildContext context) => [
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
                                              updateBookingStatus(context,
                                                  value, booking['id']);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
