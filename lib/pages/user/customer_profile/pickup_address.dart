import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:rise/constants.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'customer_profile_page.dart';

class PickUpAddressPage extends StatefulWidget {
  const PickUpAddressPage({Key? key}) : super(key: key);

  @override
  PickUpAddressPageState createState() => PickUpAddressPageState();
}

class PickUpAddressPageState extends State<PickUpAddressPage> {
  var selectedListing;
  static final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    getLocations();
    // TODO: implement initState
    getLocations();
    super.initState();
  }

  var locationList = [];

  var selectedLocation;

  void savePickUp(route) async {
    EasyLoading.show();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    int country_id = 166;
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/pick_up/add-my-routes"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'route': route,
            // 'state_id': s
          });

      var data = jsonDecode(response.body.toString());
      print(response.statusCode.toString());
      // print(data);

      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Saved!',
            message: data['message'].toString(),
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        EasyLoading.dismiss();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CustomerProfilePage()));

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
          message: 'Something went wrong',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<void> getLocations() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    print('fetching locations');

    try {
      final response = await get(
          Uri.parse('https://admin.rise.ng/api/pick_up/routes'),
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
          locationList = data['data']['availablePickUPRoutes'];
          // print(lgaList);
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.back, size: 18),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.pushReplacement(context,
                //      MaterialPageRoute(builder: (context) => new OnboardScreen()));
              },
            )),
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
      body: Stack(children: <Widget>[
        SafeArea(
          child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 32.0,
                          top: 16.0,
                          right: 32.0,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Please select a pickup address",
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  const SizedBox(height: 30.0),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 3, bottom: 3),
                                    decoration: BoxDecoration(
                                        color: whiteColor.withOpacity(0.29),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        border: const Border(
                                          top: BorderSide(
                                              width: 2, color: grayColor),
                                          left: BorderSide(
                                              width: 2, color: grayColor),
                                          right: BorderSide(
                                              width: 2, color: grayColor),
                                          bottom: BorderSide(
                                              width: 2, color: grayColor),
                                        )),
                                    child: DropdownButton(
                                      hint: Text(
                                        "--Select Pickup Address--",
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
                                          color: Colors.black, fontSize: 12),
                                      value: selectedLocation,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedLocation = newValue;
                                        });
                                      },
                                      items: locationList
                                          .map<DropdownMenuItem<String>>(
                                              (valueItem) {
                                        return DropdownMenuItem(
                                          onTap: () {
                                            // getAllLGA(valueItem['id']);
                                            // setState(() {
                                            //   state_id = valueItem['id'];
                                            // });
                                          },
                                          value: valueItem,
                                          child: Text(valueItem),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding * 25.0),

                              // const SizedBox(height: 30.0 * 2.0),
                              SizedBox(
                                width: double.infinity,
                                child: RiseButton(
                                  text: "Save Pickup Address",
                                  buttonColor: blackColor,
                                  onPressed: () {
                                    savePickUp(selectedLocation);
                                  },
                                  textColor: whiteColor,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ]),
    );
  }
}
