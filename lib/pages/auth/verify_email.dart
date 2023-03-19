import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/auth/signin_screen.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../data/model/login/login_response_model.dart';
import 'accountverification/accountverifictionscreen.dart';

class VerifyEmail extends StatefulWidget {
  final String where;
  const VerifyEmail({super.key, required this.where});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
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
    widget.where == 'registration' ? resendVerification() : null;
    // TODO: implement initState
    // getSavedData();
    super.initState();
  }

  void getSavedData() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    Map<String, dynamic> jsonData = jsonDecode(_shared.getString("userData")!);
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

  static final TextEditingController mailEditingController =
      TextEditingController();
  static final TextEditingController tokenEditingController =
      TextEditingController();

  void mailVerification(context, email, token, where) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/verify-email/token"),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'email': email,
            'token': token
          });
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
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

        if (where == 'registration') {
          const AccountVerificationScreen();
        } else {
          Navigator.pop(context);
        }

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
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 32.0,
                      top: 16.0,
                      right: 32.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "your email hasn\'t been verified yet",
                        style: GoogleFonts.poppins(
                            wordSpacing: 0.5,
                            letterSpacing: -1,
                            color: blackColor,
                            // fontFamily: 'Chillax',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "We've have sent you a token via email",
                        style: GoogleFonts.poppins(
                            wordSpacing: 0.5,
                            letterSpacing: -1,
                            color: blackColor,
                            // fontFamily: 'Chillax',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: defaultPadding / 2.0,
                      ),
                      Text(
                        "Kindly enter your email and token to verify your account ",
                        style: TextStyle(
                            // fontFamily: 'Outfit',
                            color: grayColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: defaultPadding * 2.0),
                      Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16.0),
                              //const TextFieldName(text: "Email Address"),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: mailEditingController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.mail),
                                      hintText: "Enter your email",
                                      hintStyle: TextStyle(
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
                                          const EdgeInsets.all(18.0),
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
                                    validator: emailValidator,
                                    // onSaved: (email) => loginRequest!.email = email!,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: tokenEditingController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.phone),
                                      hintText: "Enter your verification token",
                                      hintStyle: TextStyle(
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
                                          const EdgeInsets.all(18.0),
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
                                    validator: tokenValidator,
                                    // onSaved: (email) => loginRequest!.email = email!,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Did not get the mail?",
                                        style: TextStyle(
                                          color: const Color(0xff313131)
                                              .withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                          // fontFamily: 'Chillax',
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          resendVerification();
                                        },
                                        child: Text(
                                          "  Send again",
                                          style: TextStyle(
                                            // fontFamily: 'Chillax',
                                            color: primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 70),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding * 15.0),

                              // const SizedBox(height: 30.0 * 2.0),
                              SizedBox(
                                width: double.infinity,
                                child: RiseButton(
                                  text: "Verify Token",
                                  buttonColor: blackColor,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      mailVerification(
                                          context,
                                          mailEditingController.text.toString(),
                                          tokenEditingController.text
                                              .toString(),
                                          widget.where);

                                      //   registerNewUserRequest!.phoneNumber = widget.phoneNumber;
                                      //   registerNewUserRequest?.userType = selectedAccountType;
                                      //   BlocProvider.of<RegisterNewUserBloc>(context).add(LoadRegisterNewUserEvent(requestBody: registerNewUserRequest));
                                    }
                                  },
                                  textColor: whiteColor,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              widget.where == 'registration'
                                  ? Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SignInScreen()),
                                                  (route) => false);
                                        },
                                        child: Text(
                                          "Return to Login",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.sp),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ]),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ]),
    );
  }
}
