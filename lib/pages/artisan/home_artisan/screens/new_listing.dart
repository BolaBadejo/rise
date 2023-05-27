import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rise/constants.dart';

import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class NewListing extends StatefulWidget {
  const NewListing({Key? key}) : super(key: key);

  @override
  NewListingState createState() => NewListingState();
}

class NewListingState extends State<NewListing> {
  var selectedListing;
  static final _formKey = GlobalKey<FormState>();

  bool checked = false;

  bool switchStatus = false;

  bool _isHidden = true;
  bool _isHiddenConfirmPassword = true;

  static final TextEditingController titleEditingController =
      TextEditingController();
  static final TextEditingController minOfferEditingController =
      TextEditingController();
  static final TextEditingController descriptionEditingController =
      TextEditingController();
  static final TextEditingController tagsEditingController =
      TextEditingController();

  static TextEditingController addressEditingController =
      TextEditingController();
  String category = 'choose listings category';
  List<String> accountTypeList = [
    "Vendor",
    "Artisan",
  ];
  List<Asset> images = <Asset>[];

  List files = [];

  List<String> selectedImages = [];
  List<String> temporaryImages = [];
  List<File> compressedImages = [];

  pickImages() async {
    try {
      final pickedImages = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);
      if (pickedImages != null && pickedImages.files.isNotEmpty) {
        setState(() {});
        final image = pickedImages.files.map((e) => e.path!);
        selectedImages.addAll(image);
        temporaryImages.addAll(image);

        for (int i = 0; i < temporaryImages.length; i++) {
          compressImage(temporaryImages[i]);
        }

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
            quality: 10,
            targetWidth: 600,
            targetHeight:
                (properties.height! * 600 / (properties.width)!).round())
        .then((response) => setState(() => compressedImages.add(response)))
        .catchError((e) => debugPrint(e));
  }

  List<Asset> resultList = [];
  Widget buildGridView() {
    if (images.isNotEmpty) {
      return GridView.count(
          crossAxisCount: 3,
          children: List.generate(compressedImages.length, (index) {
            Asset asset = images[index];
            // print(asset.getByteData(quality: 1));
            return Padding(
              padding: EdgeInsets.all(20),
              child: ClipRect(
                  child: AssetThumb(
                asset: asset,
                height: 100,
                width: 100,
              )),
            );
          }));
    } else {
      return Container();
    }
  }

  void newListing(context, category, serviceOffering, serviceTitle, description,
      tags, compressedImages, minimumServiceOffer) async {
    List tags2 = tags.split(",");
    // print(tags2);
    // print(compressedImages);
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('https://admin.rise.ng/api/listing/new'));

      List tagList = List.from(tags2, growable: false);
      List imageList = List.from(compressedImages, growable: false);

      request.headers.addAll({
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'Bearer $getToken'
      });
      var multipartImageFile;
      for (int i = 0; i < imageList.length; i++) {
        File imageFile = File(imageList[i].toString());
        String filePath = imageFile.path;
        //request.files.add(await http.MultipartFile.fromPath("images[$i]",filePath));
        multipartImageFile = http.MultipartFile(
            'images[$i]',
            File(imageList[i].path).readAsBytes().asStream(),
            File(imageList[i].path).lengthSync(),
            filename: basename(imageList[i].path));
        request.files.add(multipartImageFile);
      }
      for (int i = 0; i < tagList.length; i++) {
        request.fields["tags[$i]"] = tagList[i].toString();
      }
      request.fields['category'] = category;
      request.fields['service_offering'] = serviceOffering;
      request.fields['service_title'] = serviceTitle;
      request.fields['description'] = description;
      request.fields['minimum_service_offer'] = minimumServiceOffer;
      var sendRequestResponse = await request.send();
      var responseBody = await http.Response.fromStream(sendRequestResponse);
      var data = jsonDecode(responseBody.body.toString());
      // print(data);

      if (responseBody.statusCode == 200) {
        // await Preferences.saveUserData(data['data']['user']);
        // showCustomSnackBar(
        //     context, data['message'], Colors.green, Colors.white);
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Listing created',
            message: data['message'].toString(),

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        EasyLoading.dismiss();

        Navigator.pop(context);

        // print(data['message']);
        // print("done successfully");
      } else {
        // print('error ${responseBody.statusCode.toString()}');
        // print(data['message']);
        EasyLoading.dismiss();
        // context.showToastySnackbar('error ${response.statusCode.toString()}',
        //     'message', AlertType.error);
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error ${responseBody.statusCode.toString()}',
            message: data['message'].toString(),

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
      // showCustomSnackBar(context, e.toString(), Colors.red, Colors.white);
      // context.showToastySnackbar(e.toString(), 'message', AlertType.danger);
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
        // SizedBox(
        //   width: MediaQuery.of(context).size.width,
        //   child: Image.asset("assets/images/bg.png",fit: BoxFit.fill,),
        // ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16.0),
                              //const TextFieldName(text: "Email Address"),
                              Text(
                                "Listing title",
                                style: GoogleFonts.poppins(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: titleEditingController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  // prefixIcon: const Icon(Icons.mail),
                                  // hintText: "Email Address",
                                  // hintStyle: GoogleFonts.poppins(
                                  //   color: const Color(0xffb5b5b5)
                                  //       .withOpacity(0.5),
                                  //   fontWeight: FontWeight.w500,
                                  //   fontSize: 12.sp,
                                  //   // fontFamily: 'Chillax',
                                  // ),
                                  fillColor: whiteColor,
                                  filled: true,
                                  isDense: true,
                                  hintText: "enter a title",
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xffb5b5b5)
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    // fontFamily: 'Chillax',
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 18.0),
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
                                // validator: emailValidator,
                                // onSaved: (email) => loginRequest!.email = email!,
                              ),
                              const SizedBox(height: 20.0),

                              Text(
                                "Minimum price",
                                style: GoogleFonts.poppins(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: minOfferEditingController,
                                keyboardType: TextInputType.emailAddress,

                                decoration: InputDecoration(
                                  // prefixIcon: const Text("N"),
                                  // hintText: "Email Address",
                                  // hintStyle: GoogleFonts.poppins(
                                  //   color: const Color(0xffb5b5b5)
                                  //       .withOpacity(0.5),
                                  //   fontWeight: FontWeight.w500,
                                  //   fontSize: 12.sp,
                                  //   // fontFamily: 'Chillax',
                                  // ),
                                  fillColor: whiteColor,
                                  hintText: "what is your least charge?",
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xffb5b5b5)
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    // fontFamily: 'Chillax',
                                  ),
                                  filled: true,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 18.0),
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
                                // validator: emailValidator,
                                // onSaved: (email) => loginRequest!.email = email!,
                              ),
                              const SizedBox(height: 20.0),

                              Text(
                                "Description",
                                style: GoogleFonts.poppins(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                maxLines: 5,
                                controller: descriptionEditingController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  // prefixIcon: const Icon(Icons.mail),
                                  // hintText: "Email Address",
                                  // hintStyle: GoogleFonts.poppins(
                                  //   color: const Color(0xffb5b5b5)
                                  //       .withOpacity(0.5),
                                  //   fontWeight: FontWeight.w500,
                                  //   fontSize: 12.sp,
                                  //   // fontFamily: 'Chillax',
                                  // ),
                                  hintText:
                                      "write a brief description about your listing",
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xffb5b5b5)
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    // fontFamily: 'Chillax',
                                  ),
                                  fillColor: whiteColor,
                                  filled: true,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 18.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        color: grayColor), //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: primaryColor),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  // If  you are using latest version of flutter then lable text and hint text shown like this
                                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                                ),
                                // validator: emailValidator,
                                // onSaved: (email) => loginRequest!.email = email!,
                              ),
                              const SizedBox(height: 20.0),

                              Text(
                                "Tags",
                                style: GoogleFonts.poppins(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),

                              Text(
                                "use as many as four(4) tags and separate them with commas\n example. sell, products, on, rise",
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: grayColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 8.sp,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: tagsEditingController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.tag),
                                  hintText: "xxxx, xxxx, xxxx, xxxx",
                                  hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xffb5b5b5)
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    // fontFamily: 'Chillax',
                                  ),
                                  // fillColor: whiteColor,
                                  filled: true,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 18.0),
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
                                validator: RequiredValidator(
                                    errorText: "tags are required"),
                                // onSaved: (email) => loginRequest!.email = email!,
                              ),

                              const SizedBox(height: 20.0),

                              Text(
                                "Category",
                                style: GoogleFonts.poppins(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 3, bottom: 3),
                                decoration: BoxDecoration(
                                    color: whiteColor.withOpacity(0.29),
                                    borderRadius: BorderRadius.circular(50.0),
                                    border: const Border(
                                      top: BorderSide(
                                          width: 2, color: grayColor),
                                      left: BorderSide(
                                          width: 2, color: grayColor),
                                      right: BorderSide(
                                          width: 2, color: grayColor),
                                      bottom: BorderSide(
                                          width: 2, color: grayColor),
                                    )),
                                child: DropdownButton(
                                  hint: Text(
                                    "Select Listing Category",
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Outfit',
                                      fontSize: 12,
                                      color: grayColor.withOpacity(0.9),
                                    ),
                                  ),
                                  dropdownColor: Colors.white,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 22,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black, fontSize: 16),
                                  value: selectedListing,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedListing = newValue;
                                    });
                                  },
                                  items: listingCategoryList
                                      .map<DropdownMenuItem<String>>(
                                          (valueItem) {
                                    return DropdownMenuItem(
                                      value: valueItem,
                                      child: Text(valueItem),
                                    );
                                  }).toList(),
                                ),
                              ),

                              const SizedBox(height: 20.0),

                              // Text(
                              //   "Sub Category",
                              //   style: GoogleFonts.poppins(
                              //     // fontFamily: 'Chillax',
                              //     color: blackColor,
                              //     fontWeight: FontWeight.w600,
                              //     fontSize: 12.sp,
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Container(
                              //   padding: const EdgeInsets.only(
                              //       left: 16, right: 16, top: 3, bottom: 3),
                              //   decoration: BoxDecoration(
                              //       color: whiteColor.withOpacity(0.29),
                              //       borderRadius: BorderRadius.circular(50.0),
                              //       border: const Border(
                              //         top: BorderSide(
                              //             width: 2, color: grayColor),
                              //         left: BorderSide(
                              //             width: 2, color: grayColor),
                              //         right: BorderSide(
                              //             width: 2, color: grayColor),
                              //         bottom: BorderSide(
                              //             width: 2, color: grayColor),
                              //       )),
                              //   child: DropdownButton(
                              //     hint: Text(
                              //       "Select Listing Sub-Category",
                              //       style: GoogleFonts.poppins(
                              //         // fontFamily: 'Outfit',
                              //         fontSize: 12,
                              //         color: grayColor.withOpacity(0.9),
                              //       ),
                              //     ),
                              //     dropdownColor: Colors.white,
                              //     icon: const Icon(Icons.arrow_drop_down),
                              //     iconSize: 22,
                              //     isExpanded: true,
                              //     underline: const SizedBox(),
                              //     style: GoogleFonts.poppins(
                              //         color: Colors.black, fontSize: 16),
                              //     value: selectedListing,
                              //     onChanged: (newValue) {
                              //       setState(() {
                              //         selectedListing = newValue;
                              //       });
                              //     },
                              //     items: listingCategoryList
                              //         .map<DropdownMenuItem<String>>(
                              //             (valueItem) {
                              //       return DropdownMenuItem(
                              //         value: valueItem,
                              //         child: Text(valueItem),
                              //       );
                              //     }).toList(),
                              //   ),
                              // ),

                              // const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Text(
                                    "Service Image",
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () => pickImages(),
                                      child: const Icon(Icons.attachment))
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),

                              Text(
                                "you can post multiple images. not more than 3 images. Select more images with the attachment icon",
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: grayColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 8.sp,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              SizedBox(
                                height: 120,
                                child: GridView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 1,
                                          mainAxisSpacing: 5.0,
                                          crossAxisSpacing: 5.0,
                                          crossAxisCount: 4),
                                  itemCount: compressedImages.length,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.file(
                                        compressedImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 16.0 * 2.0),
                              SizedBox(
                                width: double.infinity,
                                child: RiseButtonNew(
                                  text: Text(
                                    "Add Item",
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: whiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
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
                                      // compressImage(images);
                                      EasyLoading.show();
                                      newListing(
                                          context,
                                          'Artisan',
                                          selectedListing,
                                          titleEditingController.text
                                              .toString(),
                                          descriptionEditingController.text
                                              .toString(),
                                          tagsEditingController.text.toString(),
                                          compressedImages,
                                          minOfferEditingController.text
                                              .toString());
                                      //   registerNewUserRequest!.phoneNumber = widget.phoneNumber;
                                      //   registerNewUserRequest?.userType = selectedAccountType;
                                      //   BlocProvider.of<RegisterNewUserBloc>(context).add(LoadRegisterNewUserEvent(requestBody: registerNewUserRequest));
                                    }
                                  },
                                  textColor: primaryColor,
                                ),
                              ),
                              const SizedBox(height: 64.0),
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
