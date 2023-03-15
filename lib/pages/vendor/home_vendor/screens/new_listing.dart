import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rise/constants.dart';
import 'package:rise/widgets/rise_button.dart';
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
  String category = '';
  List<String> accountTypeList = [
    "Vendor",
    "Artisan",
  ];
  List<Asset> images = <Asset>[];

  List files = [];

  List<Asset> resultList = [];

  Future<void> loadAsset() async {
    String error = 'no error detected';
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 3,
          enableCamera: true,
          selectedAssets: images,
          materialOptions: MaterialOptions(),
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"));
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  getImageFromAsset(String path) {
    final file = File(path);
    return file;
  }

  void newListing(context, category, serviceOffering, serviceTitle, description,
      tags, images, minimumServiceOffer) async {
    for (int i = 0; i < images.length; i++) {
      var path2 = await LecleFlutterAbsolutePath.getAbsolutePath(
          uri: images[i].identifier);
      var file = await getImageFromAsset(path2!);
      var base64Image = base64Encode(file.readAsBytesSync());
      files.add(base64Image);
      var data = {
        "files": files,
      };
    }

    List<String> tags2 = tags.split(",");
    try {
      Response response = await post(
          Uri.parse("https://admin.rise.ng/api/listing/new "),
          body: {
            'category': category,
            'service_offering': serviceOffering,
            'serviceTitle': serviceTitle,
            'description': description,
            'tags': tags2.toString(),
            'images': files.toString(),
            'minimum_service_offer': minimumServiceOffer
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // await Preferences.saveUserData(data['data']['user']);
        // context.showToastySnackbar('error ${response.statusCode.toString()}',
        //     data['message'], AlertType.danger);
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Done',
            message: data['message'],

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        // print("done successfully");
      } else {
        // print('error ${response.statusCode.toString()}');
        EasyLoading.dismiss();

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
        // showCustomSnackBar(context, 'error ${response.statusCode.toString()}',
        //     Colors.red, Colors.white);
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
  // List<String> accountTypeList = [
  //   "Vendor",
  //   "Artisan",
  // ];

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
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
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
                                  // hintStyle: TextStyle(
                                  //   color: const Color(0xffb5b5b5)
                                  //       .withOpacity(0.5),
                                  //   fontWeight: FontWeight.w500,
                                  //   fontSize: 12.sp,
                                  //   // fontFamily: 'Chillax',
                                  // ),
                                  fillColor: whiteColor,
                                  filled: true,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(18.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        color: blackColor), //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: blackColor),
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
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
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
                                  // hintStyle: TextStyle(
                                  //   color: const Color(0xffb5b5b5)
                                  //       .withOpacity(0.5),
                                  //   fontWeight: FontWeight.w500,
                                  //   fontSize: 12.sp,
                                  //   // fontFamily: 'Chillax',
                                  // ),
                                  fillColor: whiteColor,
                                  filled: true,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(18.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        color: blackColor), //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: blackColor),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                                // validator: emailValidator,
                                // onSaved: (email) => loginRequest!.email = email!,
                              ),
                              const SizedBox(height: 20.0),

                              Text(
                                "Description",
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
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
                                  // hintStyle: TextStyle(
                                  //   color: const Color(0xffb5b5b5)
                                  //       .withOpacity(0.5),
                                  //   fontWeight: FontWeight.w500,
                                  //   fontSize: 12.sp,
                                  //   // fontFamily: 'Chillax',
                                  // ),
                                  fillColor: whiteColor,
                                  filled: true,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(18.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        color: blackColor), //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: blackColor),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                                // validator: emailValidator,
                                // onSaved: (email) => loginRequest!.email = email!,
                              ),
                              const SizedBox(height: 20.0),

                              Text(
                                "Tags",
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: tagsEditingController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.tag),
                                  hintText:
                                      "enter keywords users can find your listing with.",
                                  hintStyle: TextStyle(
                                    color: const Color(0xffb5b5b5)
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    // fontFamily: 'Chillax',
                                  ),
                                  // fillColor: whiteColor,
                                  filled: true,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.all(18.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        color: blackColor), //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: blackColor),
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
                                "Category",
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
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
                                          width: 2, color: blackColor),
                                      left: BorderSide(
                                          width: 2, color: blackColor),
                                      right: BorderSide(
                                          width: 2, color: blackColor),
                                      bottom: BorderSide(
                                          width: 2, color: blackColor),
                                    )),
                                child: DropdownButton(
                                  hint: Text(
                                    "Choose Account type",
                                    style: TextStyle(
                                        // fontFamily: 'Outfit',
                                        color: grayColor.withOpacity(0.9)),
                                  ),
                                  dropdownColor: Colors.white,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 22,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  // value: selectedAccountType,
                                  onChanged: (newValue) {
                                    setState(() {
                                      // selectedAccountType = newValue;
                                    });
                                  },
                                  items: listingCategoryList
                                      .map<DropdownMenuItem<String>>(
                                          (valueItem) {
                                    return DropdownMenuItem(
                                      value: valueItem,
                                      child: Text(valueItem),
                                      onTap: () {
                                        category = valueItem;
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),

                              const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Text(
                                    "Service Image",
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () => loadAsset(),
                                      child: const Icon(Icons.attachment))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Container(height: 120, child: buildGridView()),

                              const SizedBox(height: 16.0 * 2.0),
                              SizedBox(
                                width: double.infinity,
                                child: RiseButton(
                                  text: "Add Item",
                                  buttonColor: secondaryColor,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      // showCustomSnackBar(
                                      //     context,
                                      //     'Item uploaded successfully',
                                      //     Colors.green,
                                      //     Colors.white);
                                      //
                                      newListing(
                                          context,
                                          'Artisan',
                                          category,
                                          titleEditingController.text
                                              .toString(),
                                          descriptionEditingController.text
                                              .toString(),
                                          tagsEditingController.text.toString(),
                                          images,
                                          minOfferEditingController.text
                                              .toString());
                                      Navigator.of(context).pop();
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

  Widget buildGridView() {
    if (images.isNotEmpty) {
      return GridView.count(
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
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
}
