import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rise/constants.dart';
import 'package:rise/utils/shared_preferences.dart';
import 'package:rise/data/model/login/login_response_model.dart';
import 'package:rise/widgets/custom_snack_bar.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class BusinessKYC extends StatefulWidget {
  final type;
  const BusinessKYC({Key? key, required this.type}) : super(key: key);

  @override
  BusinessKYCState createState() => BusinessKYCState();
}

class BusinessKYCState extends State<BusinessKYC> {
  var selectedListing;
  static final _formKey = GlobalKey<FormState>();
  TextEditingController addressEditingController = TextEditingController();

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

  // void getSavedData() async {
  //   SharedPreferences _shared = await SharedPreferences.getInstance();
  //   Map<String, dynamic> jsonData = jsonDecode(_shared.getString("userData")!);
  // }

  String dropdownvalue = 'no';
  String regiValue = 'no';
  String uniValue = 'no';

  static final TextEditingController ninEditingController =
      TextEditingController();

  void business(context, address) async {
    EasyLoading.show();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    bool reg;
    bool snap;
    bool uni;
    if (regiValue == 'no')
      reg = false;
    else
      reg = true;
    if (dropdownvalue == 'no')
      snap = false;
    else
      snap = true;
    if (uniValue == 'no')
      uni = false;
    else
      uni = true;
    try {
      Response response = await post(
          Uri.parse("https://test.rise.ng/api/kyc/save-business-verification"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $getToken'
          },
          body: {
            'is_business_registered': regiValue,
            'belong_to_union': uniValue,
            'has_physical_store': dropdownvalue,
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
            title: 'Verified',
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

  void addressSnapshot(context, image) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      final request = http.MultipartRequest('POST',
          Uri.parse('https://test.rise.ng/api/kyc/upload-address-snapshot'));
      request.headers.addAll(
          {"Accept": "application/json", 'Authorization': 'Bearer $getToken'});
      request.files
          .add(await http.MultipartFile.fromPath("address_snapshot", image));
      var sendRequestResponse = await request.send();
      var responseBody = await http.Response.fromStream(sendRequestResponse);

      var data = jsonDecode(responseBody.body.toString());

      if (responseBody.statusCode == 200) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Verified',
            message: data['message'],
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        setState(() {
          hasImage = false;
        });
        // print("done successfully");
      } else {
        // print('error ${responseBody.statusCode.toString()}');
        EasyLoading.dismiss();
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error ${responseBody.statusCode.toString()}',
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

  // void uploadSnapshot(BuildContext ctx, File image) {
  //   showModalBottomSheet(
  //       context: ctx,
  //       shape: const RoundedRectangleBorder(
  //           // <-- SEE HERE
  //           borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(30.0),
  //       )),
  //       builder: (context) {
  //         return SizedBox(
  //           height: MediaQuery.of(context).size.height / 1.2,
  //           child: Padding(
  //             padding:
  //                 const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Text(
  //                   "Upload business snapshot",
  //                   overflow: TextOverflow.ellipsis,
  //                   style: GoogleFonts.poppins(
  //                     // fontFamily: 'Chillax',
  //                     color: blackColor,
  //                     fontWeight: FontWeight.w500,
  //                     fontSize: 14.sp,
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 Center(
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(30.0),
  //                     child: Image.file(
  //                       image,
  //                       fit: BoxFit.cover,
  //                       height: 40.h,
  //                       width: 100.w,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 40),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //                   child: RiseButtonNew(
  //                       text: RichText(
  //                         text: TextSpan(
  //                           children: [
  //                             TextSpan(
  //                               text: "Upload  ",
  //                               // overflow: TextOverflow.ellipsis,
  //                               style: GoogleFonts.poppins(
  //                                 // fontFamily: 'Chillax',
  //                                 color: whiteColor,
  //                                 fontWeight: FontWeight.w600,
  //                                 fontSize: 14.sp,
  //                               ),
  //                             ),
  //                             const WidgetSpan(
  //                               child: Icon(
  //                                 Icons.upload,
  //                                 size: 22,
  //                                 color: greenColor,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       buttonColor: blackColor,
  //                       textColor: whiteColor,
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                         addressSnapshot(context, image.path);
  //                       }),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  bool hasImage = false;

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
                              //const TextFieldName(text: "Email Address"),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: addressEditingController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                const Icon(Icons.numbers),
                                            hintText:
                                                "Enter your Business Address",
                                            hintStyle: GoogleFonts.poppins(
                                              color: const Color(0xffb5b5b5)
                                                  .withOpacity(0.5),
                                              fontWeight: FontWeight.w600,
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
                                      ),
                                      if (dropdownvalue == 'no')
                                        Container()
                                      else
                                        MaterialButton(
                                          onPressed: () => pickImages(),
                                          color: Colors.black,
                                          textColor: Colors.white,
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 24,
                                          ),
                                          padding: EdgeInsets.all(8),
                                          shape: CircleBorder(),
                                        )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Do you have a physical store? ",
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: const Color(0xff201E1E)
                                          .withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            value: "no",
                                            groupValue: dropdownvalue,
                                            onChanged: (value) {
                                              setState(() {
                                                hasImage = false;
                                                dropdownvalue =
                                                    value.toString();
                                              });
                                            },
                                          ),
                                          Text(
                                            "No ",
                                            style: GoogleFonts.poppins(
                                              // fontFamily: 'Chillax',
                                              color: const Color(0xff201E1E)
                                                  .withOpacity(0.6),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            // title: Text("Yes"),
                                            value: "yes",
                                            groupValue: dropdownvalue,
                                            onChanged: (value) {
                                              setState(() {
                                                hasImage = true;
                                                dropdownvalue =
                                                    value.toString();
                                              });
                                            },
                                          ),
                                          Text(
                                            "Yes",
                                            style: GoogleFonts.poppins(
                                              // fontFamily: 'Chillax',
                                              color: const Color(0xff201E1E)
                                                  .withOpacity(0.6),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (dropdownvalue == 'no')
                                    Container()
                                  else
                                    SizedBox(
                                      height: 20,
                                    ),
                                  if (dropdownvalue == 'no')
                                    Container()
                                  else
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        "Please press the camera icon above and take a snap shot of your store front.",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          // fontFamily: 'Chillax',
                                          color: const Color(0xff201E1E)
                                              .withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  if (dropdownvalue == 'no')
                                    Container()
                                  else
                                    SizedBox(
                                      height: 20,
                                    ),
                                  if (dropdownvalue == 'no')
                                    Container()
                                  else
                                    compressedImages.isNotEmpty
                                        ? Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              child: Image.file(
                                                compressedImages[0],
                                                fit: BoxFit.cover,
                                                height: 40.h,
                                                width: 100.w,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 40.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.grey
                                                    .withOpacity(0.1)),
                                            padding: EdgeInsets.all(10.0),
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Icon(Icons.photo,
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    size: 48.0))),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Is your business registered? ",
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: const Color(0xff201E1E)
                                          .withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            value: "no",
                                            groupValue: regiValue,
                                            onChanged: (value) {
                                              setState(() {
                                                regiValue = value.toString();
                                              });
                                            },
                                          ),
                                          Text(
                                            "No ",
                                            style: GoogleFonts.poppins(
                                              // fontFamily: 'Chillax',
                                              color: const Color(0xff201E1E)
                                                  .withOpacity(0.6),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            // title: Text("Yes"),
                                            value: "yes",
                                            groupValue: regiValue,
                                            onChanged: (value) {
                                              setState(() {
                                                regiValue = value.toString();
                                              });
                                            },
                                          ),
                                          Text(
                                            "Yes",
                                            style: GoogleFonts.poppins(
                                              // fontFamily: 'Chillax',
                                              color: const Color(0xff201E1E)
                                                  .withOpacity(0.6),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Is your business registered to a union? ",
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: const Color(0xff201E1E)
                                          .withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            value: "no",
                                            groupValue: uniValue,
                                            onChanged: (value) {
                                              setState(() {
                                                uniValue = value.toString();
                                              });
                                            },
                                          ),
                                          Text(
                                            "No ",
                                            style: GoogleFonts.poppins(
                                              // fontFamily: 'Chillax',
                                              color: const Color(0xff201E1E)
                                                  .withOpacity(0.6),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            // title: Text("Yes"),
                                            value: "yes",
                                            groupValue: uniValue,
                                            onChanged: (value) {
                                              setState(() {
                                                uniValue = value.toString();
                                              });
                                            },
                                          ),
                                          Text(
                                            "Yes",
                                            style: GoogleFonts.poppins(
                                              // fontFamily: 'Chillax',
                                              color: const Color(0xff201E1E)
                                                  .withOpacity(0.6),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding * 10.0),

                              // const SizedBox(height: 30.0 * 2.0),
                              hasImage
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: RiseButtonNew(
                                          text: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Upload  ",
                                                  // overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    // fontFamily: 'Chillax',
                                                    color: whiteColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: Icon(
                                                    Icons.upload,
                                                    size: 22,
                                                    color: greenColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          buttonColor: blackColor,
                                          textColor: whiteColor,
                                          onPressed: () {
                                            addressSnapshot(context,
                                                compressedImages[0].path);
                                          }),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: RiseButton(
                                        text: "Proceed",
                                        buttonColor: blackColor,
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                          }
                                          business(
                                              context,
                                              addressEditingController.text
                                                  .toString());
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

  List<Asset> images = <Asset>[];

  List files = [];

  List<String> selectedImages = [];
  List<String> temporaryImages = [];
  List<File> compressedImages = [];

  pickImages() async {
    try {
      final pickedImage = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);
      if (pickedImage != null && pickedImage.files.isNotEmpty) {
        setState(() {});
        final image = pickedImage.files.map((e) => e.path!);
        selectedImages.addAll(image);
        temporaryImages.addAll(image);

        compressImage(temporaryImages[0]);

        Future.delayed(
            const Duration(seconds: 1), () => temporaryImages.clear());
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  compressImage(path) async {
    if (selectedImages.isEmpty) return;
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(path.toString());
    await FlutterNativeImage.compressImage(path,
            quality: 20,
            targetWidth: 600,
            targetHeight:
                (properties.height! * 600 / (properties.width)!).round())
        .then((response) => setState(() => compressedImages.add(response)))
        .catchError((e) => debugPrint(e));
  }
}
