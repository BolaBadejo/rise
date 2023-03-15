import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/artisan/home_artisan/home_nav_screen.dart';
import 'package:rise/pages/user/customer_profile/kyc/user-kyc.dart';
import 'package:rise/pages/user/home/home_nav_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../../../widgets/rise_button.dart';
import '../../../../vendor/home_vendor/home_nav_screen.dart';

// const kGoogleApiKey = "Api_key";

// GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class PersonalInfo extends StatefulWidget {
  final data;
  final type;
  const PersonalInfo({super.key, this.data, required this.type});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  var selectedListing;
  static final _formKey = GlobalKey<FormState>();

  bool checked = false;

  bool switchStatus = false;

  bool _isHidden = true;
  bool _isHiddenConfirmPassword = true;

  var lgaList = [];
  var stateList = [];

  var selectedState;

  Position? _currentPosition;
  double getLatitude = 0.0;
  double getLongitude = 0.0;
  double distance = 100;
  bool ignore = true;

  bool isSearching = false;
  bool isLoading = false;

  var lga_id;

  var state_id;

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
          // print("lat $getLatitude lng $getLongitude");
          // _getAddressFromLatLng();
        });
      }
    }).catchError((e) {
      //// print(e);
    });
  }

  @override
  initState() {
    getAllStates();
    _getCurrentLocation();
    super.initState();
  }

  Future<void> getAllStates() async {
    var baseUrl = "https://admin.rise.ng/api/location/states/166";

    http.Response response = await http.get(Uri.parse(baseUrl));

    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();

    try {
      final response = await get(
          Uri.parse('https://admin.rise.ng/api/location/states/166'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print(data);
        // print("States fetched");
        setState(() {
          stateList = data['data']['states'];
          // print(lgaList);
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> getAllLGA(stateID) async {
    var baseUrl = "https://admin.rise.ng/api/location/states/166";

    http.Response response = await http.get(Uri.parse(baseUrl));

    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();

    try {
      final response = await get(
          Uri.parse('https://admin.rise.ng/api/location/lgas/166/$stateID'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print(data);
        // print("LGAs fetched");
        setState(() {
          lgaList = data['data']['lgas'];
          // print(lgaList);
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  void submitPersonalInfo(context, bvn, firstName, lastName, dateOfBirth, city,
      address, lga_id, state_id) async {
    EasyLoading.show();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    int country_id = 166;
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/kyc/save-personal-info"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'bvn': bvn,
            'first_name': firstName,
            'last_name': lastName,
            'date_of_birth': dateOfBirth,
            'residential_address': address,
            'city': city,
            'state_id': state_id.toString(),
            'country_id': country_id.toString(),
            'lga_id': lga_id.toString(),
            'lng': getLongitude.toString(),
            'lat': getLatitude.toString(),
            // 'state_id': s
          });

      var data = jsonDecode(response.body.toString());
      // print(response.statusCode.toString());
      // print(data);

      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Nice!',
            message: data['message'],
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        EasyLoading.dismiss();

        if (widget.type == 'Artisan' || widget.type == 'artisan') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeNavScreenArtisan()));
        } else if (widget.type == 'Vendor' || widget.type == 'vendor') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeNavScreenVendor()));
        } else if (widget.type == 'Default' || widget.type == 'default') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeNavScreen()));
        } else {}

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

  static final TextEditingController cityEditingController =
      TextEditingController();
  static TextEditingController addressEditingController =
      TextEditingController();
  String category = 'choose listings category';
  List<String> accountTypeList = [
    "Vendor",
    "Artisan",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40.0),
                            Text(
                              "Please enter the correct information below",
                              style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            //const TextFieldName(text: "Email Address"),
                            Text(
                              "First Name",
                              style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: grayColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
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
                                    widget.data['personal_info']
                                            ['first_name'] ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            //const TextFieldName(text: "Email Address"),
                            Text(
                              "Last Name",
                              style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: grayColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
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
                                    widget.data['personal_info']['last_name'] ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            //const TextFieldName(text: "Email Address"),
                            Text(
                              "Date of Birth",
                              style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: grayColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
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
                                    widget.data['personal_info']
                                            ['date_of_birth'] ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Residential_Address",
                              style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: grayColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: addressEditingController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                fillColor: whiteColor,
                                filled: true,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 18.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2,
                                      color: grayColor), //<-- SEE HERE
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: primaryColor),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              "City",
                              style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: grayColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: cityEditingController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                fillColor: whiteColor,
                                filled: true,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 18.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2,
                                      color: grayColor), //<-- SEE HERE
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: primaryColor),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              "State",
                              style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: grayColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 3, bottom: 3),
                              decoration: BoxDecoration(
                                  color: whiteColor.withOpacity(0.29),
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: const Border(
                                    top: BorderSide(width: 2, color: grayColor),
                                    left:
                                        BorderSide(width: 2, color: grayColor),
                                    right:
                                        BorderSide(width: 2, color: grayColor),
                                    bottom:
                                        BorderSide(width: 2, color: grayColor),
                                  )),
                              child: DropdownButton(
                                hint: Text(
                                  "--STATE--",
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
                                value: selectedState,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedState = newValue;
                                  });
                                },
                                items: stateList
                                    .map<DropdownMenuItem<String>>((valueItem) {
                                  return DropdownMenuItem(
                                    onTap: () {
                                      getAllLGA(valueItem['id']);
                                      setState(() {
                                        state_id = valueItem['id'];
                                      });
                                    },
                                    value: valueItem['name'],
                                    child: Text(valueItem['name']),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            Text(
                              "LGA",
                              style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: grayColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 3, bottom: 3),
                              decoration: BoxDecoration(
                                  color: whiteColor.withOpacity(0.29),
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: const Border(
                                    top: BorderSide(width: 2, color: grayColor),
                                    left:
                                        BorderSide(width: 2, color: grayColor),
                                    right:
                                        BorderSide(width: 2, color: grayColor),
                                    bottom:
                                        BorderSide(width: 2, color: grayColor),
                                  )),
                              child: DropdownButton(
                                hint: Text(
                                  "--LGA--",
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
                                value: selectedListing,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedListing = newValue;
                                  });
                                },
                                items: lgaList
                                    .map<DropdownMenuItem<String>>((valueItem) {
                                  return DropdownMenuItem(
                                    onTap: () {
                                      setState(() {
                                        lga_id = valueItem['id'];
                                      });
                                    },
                                    value: valueItem['name'],
                                    child: Text(valueItem['name']),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const SizedBox(height: 16.0 * 2.0),
                            SizedBox(
                              width: double.infinity,
                              child: RiseButtonNew(
                                text: Text(
                                  "Submit",
                                  style: GoogleFonts.poppins(
                                    // fontFamily: 'Chillax',
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                buttonColor: blackColor,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // print('${lga_id} ${state_id}');
                                    submitPersonalInfo(
                                        context,
                                        widget.data['bvn_number'].toString(),
                                        widget.data['personal_info']
                                                ['fitst_name']
                                            .toString(),
                                        widget.data['personal_info']
                                                ['last_name']
                                            .toString(),
                                        widget.data['personal_info']
                                                ['date_of_birth']
                                            .toString(),
                                        cityEditingController.text.toString(),
                                        addressEditingController.text
                                            .toString(),
                                        lga_id,
                                        state_id);
                                  }
                                },
                                textColor: whiteColor,
                              ),
                            ),
                            const SizedBox(height: 64.0),
                          ]),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
