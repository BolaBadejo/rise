import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:rise/accountverifictionscreen.dart';
import 'package:rise/business_logic/get_auth_user/get_auth_user_bloc.dart';
import 'package:rise/constants.dart';
import 'package:rise/widgets/custom_snack_bar.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

import '../../auth/verify_email.dart';

class AccountTypeSelection extends StatefulWidget {
  final String phoneNumber;
  final String fullName;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? ref;
  const AccountTypeSelection(
      {Key? key,
      required this.phoneNumber,
      required this.fullName,
      required this.email,
      required this.password,
      required this.passwordConfirmation,
      this.ref})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AccountTypeSelectionState();
  }
}

class AccountTypeSelectionState extends State<AccountTypeSelection> {
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;

  Future<void> _refresh() async {
    // When all needed is done change state.
    BlocProvider.of<GetAuthUserBloc>(context).add(RefreshGetAuthUserEvent());
    _controller.sink.add(SwipeRefreshState.hidden);
  }

  void register(context, fullName, phoneNumber, email, userType, password,
      passwordConfirmation, ref) async {
    var number = "234${phoneNumber!.substring(1)}";
    Response response;
    EasyLoading.show();
    // print(
    // "$fullName - $number - $password - $passwordConfirmation - $email - $userType");
    try {
      if (ref == null) {
        response = await post(
            Uri.parse("https://admin.rise.ng/api/auth/register"),
            body: {
              'full_name': fullName,
              'phone_number': number,
              'user_type': userType,
              'email': email,
              'password': password,
              'password_confirmation': passwordConfirmation
            });
      } else {
        response = await post(
            Uri.parse("https://admin.rise.ng/api/auth/register"),
            body: {
              'full_name': fullName,
              'phone_number': number,
              'user_type': userType,
              'email': email,
              'password': password,
              'password_confirmation': passwordConfirmation,
              'ref': ref
            });
      }

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Registration Successful',
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
            builder: (context) => const AccountVerificationScreen(),
          ),
        );
        // print(data['message']);
        // print("done successfully");
      } else {
        // print('error ${response.statusCode.toString()}');
        var data = jsonDecode(response.body.toString());
        EasyLoading.dismiss();
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error',
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
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SwipeRefresh.adaptive(
          stateStream: _stream,
          onRefresh: _refresh,
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        "One last thing, Which option best describes you and your needs on Rísé.",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          // fontFamily: 'Chillax',
                          color: primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  const SizedBox(height: defaultPadding),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: RiseButtonNew(
                        text: Text(
                          "Customer",
                          style: TextStyle(
                            // fontFamily: 'Chillax',
                            color: whiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                        ),
                        buttonColor: primaryColor,
                        textColor: whiteColor,
                        onPressed: () {
                          register(
                              context,
                              widget.fullName,
                              widget.phoneNumber,
                              widget.email,
                              "Default",
                              widget.password,
                              widget.passwordConfirmation,
                              widget.ref);
                        }),
                  ),
                  const SizedBox(height: defaultPadding),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: RiseButtonNew(
                        text: Text(
                          "Vendor",
                          style: TextStyle(
                            // fontFamily: 'Chillax',
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                        ),
                        buttonColor: secondaryColor,
                        textColor: whiteColor,
                        onPressed: () {
                          register(
                              context,
                              widget.fullName,
                              widget.phoneNumber,
                              widget.email,
                              "Vendor",
                              widget.password,
                              widget.passwordConfirmation,
                              widget.ref);
                        }),
                  ),
                  const SizedBox(height: defaultPadding),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: RiseButtonNew(
                        text: Text(
                          "Artisan",
                          style: TextStyle(
                            // fontFamily: 'Chillax',
                            color: whiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                        ),
                        buttonColor: blackColor,
                        textColor: whiteColor,
                        onPressed: () {
                          register(
                              context,
                              widget.fullName,
                              widget.phoneNumber,
                              widget.email,
                              "Artisan",
                              widget.password,
                              widget.passwordConfirmation,
                              widget.ref);
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
