import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:rise/constants.dart';
import 'package:rise/data/model/listings/listings_model.dart';
import 'package:rise/pages/user/market_place/product_detail.dart';
import 'package:rise/services/api_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class CustomerMarketPlace extends StatefulWidget {
  const CustomerMarketPlace({super.key});

  @override
  State<CustomerMarketPlace> createState() => _CustomerMarketPlaceState();
}

class _CustomerMarketPlaceState extends State<CustomerMarketPlace> {
  List<DataModel> fetchedListings = [];
  final TextEditingController searchMarketEditingController =
      TextEditingController();

  Position? _currentPosition;
  double getLatitude = 0.0;
  double getLongitude = 0.0;
  double distance = 100;
  bool ignore = true;

  bool isSearching = false;
  bool isLoading = false;
  bool checkBoxValue = true;

  Future<dynamic> _getCurrentLocation() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          getLatitude = _currentPosition!.latitude;
          getLongitude = _currentPosition!.longitude;
          isLoading = true;
          // print("lat $getLatitude lng $getLongitude");
          // _getAddressFromLatLng();
        });
      }
    }).catchError((e) {
      //// print(e);
    });
  }

  Future<void> fetchAllListings() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();

    try {
      final response = await get(
          Uri.parse(
              'https://test.rise.ng/api/listing/fetch/6.537055/3.3703183333333335/$distance/$ignore'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print(data);
        // print("Listings fetched fetched");
        setState(() {});
      } else {}
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> fetchAllListingsByName(listing) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    EasyLoading.show();

    try {
      Response response = await post(
          Uri.parse("https://test.rise.ng/api/listing/findListing-by-name"),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $getToken'
          });

      var data = jsonDecode(response.body.toString().replaceAll("\n", ""));
      // print('fetching searched listing');
      // print(data);

      if (response.statusCode == 200) {
        // print(data);
        var result = data['data']['data'];
        List<DataModel> tempList = [];

        if (result != null) {
          for (var v in result) {
            tempList.add(v);
            // print('this is temp list');
            // print(tempList);
          }
        }
        EasyLoading.dismiss();
        setState(() {
          fetchedListings = tempList;
        });
      } else {
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      // print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentLocation();
    fetchAllListings();
    getListings(getLatitude, getLongitude, distance, checkBoxValue);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getListings(getLatitude, getLongitude, distance, checkBoxValue);
    EasyLoading.dismiss();
    super.didChangeDependencies();
  }

  Future<void> getListings(getLatitude, getLongitude, distance, ignore) async {
    var res = await APIHandler.fetchListings(
        getLatitude, getLongitude, distance, ignore);
    setState(() {
      fetchedListings = res;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _refresh() async {
    _getCurrentLocation();
    fetchAllListings();
    getListings(getLatitude, getLongitude, distance, checkBoxValue);
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 30), () {
      completer.complete();
    });
    return completer.future.then<void>((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: LiquidPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        showChildOpacityTransition: false,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Market Place",
                  style: TextStyle(
                    // fontFamily: 'Chillax',
                    color: blackColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: TextFormField(
                          controller: searchMarketEditingController,
                          keyboardType: TextInputType.text,
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
                            suffixIcon: InkWell(
                              onTap: () {
                                fetchedListings = [];
                                searchMarketEditingController.text
                                        .toString()
                                        .isNotEmpty
                                    ? getListings(getLatitude, getLongitude,
                                        distance, checkBoxValue)
                                    : fetchAllListingsByName(
                                        searchMarketEditingController.text
                                            .toString());
                              },
                              child: searchMarketEditingController.text
                                      .toString()
                                      .isNotEmpty
                                  ? const Icon(Icons.close, color: primaryColor)
                                  : const Icon(Icons.search,
                                      color: primaryColor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 18.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(width: 2, color: grayColor),
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
                          onFieldSubmitted: (value) {
                            fetchedListings = [];
                            fetchAllListingsByName(value);
                          },
                          validator: RequiredValidator(
                              errorText: "you can't search a blank field"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          checkBoxValue = !checkBoxValue;
                        });
                        fetchedListings = [];
                        getListings(
                            getLatitude, getLongitude, distance, checkBoxValue);
                      },
                      child: Icon(
                        Icons.location_history,
                        size: 40,
                        color: checkBoxValue ? grayColor : primaryColor,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              checkBoxValue
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Proximity: ${distance.toStringAsFixed(2)}km",
                            style: TextStyle(
                              // fontFamily: 'Chillax',
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 9.sp,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              activeColor: primaryColor,
                              inactiveColor: primaryColor.withOpacity(0.3),
                              value: distance,
                              onChanged: (newDistance) {
                                didChangeDependencies();
                                // print(newDistance);
                                setState(() {
                                  distance = newDistance;
                                });
                              },
                              max: 1000,
                              min: 5,
                              label: "$distance",
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Recently Listed",
                  style: TextStyle(
                    // fontFamily: 'Chillax',
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GridView.builder(
                itemCount: fetchedListings.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.65,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProductDetailScreen(
                          dataModel: fetchedListings[index],
                          // imageUrl: fetchedListings[index].listingImages!,
                          index: index,
                        );
                      }));
                    },
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: grayColor.withOpacity(0.3),
                            offset: const Offset(
                              3.0,
                              3.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                        ],
                        borderRadius: BorderRadius.circular(20.0),
                        color: whiteColor,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: Hero(
                                  tag: 'imageHero + $index',
                                  child: AspectRatio(
                                    aspectRatio: 16 / 12,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: fetchedListings[index]
                                            .listingImages![0],
                                        placeholder: (context, url) => Center(
                                            child:
                                                const CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                                child: const Icon(Icons.error)),
                                      ),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color:
                                  grayColor.withOpacity(0.3), //color of divider
                              height: 3, //height spacing of divider
                              thickness: 2, //thickness of divier line
                              indent: 25, //spacing at the start of divider
                              endIndent: 25, //spacing at the end of divider
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              fetchedListings[index].title!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const WidgetSpan(
                                    child: Icon(Icons.store, size: 14),
                                  ),
                                  TextSpan(
                                    text:
                                        ' ${fetchedListings[index].serviceOffering!}',
                                    // overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: blackColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              fetchedListings[index].minimumOffer!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(20),
              ),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
