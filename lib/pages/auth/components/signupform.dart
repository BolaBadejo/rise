import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:rise/business_logic/generate_otp/generate_otp_bloc.dart';
import 'package:rise/data/model/generate_otp/generate_otp_response_model.dart';
import 'package:rise/services/api_handler.dart';
import 'package:rise/pages/auth/otp/otpscreen.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:sizer/sizer.dart';

import '../../../constants.dart';
import '../../../widgets/custom_snack_bar.dart';
import '../signin_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  static final _formKey = GlobalKey<FormState>();
  String phoneNumber = "";

  final TextEditingController phoneNumberEditingController =
      TextEditingController();

  void generateOTP(context, phoneNumber) async {
    var number = "234${phoneNumber!.substring(1)}";
    EasyLoading.show();
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/auth/generate-otp"),
          body: {'phone_number': number});
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success',
            message: data['message'],
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
                builder: (context) => OtpScreen(
                      phoneNumber: phoneNumber,
                    )));
        // print(data['message']);
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

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: defaultPadding * 2.0),
        TextFormField(
          controller: phoneNumberEditingController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(11),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintStyle: TextStyle(
              // fontFamily: 'Chillax',
              color: const Color(0xffb5b5b5).withOpacity(0.5),
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
            fillColor: whiteColor,
            filled: true,
            isDense: true,
            prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.phone)),
            suffixIcon: InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  generateOTP(
                      context, phoneNumberEditingController.text.toString());
                }
              },
              child: const Icon(Icons.arrow_forward, color: primaryColor),
            ),
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
          validator: RequiredValidator(errorText: "phonenumber is required"),
          // onSaved: (phone) {
          //   setState(() {
          //     phoneNumber = phone!;
          //   });
          // },
          // onSaved: (number) => phoneNumber = number!,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Already have an account? ",
              style: GoogleFonts.poppins(
                // fontFamily: 'Chillax',
                color: const Color(0xff201E1E).withOpacity(0.6),
                fontWeight: FontWeight.w500,
                fontSize: 9.sp,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()));
              },
              child: Text(
                "Sign in",
                style: GoogleFonts.poppins(
                  // fontFamily: 'Chillax',
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 9.sp,
                ),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ]),
    );
  }
}
