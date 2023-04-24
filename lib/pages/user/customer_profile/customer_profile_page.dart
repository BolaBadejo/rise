import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:rise/constants.dart';
import 'package:rise/data/model/logout/logout_response_model.dart';
import 'package:rise/data_artisan/dataproviders/api/api_provider.dart';
import 'package:rise/pages/auth/signin_screen.dart';
import 'package:rise/pages/user/customer_profile/kyc/user-kyc.dart';
import 'package:rise/pages/user/customer_profile/pickup_address.dart';
import 'package:rise/pages/user/home/account_type_selection.dart';
import 'package:rise/services/api_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:rise/data/model/login/login_response_model.dart';
import '../../../data/model/get_auth_user/get_auth_user_response_model.dart';
import '../../../widgets/custom_snack_bar.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  late TabController tabController;

  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController addressEditingController =
      TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordEditingController =
      TextEditingController();
  final TextEditingController tokenEditingController = TextEditingController();
  final TextEditingController pinEditingController = TextEditingController();
  final TextEditingController amountEditingController = TextEditingController();
  final TextEditingController withdrawPasswordEditingController =
      TextEditingController();

  void editBusiness(context, address, name) async {
    EasyLoading.show();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      Response response = await put(
          Uri.parse("https://admin.rise.ng/api/update-business-profile"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'business_name': name,
            'business_address': address
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

  void forgotPassword(context, email) async {
    EasyLoading.show();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/auth/forgot-password"),
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

  void withdraw(context, kycID, amount, pin, password) async {
    EasyLoading.show();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/auth/forgot-password"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'kyc_id': kycID,
            'amount': amount,
            'pin': pin,
            'password': password
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

  void withdrawalPin() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      Response response = await get(
          Uri.parse("https://admin.rise.ng/api/payment/withdrawal-pin"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $getToken'
          });
      var data = jsonDecode(response.body.toString());
      // print(data);

      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Sent',
            message: data['message'],
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        EasyLoading.dismiss();
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

  User userData = User(
    emailVerified: false,
    kycVerified: false,
    riseInsured: false,
    riseVerified: false,
  );
  List names = [];

  var dataUser;

  @override
  void initState() {
    // TODO: implement initState
    // getSavedData();
    getBusinessProfile();
    getStoredUserData();
    fetchUser();
    super.initState();
  }

  var user;
  String fullName = '';
  String email = '';
  String refToken = '';

  getStoredUserData() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    setState(() {
      fullName = sharedPreference.get('full_name').toString();
      email = sharedPreference.get('email').toString();
      refToken = sharedPreference.get('referral_token').toString();
    });
  }

  var businessDetails;

  Future<void> getBusinessProfile() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();

    try {
      final response = await get(
          Uri.parse('https://admin.rise.ng/api/user-update-profile'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });
      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print(data);
        setState(() {
          businessDetails = data['data'];
        });
      } else {
        // print('error ${response.statusCode.toString()}');
      }
    } catch (e) {
      // print(e.toString());

      EasyLoading.dismiss();
    }
  }

  Future<void> fetchUser() async {
    GetAuthUserResponse res = await APIHandler().fetchUserData();
    var userData = res.data;
    var name = userData.fullName!.split(' ');
    // print(userData.toJson());
    // print("Authentication data retrieved");

    setState(() {
      user = userData;
      names = name;
      // pendingBargain = res.data.newBooking;
    });
  }

  var fetchedUserData;

  void getSavedData() async {
    SharedPreferences _shared = await SharedPreferences.getInstance();
    Map<String, dynamic> jsonData = jsonDecode(_shared.getString("userData")!);
    setState(() {
      userData = User.fromJson(jsonData);
      names = userData.fullName!.split(' ');
    });
  }

  Future<void> logout(context, token) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    // print(getToken);
    LogOutResponse res = await ApiProvider().logOut('/logout', getToken);
    final responseBody = json.decode(res.toString());
    final logOutData = LogOutResponse.fromJson(responseBody);

    if (res.success) {
      EasyLoading.dismiss();
      SharedPreferences sharedPreference =
          await SharedPreferences.getInstance();
      sharedPreference.clear();
      showCustomSnackBar(context, res.message, Colors.green, Colors.white);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignInScreen()));
    } else {
      EasyLoading.dismiss();
      showCustomSnackBar(context, res.message, Colors.red, Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 20.h,
                decoration: const BoxDecoration(
                  color: blackColor,
                ),
              ),
              Positioned(
                left: 20,
                bottom: -40,
                child: ProfilePicture(
                  name: fullName,
                  radius: 40,
                  fontsize: 34,
                  // random: true,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text(
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    // fontFamily: 'Chillax',
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                ),
                user?.riseVerified == null
                    ? Container()
                    : user?.riseVerified == true
                        ? const Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Icon(
                              Icons.verified,
                              color: Colors.black,
                              size: 18,
                            ),
                          )
                        : Container(),
                user?.riseInsured == null
                    ? Container()
                    : user?.riseInsured == true
                        ? Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    width: 1.3,
                                    color: primaryColor,
                                  )),
                              child: Center(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.safety_check_outlined,
                                      color: secondaryColor,
                                      size: 11,
                                    ),
                                    Text(
                                      'insured',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        // fontFamily: 'Chillax',
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 7.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        : Container(),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: grayColor,
                fontWeight: FontWeight.w500,
                fontSize: 8.sp,
              ),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text(
                  refToken,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    // fontFamily: 'Chillax',
                    color: grayColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(
                              ClipboardData(text: userData.referralToken))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: blackColor,
                                content:
                                    Text("Referal code copied to clipboard")));
                      });
                      ;
                      // copied successfully
                    },
                    child: const Icon(
                      Icons.copy,
                      size: 13,
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Container(
                  width: 100.h,
                  height: 5.h,
                  child: TabBar(
                      unselectedLabelColor: primaryColor,
                      labelColor: whiteColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: primaryColor),
                      tabs: [
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: primaryColor, width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Account",
                                style: GoogleFonts.poppins(
                                  // fontFamily: 'Chillax',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: primaryColor, width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Payment",
                                style: GoogleFonts.poppins(
                                  // fontFamily: 'Chillax',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: primaryColor, width: 1)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Support",
                                style: GoogleFonts.poppins(
                                  // fontFamily: 'Chillax',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.h,
                  padding: const EdgeInsets.all(20),
                  child: TabBarView(children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          user?.userType == 'Default'
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Update Business Profile\n(Fill both boxes to update)',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          content: SizedBox(
                                            height: 24.h,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Business Name',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      nameEditingController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    hintText: businessDetails[
                                                            'business_name'] ??
                                                        "Enter your Business Name",
                                                    hintStyle:
                                                        GoogleFonts.poppins(
                                                      color: const Color(
                                                              0xffb5b5b5)
                                                          .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 9.sp,
                                                      // fontFamily: 'Chillax',
                                                    ),
                                                    fillColor: whiteColor,
                                                    filled: true,
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          width: 2,
                                                          color:
                                                              grayColor), //<-- SEE HERE
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 2,
                                                              color:
                                                                  primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
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
                                                Text(
                                                  'Biusiness address',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      addressEditingController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    hintText: businessDetails[
                                                            'business_address'] ??
                                                        "Enter your Business Address",
                                                    hintStyle:
                                                        GoogleFonts.poppins(
                                                      color: const Color(
                                                              0xffb5b5b5)
                                                          .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 9.sp,
                                                      // fontFamily: 'Chillax',
                                                    ),
                                                    fillColor: whiteColor,
                                                    filled: true,
                                                    isDense: true,
                                                    contentPadding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          width: 2,
                                                          color:
                                                              grayColor), //<-- SEE HERE
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              width: 2,
                                                              color:
                                                                  primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
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
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Update'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                editBusiness(
                                                    context,
                                                    addressEditingController
                                                        .text
                                                        .toString(),
                                                    nameEditingController.text
                                                        .toString());
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 7.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.h),
                                      color: grayColor.withOpacity(0.2),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                    Icons.manage_accounts,
                                                    size: 18),
                                              ),
                                              TextSpan(
                                                text: "  Edit Business Profile",
                                                // overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  // fontFamily: 'Chillax',
                                                  color: blackColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
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
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const WidgetSpan(
                                        child:
                                            Icon(Icons.notifications, size: 18),
                                      ),
                                      TextSpan(
                                        text: "  Notifications",
                                        // overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          // fontFamily: 'Chillax',
                                          color: blackColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
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
                                  return UserKYCHome(
                                    type: user?.userType,
                                  );
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
                                              Icon(Icons.analytics, size: 18),
                                        ),
                                        TextSpan(
                                          text: "  Bio Data / KYC",
                                          // overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            // fontFamily: 'Chillax',
                                            color: blackColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
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
                                  return PickUpAddressPage();
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
                                          child: Icon(Icons.location_city,
                                              size: 18),
                                        ),
                                        TextSpan(
                                          text: "  Set Pickup address",
                                          // overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            // fontFamily: 'Chillax',
                                            color: blackColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    content: SizedBox(
                                      height: 15.h,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'email',
                                            style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(
                                            controller: emailEditingController,
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
                                            validator: emailValidator,
                                            // onSaved: (email) => loginRequest!.email = email!,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Send'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          forgotPassword(
                                              context,
                                              emailEditingController.text
                                                  .toString());
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Reset Password\nEvery field is required',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                content: SizedBox(
                                                  height: 44.h,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'We have sent a token to ${emailEditingController.text.toString()}',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      Text(
                                                        'token',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            tokenEditingController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Enter your token",
                                                          hintStyle: GoogleFonts
                                                              .poppins(
                                                            color: const Color(
                                                                    0xffb5b5b5)
                                                                .withOpacity(
                                                                    0.5),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 9.sp,
                                                            // fontFamily: 'Chillax',
                                                          ),
                                                          fillColor: whiteColor,
                                                          filled: true,
                                                          isDense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color:
                                                                        grayColor), //<-- SEE HERE
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color:
                                                                        primaryColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                          ),
                                                          // If  you are using latest version of flutter then lable text and hint text shown like this
                                                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                                                        ),
                                                        // validator:
                                                        //     emailValidator,
                                                        // onSaved: (email) => loginRequest!.email = email!,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Password',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            passwordEditingController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        obscureText: true,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Enter your new password",
                                                          hintStyle: GoogleFonts
                                                              .poppins(
                                                            color: const Color(
                                                                    0xffb5b5b5)
                                                                .withOpacity(
                                                                    0.5),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 9.sp,
                                                            // fontFamily: 'Chillax',
                                                          ),
                                                          fillColor: whiteColor,
                                                          filled: true,
                                                          isDense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color:
                                                                        grayColor), //<-- SEE HERE
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color:
                                                                        primaryColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
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
                                                      Text(
                                                        'Confirm Password',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            confirmPasswordEditingController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        obscureText: true,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "Confirm your new password",
                                                          hintStyle: GoogleFonts
                                                              .poppins(
                                                            color: const Color(
                                                                    0xffb5b5b5)
                                                                .withOpacity(
                                                                    0.5),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 9.sp,
                                                            // fontFamily: 'Chillax',
                                                          ),
                                                          fillColor: whiteColor,
                                                          filled: true,
                                                          isDense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color:
                                                                        grayColor), //<-- SEE HERE
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color:
                                                                        primaryColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
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
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Reset'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      resetPassword(
                                                          context,
                                                          emailEditingController
                                                              .text
                                                              .toString(),
                                                          passwordEditingController
                                                              .text
                                                              .toString(),
                                                          confirmPasswordEditingController
                                                              .text
                                                              .toString(),
                                                          tokenEditingController
                                                              .text
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
                                              Icon(Icons.lock_open, size: 18),
                                        ),
                                        TextSpan(
                                          text: "  Change Password",
                                          // overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            // fontFamily: 'Chillax',
                                            color: blackColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
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
                            onTap: () async {
                              SharedPreferences sharedPreference =
                                  await SharedPreferences.getInstance();
                              sharedPreference.clear();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const SignInScreen();
                              }));
                            },
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
                                          child: Icon(
                                              Icons.switch_access_shortcut,
                                              size: 18),
                                        ),
                                        TextSpan(
                                          text: "  Log Out",
                                          // overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            // fontFamily: 'Chillax',
                                            color: blackColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
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
                          // GestureDetector(
                          //   // onTap: () => Navigator.pushAndRemoveUntil(
                          //   //     context,
                          //   //     MaterialPageRoute(
                          //   //         builder: (context) => const AccountTypeSelection()),
                          //   //     (route) => false),
                          //   child: Container(
                          //     height: 7.h,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(6.h),
                          //       color: grayColor.withOpacity(0.2),
                          //     ),
                          //     child: Align(
                          //       alignment: Alignment.centerLeft,
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(left: 20.0),
                          //         child: RichText(
                          //           text: TextSpan(
                          //             children: [
                          //               const WidgetSpan(
                          //                 child: Icon(
                          //                     Icons.switch_access_shortcut,
                          //                     size: 18),
                          //               ),
                          //               TextSpan(
                          //                 text: "  Switch Role",
                          //                 // overflow: TextOverflow.ellipsis,
                          //                 style: GoogleFonts.poppins(
                          //                   // fontFamily: 'Chillax',
                          //                   color: blackColor,
                          //                   fontWeight: FontWeight.w500,
                          //                   fontSize: 14.sp,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    //Payment

                    Column(
                      children: [
                        Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Column(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "N",
                                              // overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                // fontFamily: 'Chillax',
                                                color: blackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${user?.wallet?.balance.toString()}.00',
                                              // '${user?.wallet?.balance.toString()}.00',
                                              // overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                // fontFamily: 'Chillax',
                                                color: blackColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 24.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text("wallet balance",
                                          style: GoogleFonts.poppins(
                                            // fontFamily: 'Chillax',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 8.sp,
                                          )),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: grayColor,
                                        )),
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "ledger balance:",
                                                // overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  // fontFamily: 'Chillax',
                                                  color: grayColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 8.sp,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${user?.wallet?.ledgerBalance.toString()}.00',
                                                // '${user?.wallet?.balance.toString()}.00',
                                                // overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  // fontFamily: 'Chillax',
                                                  color: grayColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 9.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Bank Details',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  content: SizedBox(
                                    height: 50.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Account Number',
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 7.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6.h),
                                            color: grayColor.withOpacity(0.2),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                "${user?.wallet?.accountNumber.toString()}",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  // fontFamily: 'Chillax',
                                                  color: blackColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Account Balance',
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 7.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6.h),
                                            color: grayColor.withOpacity(0.2),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                "N${user?.wallet?.balance.toString()}.00",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  // fontFamily: 'Chillax',
                                                  color: blackColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Ledger Balance',
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 7.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6.h),
                                            color: grayColor.withOpacity(0.2),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                "N${user?.wallet?.ledgerBalance.toString()}.00",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  // fontFamily: 'Chillax',
                                                  color: blackColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        // Text(
                                        //   'Failed Withdrawal Attempt',
                                        //   style: GoogleFonts.poppins(
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.w600),
                                        // ),
                                        // const SizedBox(
                                        //   height: 5,
                                        // ),
                                        // Container(
                                        //   height: 7.h,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius:
                                        //         BorderRadius.circular(6.h),
                                        //     color: grayColor.withOpacity(0.2),
                                        //   ),
                                        //   child: Align(
                                        //     alignment: Alignment.centerLeft,
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.only(
                                        //           left: 20.0),
                                        //       child: Text(
                                        //         "${user?.wallet?.failedWithdrawalAttempt.toString()}",
                                        //         overflow: TextOverflow.ellipsis,
                                        //         style: GoogleFonts.poppins(
                                        //           // fontFamily: 'Chillax',
                                        //           color: blackColor,
                                        //           fontWeight: FontWeight.w500,
                                        //           fontSize: 16.sp,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Account Status',
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 7.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6.h),
                                            color: grayColor.withOpacity(0.2),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                "${user?.wallet?.status.toString()}",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  // fontFamily: 'Chillax',
                                                  color: blackColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    // TextButton(
                                    //   child: Text('Update'),
                                    //   onPressed: () {
                                    //     Navigator.pop(context);
                                    //     editBusiness(
                                    //         context,
                                    //         addressEditingController.text
                                    //             .toString(),
                                    //         nameEditingController.text
                                    //             .toString());
                                    //   },
                                    // ),
                                  ],
                                );
                              },
                            );
                          },
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
                                        child: Icon(Icons.account_balance,
                                            size: 18),
                                      ),
                                      TextSpan(
                                        text: "  Manage Bank Details",
                                        // overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          // fontFamily: 'Chillax',
                                          color: blackColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
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
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Get withdrawal pin',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  content: Text(
                                    'Press \'get pin\' to generate your one time withdrawal pin. We will send your pin to your email.',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: grayColor),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Get pin'),
                                      onPressed: () {
                                        // Navigator.pop(context);
                                        withdrawalPin();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Reset Password\nEvery field is required',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              content: SizedBox(
                                                height: 44.h,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'We have sent your one-time withdrawal pin to ${user?.email.toString()}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Text(
                                                      'amount',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          amountEditingController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "amount",
                                                        hintStyle:
                                                            GoogleFonts.poppins(
                                                          color: const Color(
                                                                  0xffb5b5b5)
                                                              .withOpacity(0.5),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 9.sp,
                                                          // fontFamily: 'Chillax',
                                                        ),
                                                        fillColor: whiteColor,
                                                        filled: true,
                                                        isDense: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  color:
                                                                      grayColor), //<-- SEE HERE
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  color:
                                                                      primaryColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                        ),
                                                        // If  you are using latest version of flutter then lable text and hint text shown like this
                                                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                                                      ),
                                                      // validator:
                                                      //     emailValidator,
                                                      // onSaved: (email) => loginRequest!.email = email!,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'pin',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          pinEditingController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      obscureText: true,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "pin",
                                                        hintStyle:
                                                            GoogleFonts.poppins(
                                                          color: const Color(
                                                                  0xffb5b5b5)
                                                              .withOpacity(0.5),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 9.sp,
                                                          // fontFamily: 'Chillax',
                                                        ),
                                                        fillColor: whiteColor,
                                                        filled: true,
                                                        isDense: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  color:
                                                                      grayColor), //<-- SEE HERE
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  color:
                                                                      primaryColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
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
                                                    Text(
                                                      'Password',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          withdrawPasswordEditingController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      obscureText: true,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "enter your rise password",
                                                        hintStyle:
                                                            GoogleFonts.poppins(
                                                          color: const Color(
                                                                  0xffb5b5b5)
                                                              .withOpacity(0.5),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 9.sp,
                                                          // fontFamily: 'Chillax',
                                                        ),
                                                        fillColor: whiteColor,
                                                        filled: true,
                                                        isDense: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  color:
                                                                      grayColor), //<-- SEE HERE
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  color:
                                                                      primaryColor),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
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
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Cashout'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    withdraw(
                                                        context,
                                                        user?.kycId.toString(),
                                                        amountEditingController
                                                            .text
                                                            .toString(),
                                                        pinEditingController
                                                            .text
                                                            .toString(),
                                                        passwordEditingController
                                                            .text
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
                                            Icon(Icons.attach_money, size: 18),
                                      ),
                                      TextSpan(
                                        text: "  Wallet Cashout",
                                        // overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          // fontFamily: 'Chillax',
                                          color: blackColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
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
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const WidgetSpan(
                                      child: Icon(Icons.confirmation_number,
                                          size: 18),
                                    ),
                                    TextSpan(
                                      text: "  Send Invoice / Reciept",
                                      // overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        // fontFamily: 'Chillax',
                                        color: blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Service Center',
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'A word of Yoruba origin that means; \'to find work\'\n\n Rise is a platform created to bridge the gap between vendors, artisans, service providers, and MSMEs and their end-users, clients or customers.\n\n For more information or to lodge a complain:',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: grayColor),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              // print('send mail');
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Mail info@rise.ng  ",
                                    // overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  const WidgetSpan(
                                    child: Icon(Icons.email_outlined, size: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              // print('send mail');
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Call +234 908 8453 705  ",
                                    // overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  const WidgetSpan(
                                    child: Icon(Icons.phone, size: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              // print('send mail');
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Visit https://rise.ng  ",
                                    // overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  const WidgetSpan(
                                    child: Icon(Icons.send_rounded, size: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ]),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
