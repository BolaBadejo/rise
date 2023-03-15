import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/user/customer_profile/kyc/bio_data_kyc/personal_info.dart';
import 'package:rise/utils/shared_preferences.dart';
import 'package:rise/data/model/login/login_response_model.dart';
import 'package:rise/widgets/custom_snack_bar.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'bank_info_kyc.dart';

class BankDataKYC extends StatefulWidget {
  final type;
  const BankDataKYC({Key? key, required this.type}) : super(key: key);

  @override
  BankDataKYCState createState() => BankDataKYCState();
}

class BankDataKYCState extends State<BankDataKYC> {
  var selectedListing;
  static final _formKey = GlobalKey<FormState>();

  User userData = User(
    emailVerified: false,
    kycVerified: false,
    riseInsured: false,
    riseVerified: false,
  );
  @override
  void initState() {
    // TODO: implement initState
    // getSavedData();
    super.initState();
  }

  void getSavedData() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    Map<String, dynamic> jsonData = jsonDecode(_shared.getString("userData")!);
  }

  static final TextEditingController ninEditingController =
      TextEditingController();
  static final TextEditingController phoneEditingController =
      TextEditingController();

  void bvnVerification(context, bvn, phone) async {
    // print('bvn');
    var number = "234${phone!.substring(1)}";
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/kyc/verify/bvn"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'bvn': bvn,
            'phone': phone
          });
      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        // print(data);
        // showCustomSnackBar(
        //     context, data['message'], Colors.green, Colors.white);
        // context.showToastySnackbar('error ${response.statusCode.toString()}',
        // data['message'], AlertType.danger);
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Verified',
            message: data['message'],

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BankInfo(
                      data: data['data'],
                      bvn: bvn,
                      type: widget.type,
                    )));
        // print("done successfully");
      } else {
        // print('error ${response.statusCode.toString()}');
        // print(data['message']);
        EasyLoading.dismiss();
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error ${response.statusCode.toString()}',
            message: data['message'],

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        // showCustomSnackBar(context, 'error ${response.statusCode.toString()}',
        //     Colors.red, Colors.white);
      }
    } catch (e) {
      // print(e.toString());
      EasyLoading.dismiss();
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: e.toString(),

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  var items = [
    'bvn',
    'nin',
  ];

  String dropdownvalue = 'nin';

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
                                    "Please confirm the following information",
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  const SizedBox(height: 30.0),
                                  TextFormField(
                                    controller: ninEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.numbers),
                                      hintText: "Enter your BVN",
                                      hintStyle: GoogleFonts.poppins(
                                        color: const Color(0xffb5b5b5)
                                            .withOpacity(0.5),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                        // fontFamily: 'Chillax',
                                      ),
                                      fillColor: whiteColor,
                                      filled: true,
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.all(10.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2,
                                            color: grayColor), //<-- SEE HERE
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2, color: primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      // If  you are using latest version of flutter then lable text and hint text shown like this
                                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    ),
                                    // validator: emailValidator,
                                    // onSaved: (email) => loginRequest!.email = email!,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: phoneEditingController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.phone),
                                      hintText: "phone number",
                                      hintStyle: GoogleFonts.poppins(
                                        color: const Color(0xffb5b5b5)
                                            .withOpacity(0.5),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                        // fontFamily: 'Chillax',
                                      ),
                                      fillColor: whiteColor,
                                      filled: true,
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.all(10.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2,
                                            color: grayColor), //<-- SEE HERE
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2, color: primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      // If  you are using latest version of flutter then lable text and hint text shown like this
                                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    ),
                                    validator: phoneNumberValidator,
                                    // onSaved: (email) => loginRequest!.email = email!,
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding * 25.0),

                              // const SizedBox(height: 30.0 * 2.0),
                              SizedBox(
                                width: double.infinity,
                                child: RiseButton(
                                  text: "Retrieve Data",
                                  buttonColor: blackColor,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      // showCustomSnackBar(
                                      //     context,
                                      //     'Listing created succssfully',
                                      //     Colors.green,
                                      //     Colors.white);
                                      // Navigator.of(context).pop();

                                      bvnVerification(
                                        context,
                                        ninEditingController.text.toString(),
                                        phoneEditingController.text.toString(),
                                      );
                                    }
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
