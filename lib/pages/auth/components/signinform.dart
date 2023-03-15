import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:rise/data/model/login/login_request_model.dart';
import 'package:rise/pages/artisan/home_artisan/home_nav_screen.dart';
import 'package:rise/pages/user/home/account_type_selection.dart';
import 'package:rise/pages/user/home/home_nav_screen.dart';
import 'package:rise/pages/vendor/home_vendor/home_nav_screen.dart';
import 'package:rise/widgets/custom_snack_bar.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../constants.dart';
import '../../../utils/shared_preferences.dart';
import '../signupscreen.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  SignInFormState createState() => SignInFormState();
}

class SignInFormState extends State<SignInForm> {
  static final _formKey = GlobalKey<FormState>();
  LoginRequest? loginRequest;

  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();

  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Position? _currentPosition;

  String city = " ";
  String stateValue = " ";

  String? getLatitude;
  String? getLongitude;
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController addressEditingController =
      TextEditingController();
  final TextEditingController emailFEditingController = TextEditingController();
  final TextEditingController passwordFEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordEditingController =
      TextEditingController();
  final TextEditingController tokenEditingController = TextEditingController();

  void forgotPassword(context, email) async {
    EasyLoading.show();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      Response response = await post(
          Uri.parse("http:/?178.62.29.92/api/auth/forgot-password"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'email': email,
          });
      var data = jsonDecode(response.body.toString());
      // print(data);

      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Updated',
            message: data['message'],
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        EasyLoading.dismiss();
        Navigator.pop(context);
        // print("done successfully");
      } else {
        // print('error ${response.statusCode.toString()}');
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
          message: e.toString(),
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  void resetPassword(context, eMail, password, passwordc, token) async {
    EasyLoading.show();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/auth/reset-password"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'email': eMail,
            'password': password,
            'password_confirmation': passwordc,
            'token': token,
          });
      var data = jsonDecode(response.body.toString());
      // print(data);

      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Updated',
            message: data['message'],
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        EasyLoading.dismiss();
        Navigator.pop(context);
        // print("done successfully");
      } else {
        // print('error ${response.statusCode.toString()}');
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
          message: e.toString(),
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  _getCurrentLocation() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          getLatitude = _currentPosition!.latitude.toString();
          getLongitude = _currentPosition!.longitude.toString();
          _getAddressFromLatLng();
        });
      }
    }).catchError((e) {
      //// print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        city = place.locality!;
        stateValue = place.administrativeArea!;
      });
    } catch (e) {
      //// print(e);
    }
  }

  void logIn(context, email, password) async {
    EasyLoading.show();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/auth/login"),
          body: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // print(data['data']);
        // print('logged in');
        // await Preferences.saveUserData(data['data']['user']);
        sharedPreferences.setString(
            'access_token', data['data']['access_token']);
        sharedPreferences.setString(
            'full_name', data['data']['user']['full_name']);
        sharedPreferences.setString('email', data['data']['user']['email']);
        sharedPreferences.setString(
            'referral_token', data['data']['user']['referral_token']);
        sharedPreferences.setString(
            'user_type', data['data']['user']['user_type']);
        // showCustomSnackBar(
        // context, data['message'], Colors.green, Colors.white);
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'there you go',
            message: data['message'],

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        EasyLoading.dismiss();

        if (data['data']['user']['user_type'] == 'Artisan' ||
            data['data']['user']['user_type'] == 'artisan') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeNavScreenArtisan()));
        } else if (data['data']['user']['user_type'] == 'Vendor' ||
            data['data']['user']['user_type'] == 'vendor') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeNavScreenArtisan()));
        } else if (data['data']['user']['user_type'] == 'Default' ||
            data['data']['user']['user_type'] == 'default') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeNavScreen()));
        } else {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error',
              message: 'User type not defined',
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
        // print(data['data']['user']);
        // print("done successfully");
      } else {
        EasyLoading.dismiss();
        // print('error ${response.statusCode.toString()}');
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error ${response.statusCode.toString()}',
            message: 'There was an error signing in',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {
      EasyLoading.dismiss();
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

  @override
  initState() {
    _getCurrentLocation();
    loginRequest = LoginRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          TextFormField(
            controller: emailEditingController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                // fontFamily: 'Chillax',
                color: blackColor),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail),
              hintText: "Email Address",
              hintStyle: TextStyle(
                color: const Color(0xffb5b5b5).withOpacity(0.5),
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                // fontFamily: 'Chillax',
              ),
              fillColor: whiteColor,
              filled: true,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 2, color: grayColor), //<-- SEE HERE
                borderRadius: BorderRadius.circular(50.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: primaryColor),
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            validator: emailValidator,
            onSaved: (email) => loginRequest!.email = email!,
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_open),
              hintText: "Password",
              hintStyle: GoogleFonts.poppins(
                color: const Color(0xffb5b5b5).withOpacity(0.5),
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                // fontFamily: 'Chillax',
              ),
              suffixIcon: InkWell(
                onTap: _togglePasswordView,
                child: Icon(
                  _isHidden ? Icons.visibility_off : Icons.visibility,
                  color: _isHidden ? Colors.grey : primaryColor,
                ),
              ),
              fillColor: whiteColor,
              filled: true,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 2, color: grayColor), //<-- SEE HERE
                borderRadius: BorderRadius.circular(50.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: primaryColor),
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            controller: passwordEditingController,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                // fontFamily: 'Chillax',
                color: blackColor),
            obscureText: _isHidden,
            validator: passwordValidator,
            onSaved: (password) => loginRequest!.password = password!,
          ),
          const SizedBox(
            height: defaultPadding / 2.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             const ForgetPasswordScreen()));
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Forgot Password',
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        content: SizedBox(
                          height: 15.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'email',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: emailFEditingController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "Enter your email",
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xffb5b5b5)
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9.sp,
                                    // fontFamily: 'Chillax',
                                  ),
                                  fillColor: whiteColor,
                                  filled: true,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(10.0),
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
                                  // If  you are using latest version of flutter then lable text and hint text shown like this
                                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                                ),
                                validator: emailValidator,
                                // onSaved: (email) => loginRequest!.email = email!,
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('Send'),
                            onPressed: () {
                              Navigator.pop(context);
                              forgotPassword(context,
                                  emailFEditingController.text.toString());
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Reset Password\nEvery field is required',
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    content: SizedBox(
                                      height: 44.h,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'We have sent a token to ${emailFEditingController.text.toString()}',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'token',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller: tokenEditingController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              hintText: "Enter your token",
                                              hintStyle: GoogleFonts.poppins(
                                                color: const Color(0xffb5b5b5)
                                                    .withOpacity(0.5),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 9.sp,
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
                                                    color:
                                                        grayColor), //<-- SEE HERE
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 2,
                                                    color: primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              // If  you are using latest version of flutter then lable text and hint text shown like this
                                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                                            ),
                                            // validator:
                                            //     emailValidator,
                                            // onSaved: (email) => loginRequest!.email = email!,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Password',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                passwordFEditingController,
                                            keyboardType: TextInputType.text,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Enter your new password",
                                              hintStyle: GoogleFonts.poppins(
                                                color: const Color(0xffb5b5b5)
                                                    .withOpacity(0.5),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 9.sp,
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
                                                    color:
                                                        grayColor), //<-- SEE HERE
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 2,
                                                    color: primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              // If  you are using latest version of flutter then lable text and hint text shown like this
                                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                                            ),
                                            // validator: emailValidator,
                                            // onSaved: (email) => loginRequest!.email = email!,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Confirm Password',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller:
                                                confirmPasswordEditingController,
                                            keyboardType: TextInputType.text,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Confirm your new password",
                                              hintStyle: GoogleFonts.poppins(
                                                color: const Color(0xffb5b5b5)
                                                    .withOpacity(0.5),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 9.sp,
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
                                                    color:
                                                        grayColor), //<-- SEE HERE
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 2,
                                                    color: primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              // If  you are using latest version of flutter then lable text and hint text shown like this
                                              // if you r using flutter less then 1.20.* then maybe this is not working properly
                                            ),
                                            // validator: emailValidator,
                                            // onSaved: (email) => loginRequest!.email = email!,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Reset'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          resetPassword(
                                              context,
                                              emailFEditingController.text
                                                  .toString(),
                                              passwordFEditingController.text
                                                  .toString(),
                                              confirmPasswordEditingController
                                                  .text
                                                  .toString(),
                                              tokenEditingController.text
                                                  .toString());
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 9.sp,
                    // fontFamily: 'Chillax',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding * 2.0),
          SizedBox(
            width: double.infinity,
            child: RiseButton(
              text: "Log In",
              buttonColor: blackColor,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  FocusManager.instance.primaryFocus?.unfocus();
                  logIn(context, emailEditingController.text.toString(),
                      passwordEditingController.text.toString());
                }
              },
              textColor: whiteColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "New to Rísé? ",
                style: TextStyle(
                  color: const Color(0xff313131).withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                  // fontFamily: 'Chillax',
                  fontSize: 9.sp,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()));
                },
                child: Text(
                  "Sign up for free",
                  style: TextStyle(
                    // fontFamily: 'Chillax',
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 9.sp,
                  ),
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ],
      ),
    );
  }
}
