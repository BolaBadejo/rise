import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/artisan/home_artisan/screens/view_Listing_screen.dart';
import 'package:rise/pages/user/market_place/product_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'new_listing.dart';

class ArtisanListing extends StatefulWidget {
  const ArtisanListing({super.key});

  @override
  State<ArtisanListing> createState() => _ArtisanListingState();
}

class _ArtisanListingState extends State<ArtisanListing> {
  final TextEditingController searchMarketEditingController =
      TextEditingController();
  @override
  void initState() {
    fetchMyListings();
    super.initState();
  }

  var fetchedListing;

  var state = 'please wait...';
  var stateHeader = 'Fetching your listings';

  Future<void> fetchMyListings() async {
    // print('fetching listings...');
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    try {
      final response = await get(
          Uri.parse('https://admin.rise.ng/api/listing/my-listings'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      var data = jsonDecode(response.body.toString().replaceAll("\n", ""));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString().replaceAll("\n", ""));
        // print(data);
        var result = data['data']['data'];
        List tempList = [];

        if (result != null) {
          for (var v in result) {
            tempList.add(v);
            // print('this is temp list');
            // print(tempList);
          }
        }
        setState(() {
          fetchedListing = tempList;
        });
        // userData = data['data']['user'];
        // names = userData!.fullName!.split(' ');
        // print(data);
        // print("Listings fetched");
      } else {
        // print(data['message']);
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: '${data['message']}',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        setState(() {
          state = '${data['message']}';
          stateHeader = 'You have no listings here';
        });
      }
    } catch (e) {
      // print(e.toString());
      // print("exception, coundnt retrieve listing");
      setState(() {
        state = "Check connection";
        stateHeader =
            'Coundn\'t retrieve listing, swipe this card down to refresh.';
      });
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> _refresh() async {
    fetchMyListings();
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
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your listings",
                      style: TextStyle(
                        // fontFamily: 'Chillax',
                        color: blackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const NewListing();
                        }));
                      },
                      child: Row(
                        children: [
                          Text(
                            'add new',
                            style: TextStyle(
                              // fontFamily: 'Chillax',
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                          const Icon(
                            Icons.control_point,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              fetchedListing == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        height: 13.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stateHeader,
                              style: GoogleFonts.poppins(
                                // fontFamily: 'Chillax',
                                color: whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: state,
                                    // overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      // fontFamily: 'Chillax',
                                      color: whiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      // itemExtent: 70,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: fetchedListing.length,
                      itemBuilder: (BuildContext context, int index) {
                        var listing = fetchedListing[index];
                        // print('this is index');
                        // print(listing);
                        // print(listing['listing_images'][0]);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ViewListingScreen(
                                dataModel: listing,
                                imageUrl: listing['listing_images'],
                                index: index,
                              );
                            }));
                          },
                          child: Container(
                            height: 28.h,
                            width: 100.h,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(30),
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
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: listing['listing_images'][0]
                                        .toString(),
                                    placeholder: (context, url) {
                                      return Container(
                                          height: 15.h,
                                          width: 100.w,
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()));
                                    },
                                    errorWidget: (context, url, error) =>
                                        Container(
                                            height: 15.h,
                                            width: 100.w,
                                            child: Center(
                                                child: Icon(Icons.error))),
                                    imageBuilder: (context, imageProvider) {
                                      return Image(
                                        image: imageProvider,
                                        height: 15.h,
                                        width: 100.w,
                                        fit: BoxFit.cover,
                                      );
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listing['title'] ?? '',
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          // fontFamily: 'Chillax',
                                          color: blackColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        listing['minimum_offer'],
                                        // overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          // fontFamily: 'Chillax',
                                          color: grayColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
