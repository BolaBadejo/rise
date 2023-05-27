import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/payment/payment_screen.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:rise/widgets/custom_snack_bar.dart';

class InsurePage extends StatefulWidget {
  const InsurePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return InsurePageState();
  }
}

class InsurePageState extends State<InsurePage> {
  var service;

  @override
  void initState() {
    fetchServices();
    super.initState();
  }

  Future<void> fetchServices() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    EasyLoading.show();

    try {
      final response = await get(
          Uri.parse('https://admin.rise.ng/api/services/all'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        // print(data);
        // print("Services progress fetched");
        setState(() {
          service = data['data']['services'][0];
          // print(service);
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
    EasyLoading.dismiss();
  }

  void payDirect(context) async {
    EasyLoading.show();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    // String arg = service['']
    try {
      Response response = await post(
          Uri.parse(
              "https://admin.rise.ng/api/payment/initialize/insure_product"),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'insurance_id': service['id'].toString(),
            'amount': 3000.toString(),
          });
      var data = jsonDecode(response.body.toString());
      // print(data);
      if (response.statusCode == 200) {
        // Navigator.pop(context);
        EasyLoading.dismiss();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PaymentScreen(
            link: data['data']['payment_url'],
          );
        }));
        // showOffer(context, data['message']);
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Insurance initialized!!',
            message: data['message'].toString(),
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        // print(data['data']);
        // print("done successfully");
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

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
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
        Positioned(
          bottom: -5,
          right: -5,
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.6,
            child: Image.asset(
              "assets/images/bg.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(
            width: double.infinity,
            height: 100.h,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Rise Insured",
                          style: TextStyle(
                              // fontFamily: 'Chillax',
                              color: secondaryColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: defaultPadding),
                        Text(
                          "Kindly read tthrough",
                          style: TextStyle(
                              // fontFamily: 'Chillax',
                              color: primaryColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: defaultPadding * 2.0),
                        Text(
                          'Get Rise Insured for only N3,000.00.\n Get the Insured badge on your account.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              // fontFamily: 'Chillax',
                              color: const Color(0xff313131).withOpacity(0.49),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 16 * 8),
                        RiseButton(
                          text: "Get Insured for N3,000.00",
                          buttonColor: blackColor,
                          onPressed: () {
                            payDirect(context);
                          },
                          textColor: whiteColor,
                        ),

                        // const OtpForm(),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ]),
    );
  }
}
