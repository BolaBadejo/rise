import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants.dart';
import '../../complete_profile/complete_profile_screen.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  @override
  State<StatefulWidget> createState() {
    return OtpFormState();
  }
}

class OtpFormState extends State<OtpForm> {
  static final _otpFormKey = GlobalKey<FormState>();

  TextEditingController inputBoxOneEditingController = TextEditingController();
  TextEditingController inputBoxTwoEditingController = TextEditingController();
  TextEditingController inputBoxThreeEditingController =
      TextEditingController();
  TextEditingController inputBoxFourEditingController = TextEditingController();

  void generateOTP(context, phoneNumber) async {
    var number = "234${phoneNumber!.substring(1)}";
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/auth/generate-otp"),
          body: {'phone_number': number});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Nice!',
            message: data['message'].toString(),
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

  void verifyOTP(context, phoneNumber, otp) async {
    var number = "234${phoneNumber!.substring(1)}";
    EasyLoading.show();
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/auth/verify-otp"),
          body: {'phone_number': number, 'otp': otp});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success',
            message: data['message'].toString(),
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        EasyLoading.dismiss();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CompleteProfileScreen(
              phoneNumber: widget.phoneNumber,
            ),
          ),
        );
        // print(data['message']);
        // print("done successfully");
      } else {
        // print('error ${response.statusCode.toString()}');
        EasyLoading.dismiss();
        // showCustomSnackBar(context, 'error ${response.statusCode.toString()}',
        // Colors.red, Colors.white);
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error ${response.statusCode.toString()}',
            message: 'Something went wrong',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
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
      // showCustomSnackBar(context, e.toString(), Colors.red, Colors.white);
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
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _otpFormKey,
      child: Column(
        children: [
          const SizedBox(height: defaultPadding * 3.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 7.h,
                width: 7.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: TextFormField(
                    controller: inputBoxOneEditingController,
                    style: Theme.of(context).textTheme.titleLarge,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: "0",
                      hintStyle: TextStyle(color: Colors.grey.shade300),
                      contentPadding: const EdgeInsets.all(0.0),
                      // fillColor: grayColor.withOpacity(0.27),
                      filled: true,
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
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Container(
                height: 7.h,
                width: 7.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: TextFormField(
                    controller: inputBoxTwoEditingController,
                    style: Theme.of(context).textTheme.titleLarge,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: "0",
                      hintStyle: TextStyle(color: Colors.grey.shade300),
                      contentPadding: const EdgeInsets.all(0.0),
                      // fillColor: grayColor.withOpacity(0.27),
                      filled: true,
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
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                      if (value.isEmpty) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Container(
                height: 7.h,
                width: 7.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: TextFormField(
                    controller: inputBoxThreeEditingController,
                    style: Theme.of(context).textTheme.titleLarge,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: "0",
                      hintStyle: TextStyle(color: Colors.grey.shade300),
                      contentPadding: const EdgeInsets.all(0.0),
                      // fillColor: grayColor.withOpacity(0.27),
                      filled: true,
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
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                      if (value.isEmpty) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Container(
                height: 7.h,
                width: 7.h,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: TextFormField(
                    controller: inputBoxFourEditingController,
                    style: Theme.of(context).textTheme.titleLarge,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: "0",
                      hintStyle: TextStyle(color: Colors.grey.shade300),
                      contentPadding: const EdgeInsets.all(0.0),
                      // fillColor: grayColor.withOpacity(0.27),
                      filled: true,
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
                      // isDense: true,
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                      if (value.isEmpty) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          //const SizedBox(height: defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Didn't recieve code? ",
                style: TextStyle(
                  // fontFamily: 'Chillax',
                  color: const Color(0xff201E1E).withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                ),
              ),
              GestureDetector(
                onTap: () {
                  generateOTP(context, widget.phoneNumber);
                },
                child: Text(
                  "Resend now",
                  style: TextStyle(
                    // fontFamily: 'Chillax',
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
          const SizedBox(height: defaultPadding * 10.0),
          SizedBox(
            width: double.infinity,
            child: RiseButton(
              text: "Create Account",
              buttonColor: primaryColor,
              onPressed: () {
                var otpValue =
                    "${inputBoxOneEditingController.text}${inputBoxTwoEditingController.text}${inputBoxThreeEditingController.text}${inputBoxFourEditingController.text}";
                verifyOTP(context, widget.phoneNumber, otpValue);
                // verifyOtpRequest!.otp = otpValue;
                // verifyOtpRequest!.phoneNumber = widget.phoneNumber;

                // BlocProvider.of<VerifyOtpBloc>(context)
                //     .add(LoadVerifyOtpEvent(requestBody: verifyOtpRequest));
              },
              textColor: whiteColor,
            ),
          ),
          const SizedBox(height: defaultPadding),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Go back",
              style: TextStyle(
                // fontFamily: 'Chillax',
                color: primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
              ),
            ),
          ),
          const SizedBox(height: defaultPadding * 3),
        ],
      ),
    );
  }
}
