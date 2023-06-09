import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:rise/constants.dart';
import 'package:rise/data/model/listings/listings_model.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../payment/payment_screen.dart';

class ViewProductDetailScreen extends StatefulWidget {
  final userType;
  final dataModel;
  final int index;
  // final List<String> imageUrl;
  const ViewProductDetailScreen({
    super.key,
    required this.dataModel,
    required this.index,
    required this.userType,
  });

  @override
  State<ViewProductDetailScreen> createState() =>
      _ViewProductDetailScreenState();
}

class _ViewProductDetailScreenState extends State<ViewProductDetailScreen> {
  final TextEditingController priceOfferEditingController =
      TextEditingController();

  var state = 'please wait...';
  var stateHeader = 'Fetching your listings';

  List<DataModel> fetchedListing = [];
  var fetchedListings;
  var fetchedSubListing;

  @override
  void initState() {
    fetchUserListings();
    getPickUp();
    getDropOff();
    super.initState();
  }

  var price = "N0.00";
  var routeID = '--Route ID--';

  Future<void> fetchUserListings() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();

    try {
      final response = await get(
          Uri.parse(
              'https://admin.rise.ng/api/user-listings/${widget.dataModel['id']}/10'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        var result = data['data']['data'];
        List tempList = [];

        if (result != null) {
          for (var v in result) {
            tempList.add(v);
            // print('this is temp list');
            // print(tempList);
          }
        }

        // print(data);

        setState(() {
          fetchedSubListing = tempList;
          fetchedListings = DataModel.dataFromSnapshot(tempList);
        });
      } else {
        setState(() {
          state = '${data['message']}';
          stateHeader = 'You have no listings here';
        });
      }
    } catch (e) {
      setState(() {
        state = "Check connection";
        stateHeader =
            'Coundn\'t retrieve listing, swipe this card down to refresh.';
      });
    }
  }

  void bookService(context, id, title, description, amount) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    int value = int.parse(amount);
    EasyLoading.show();
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/booking/new"),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'listing_id': id,
            'title': title,
            'description': description,
            'amount': value.toString()
          });
      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        Navigator.pop(context);
        EasyLoading.dismiss();
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Booking Created',
            message: data['message'].toString(),
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        EasyLoading.dismiss();
      } else {
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

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

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
        print(response);
        setState(() {
          routeDetail = data['data']['routesFee'];
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
        print(response);
        setState(() {
          dropOffList = data['data']['availableDropOffRoutes'];
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  var selectedPickUp = [];

  Future<void> getPickUp() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    print('fetching locations');

    try {
      final response = await get(
          Uri.parse(
              'https://admin.rise.ng/api/pick_up/find-listings-pick-up-route/${widget.dataModel.id.toString()}'),
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

  void payDirect(ctxt, listing_id, price) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    EasyLoading.show();
    print("this is $price");
    print('make payment sup');
    try {
      Response response = await post(
          Uri.parse(
              "https://admin.rise.ng/api/payment/initialize/direct-purchase"),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'listing_ids': listing_id.toString(),
            'amount': price.toString(),
          });
      var data = jsonDecode(response.body.toString());
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        Navigator.pop(ctxt);
        showOffer(ctxt, data['message'],
            data['data']['data']['data']['authorization_url']);
      } else {
        EasyLoading.dismiss();
        Navigator.pop(ctxt);
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
        ScaffoldMessenger.of(ctxt)
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

  void payWithRoute(ctxt, listing_id, price, route) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    EasyLoading.show();
    print("this is $price");
    print('make payment sup');
    try {
      Response response = await post(
          Uri.parse(
              "https://admin.rise.ng/api/payment/initialize/direct-purchase"),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'listing_ids': listing_id.toString(),
            'amount': price.toString(),
          });
      var data = jsonDecode(response.body.toString());
      print(data);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        Navigator.pop(ctxt);
        showOffer(ctxt, data['message'],
            data['data']['data']['data']['authorization_url']);
      } else {
        EasyLoading.dismiss();
        Navigator.pop(ctxt);
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
        ScaffoldMessenger.of(ctxt)
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
  void showLogistics(BuildContext ctx) {
    if (widget.dataModel['minimum_offer'] != null &&
        widget.dataModel['minimum_offer'].length >= 3) {
      var str = widget.dataModel['minimum_offer']
          .substring(0, widget.dataModel['minimum_offer'].length - 3);
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
                              "N${widget.dataModel['minimum_offer']!}",
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
                              payWithRoute(
                                  context,
                                  widget.dataModel.id.toString(),
                                  int.parse(now) + routeDetail['amount'],
                                  routeDetail['id']);
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

  void showNegotiation(BuildContext ctx) {
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
                      "Initial Price Offer (in naira)",
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
                            "N${widget.dataModel['minimum_offer']}",
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
                      "Your bargain (in naira)",
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
                    TextFormField(
                      controller: priceOfferEditingController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Text(
                            "naira only",
                            style: GoogleFonts.poppins(
                                color: primaryColor,
                                // fontFamily: 'Chillax',
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp),
                          ),
                        ),
                        hintText: "do not use comma",
                        hintStyle: GoogleFonts.poppins(
                          // fontFamily: 'Chillax',
                          color: const Color(0xffb5b5b5).withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                          fontSize: 9.sp,
                        ),
                        fillColor: whiteColor,
                        filled: true,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 18.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: grayColor),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: primaryColor),
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
                        widget.dataModel['description'],
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RiseButtonNew(
                          text: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Send offer  ",
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
                            bookService(
                                context,
                                widget.dataModel['id'].toString(),
                                widget.dataModel['title'].toString(),
                                widget.dataModel['description'].toString(),
                                priceOfferEditingController.text.toString());
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
  }

  void showOffer(ctx, text, link) {
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
                        "Congratulations, you have Initialized payment to ${widget.dataModel['title']} for ${widget.dataModel['description']}",
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

  @override
  Widget build(BuildContext context) {
    print(widget.dataModel.toString());
    print('this is listing id ${widget.dataModel['id']}');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: RichText(
              text: const TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.3,
              child: ExpandableCarousel.builder(
                options: CarouselOptions(
                  height: 20.h,
                  aspectRatio: 16 / 12,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  pageSnapping: true,
                  scrollDirection: Axis.vertical,
                  pauseAutoPlayOnTouch: true,
                  pauseAutoPlayOnManualNavigate: true,
                  pauseAutoPlayInFiniteScroll: false,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  disableCenter: false,
                  showIndicator: true,
                  slideIndicator: const CircularSlideIndicator(),
                ),
                itemCount: widget.dataModel['listing_images'].length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        Hero(
                  tag: 'imageHero + ${widget.index}',
                  child: AspectRatio(
                    aspectRatio: 16 / 12,
                    child: CachedNetworkImage(
                      imageBuilder: (context, imageProvider) {
                        return Image(
                          image: imageProvider,
                          height: 20.h,
                          width: 100.w,
                          fit: BoxFit.cover,
                        );
                      },
                      fit: BoxFit.cover,
                      imageUrl: widget.dataModel['listing_images'][itemIndex],
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.55,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  color: whiteColor.withOpacity(0.99)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      widget.dataModel['title'],
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        // fontFamily: 'Chillax',
                        color: blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.store,
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " ${widget.dataModel['service_offering']}",
                                  style: GoogleFonts.poppins(
                                    color: blackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                const WidgetSpan(
                                  child: Icon(Icons.production_quantity_limits,
                                      size: 18, color: primaryColor),
                                ),
                                TextSpan(
                                  text: widget.dataModel['category'],
                                  style: GoogleFonts.poppins(
                                    color: blackColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.dataModel['minimum_offer'],
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        // fontFamily: 'Chillax',
                        color: blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 24.sp,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21.0),
                      child: Text(
                        widget.dataModel['description'],
                        style: GoogleFonts.poppins(
                          // fontFamily: 'Chillax',
                          color: blackColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                        softWrap: false,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RiseButtonNew(
                          text: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Book now  ",
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
                                    Icons.bookmark_outline,
                                    size: 22,
                                    color: secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          buttonColor: blackColor,
                          textColor: whiteColor,
                          onPressed: () {
                            String result = widget.dataModel['minimum_offer']
                                .substring(
                                    0,
                                    widget.dataModel['minimum_offer'].length -
                                        3);
                            bookService(
                                context,
                                widget.dataModel['id'].toString(),
                                widget.dataModel['title'].toString(),
                                widget.dataModel['description'].toString(),
                                result);
                          }),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RiseButtonNew(
                          text: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Make payment  ",
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
                                    Icons.payment,
                                    size: 22,
                                    color: secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          buttonColor: blackColor,
                          textColor: whiteColor,
                          onPressed: () async {
                            // print(
                            //     'this is listing id ${widget.dataModel['id']}');
                            // if (widget.userType == "Vendor") {
                            //   showLogistics(context);
                            // } else {
                            payDirect(
                              context,
                              widget.dataModel['id'].toString(),
                              widget.dataModel['minimum_offer'],
                            );
                            // }
                          }),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RiseButtonNew(
                          text: Text(
                            "Negotiate offer",
                            // overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              // fontFamily: 'Chillax',
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          buttonColor: secondaryColor.withOpacity(0.3),
                          textColor: blackColor,
                          onPressed: () {
                            showNegotiation(context);
                          }),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Other listings by ${widget.dataModel['title']}",
                          style: GoogleFonts.poppins(
                            // fontFamily: 'Chillax',
                            color: blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    fetchedListings == null
                        ? Container()
                        : GridView.builder(
                            itemCount: fetchedListings.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.65,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ViewProductDetailScreen(
                                      dataModel: fetchedSubListing[index],
                                      userType: widget.userType,
                                      index: index,
                                    );
                                  }));
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
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
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: whiteColor,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                            alignment: Alignment.center,
                                            child: Hero(
                                              tag: 'imageHero2 + $index',
                                              child: AspectRatio(
                                                aspectRatio: 16 / 12,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15)),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        fetchedListings[index]
                                                            .listingImages[0],
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Center(
                                                            child: Icon(
                                                                Icons.error)),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          color: grayColor.withOpacity(
                                              0.3), //color of divider
                                          height: 3, //height spacing of divider
                                          thickness:
                                              2, //thickness of divier line
                                          indent:
                                              25, //spacing at the start of divider
                                          endIndent:
                                              25, //spacing at the end of divider
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          fetchedListings[index].title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            // fontFamily: 'Chillax',
                                            color: blackColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child:
                                                    Icon(Icons.store, size: 14),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' ${fetchedListings[index].serviceOffering}',
                                                // overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  // fontFamily: 'Chillax',
                                                  color: blackColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 9.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          fetchedListings[index].minimumOffer,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            // fontFamily: 'Chillax',
                                            color: blackColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            shrinkWrap: true,
                            primary: false,
                            padding: const EdgeInsets.all(20),
                          ),
                    const SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
