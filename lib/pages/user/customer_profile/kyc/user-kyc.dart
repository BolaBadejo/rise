import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/user/customer_profile/kyc/bank_kyc/bank_kyc.dart';
import 'package:rise/pages/user/customer_profile/kyc/products/insured.dart';
import 'package:rise/pages/user/customer_profile/kyc/products/verified.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'bio_data_kyc/bio_data_kyc.dart';
import 'business_kyc/business_kyc.dart';

class UserKYCHome extends StatefulWidget {
  final type;
  const UserKYCHome({super.key, required this.type});

  @override
  State<UserKYCHome> createState() => _UserKYCHomeState();
}

class _UserKYCHomeState extends State<UserKYCHome> {
  final TextEditingController ninNumber = TextEditingController();

  var progressData;
  bool userdone = false;
  bool businessDone = false;
  bool bankDone = false;
  int done = 0;

  Future<void> fetchKYCProgress() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    EasyLoading.show();

    try {
      final response = await get(
          Uri.parse('https://admin.rise.ng/api/kyc/progress'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print(data);
        // print("KYC progress fetched");
        setState(() {
          done = 0;
          progressData = data['data'];
          userdone = data['data']['personal_info'];
          businessDone = data['data']['business_verification'];
          bankDone = data['data']['bank_info'];
        });
      } else {}
    } catch (e) {
      // print(e.toString());
    }
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchKYCProgress();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _refresh() async {
    fetchKYCProgress();
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 30), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {});
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.type);
    if (userdone == true) done++;
    if (businessDone == true) done++;
    if (bankDone == true) done++;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: LiquidPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        showChildOpacityTransition: false,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Rísé KYC ",
                    style: GoogleFonts.poppins(
                      // fontFamily: 'Chillax',
                      color: const Color(0xff201E1E).withOpacity(0.6),
                      fontWeight: FontWeight.w800,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: (() {
                    if (progressData['personal_info'] != null) {
                      if (progressData['personal_info']) {
                        final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Hey there!',
                            message: 'You have Personal Info KYC.',
                            contentType: ContentType.help,
                          ),
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BioDataKYC(
                            type: widget.type,
                          );
                        }));
                      }
                    }
                  }),
                  child: Container(
                    height: 7.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.h),
                      color: grayColor.withOpacity(0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const WidgetSpan(
                                    child: Icon(Icons.person, size: 18),
                                  ),
                                  TextSpan(
                                    text: "  User KYC",
                                    // overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        userdone
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Icon(
                                    Icons.done,
                                    size: 24,
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                widget.type != 'Default'
                    ? const SizedBox(
                        height: 20,
                      )
                    : Container(),
                widget.type != 'Default'
                    ? GestureDetector(
                        onTap: (() {
                          if (progressData['business_verification'] != null) {
                            if (progressData['business_verification']) {
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Hey there!',
                                  message:
                                      'You have completed your Business KYC.',
                                  contentType: ContentType.help,
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BusinessKYC(
                                  type: widget.type,
                                );
                              }));
                            }
                          }
                        }),
                        child: Container(
                          height: 7.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.h),
                            color: grayColor.withOpacity(0.2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Icon(Icons.business, size: 18),
                                        ),
                                        TextSpan(
                                          text: "  Business KYC",
                                          // overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            // fontFamily: 'Chillax',
                                            color: blackColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              businessDone
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20.0),
                                        child: Icon(
                                          Icons.done,
                                          size: 24,
                                          color: Colors.green,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                widget.type != 'Default'
                    ? const SizedBox(
                        height: 20,
                      )
                    : Container(),
                widget.type != 'Default'
                    ? GestureDetector(
                        onTap: (() {
                          if (progressData['bank_info'] != null) {
                            if (progressData['bank_info']) {
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Hey there!',
                                  message: 'You have completed your Bank KYC.',
                                  contentType: ContentType.help,
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BankDataKYC(
                                  type: widget.type,
                                );
                              }));
                            }
                          }
                          // Navigator.push(context, MaterialPageRoute(builder: (context) {
                          //   return BankDataKYC();
                          // }));
                        }),
                        child: Container(
                          height: 7.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.h),
                            color: grayColor.withOpacity(0.2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Icon(Icons.monetization_on,
                                              size: 18),
                                        ),
                                        TextSpan(
                                          text: "  Bank KYC",
                                          // overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            // fontFamily: 'Chillax',
                                            color: blackColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              bankDone
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20.0),
                                        child: Icon(
                                          Icons.done,
                                          size: 24,
                                          color: Colors.green,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                widget.type != 'Default'
                    ? Text(
                        '$done of 3 complete',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          // fontFamily: 'Chillax',
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      )
                    : Text(
                        '$done of 1 complete',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          // fontFamily: 'Chillax',
                          color: secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      ),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.type != 'Default'
                    ? Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Rísé Products ",
                              style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: const Color(0xff201E1E).withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: (() => Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const VerifiedPage();
                                }))),
                            child: Container(
                              height: 7.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.h),
                                color: grayColor.withOpacity(0.2),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Icon(Icons.person, size: 18),
                                        ),
                                        TextSpan(
                                          text: "  Rise Verified",
                                          // overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            // fontFamily: 'Chillax',
                                            color: blackColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: (() => Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return InsurePage();
                                }))),
                            child: Container(
                              height: 7.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.h),
                                color: grayColor.withOpacity(0.2),
                              ),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child:
                                                Icon(Icons.business, size: 18),
                                          ),
                                          TextSpan(
                                            text: "  Rise Insured",
                                            // overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              // fontFamily: 'Chillax',
                                              color: blackColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
