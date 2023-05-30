import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/user/market_place/product_detail.dart';
import 'package:rise/pages/user/market_place/product_detail_two.dart';
// import 'package:rise/pages/artisan/home_artisan/screens/view_Listing_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../data/model/listings/listings_model.dart';

class ViewArtisanDetailScreen extends StatefulWidget {
  final dataModel;
  const ViewArtisanDetailScreen({super.key, required this.dataModel});

  @override
  State<ViewArtisanDetailScreen> createState() =>
      _ViewArtisanDetailScreenState();
}

var fetchedListings;

var state = 'please wait...';
var stateHeader = 'Fetching your listings';
List<DataModel> fetchedListing = [];

class _ViewArtisanDetailScreenState extends State<ViewArtisanDetailScreen> {
  final TextEditingController priceOfferEditingController =
      TextEditingController();

  Future<void> fetchUserListings() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    String getToken = sharedPreference.get('access_token').toString();
    EasyLoading.show();

    try {
      final response = await get(
          Uri.parse(
              'https://admin.rise.ng/api/user-listings/${widget.dataModel['id']}/10'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $getToken'
          });

      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var result = data['data']['data'];
        List tempList = [];

        if (result != null) {
          for (var v in result) {
            tempList.add(v);
            // print('this is temp list');
            // print(tempList);
          }
        }

        // print(data);

        setState(() {
          fetchedListings = tempList;
          fetchedListing = DataModel.dataFromSnapshot(tempList);
        });
        // print(data);
        // print("Listings fetched");
      } else {
        EasyLoading.dismiss();
        // // print(data['message']);
        setState(() {
          state = '${data['message']}';
          stateHeader = 'You have no listings here';
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      // print(e.toString());
      // print("exception, coundnt retrieve listing");
      setState(() {
        state = "Check connection";
        stateHeader =
            'Coundn\'t retrieve listing, swipe this card down to refresh.';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    fetchUserListings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    name: widget.dataModel['full_name'],
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
                    widget.dataModel['full_name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      // fontFamily: 'Chillax',
                      color: blackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                  widget.dataModel['rise_verified_at'] == null
                      ? Container()
                      : const Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Icon(
                            Icons.verified,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                  widget.dataModel['user_account'] != 'premium'
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                    Icons.workspace_premium,
                                    color: grayColor,
                                    size: 11,
                                  ),
                                  Text(
                                    widget.dataModel['user_account'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      // fontFamily: 'Chillax',
                                      color: grayColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 7.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                ],
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                widget.dataModel['user_type'],
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
              child: Text(
                widget.dataModel['email'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  // fontFamily: 'Chillax',
                  color: grayColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            fetchedListings == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      height: 12.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: grayColor,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Popularity check!!",
                            style: TextStyle(
                              // fontFamily: 'Chillax',
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "we are checking if this artisan has listings",
                                  // overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    // fontFamily: 'Chillax',
                                    color: whiteColor,
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
                  )
                : fetchedListings.length == 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          height: 12.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: grayColor,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Artisan has no Listings yet.",
                                style: TextStyle(
                                  // fontFamily: 'Chillax',
                                  color: blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // shareFile();
                                },
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Check again later.",
                                        // overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          // fontFamily: 'Chillax',
                                          color: whiteColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Listings",
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          fetchedListings == null
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  itemCount: fetchedListings.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var listing = fetchedListings[index];
                                    print(listing);
                                    return GestureDetector(
                                      onTap: () {
                                        DataModel list = fetchedListing[index];
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ViewProductDetailScreen(
                                            dataModel: listing,
                                            userType:
                                                widget.dataModel['user_type'],
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
                                          borderRadius:
                                              BorderRadius.circular(30),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    listing['listing_images'][0]
                                                        .toString(),
                                                placeholder: (context, url) {
                                                  return Container(
                                                      height: 15.h,
                                                      width: 100.w,
                                                      child: const Center(
                                                          child:
                                                              CircularProgressIndicator()));
                                                },
                                                errorWidget: (context, url,
                                                        error) =>
                                                    SizedBox(
                                                        height: 15.h,
                                                        width: 100.w,
                                                        child: const Center(
                                                            child: Icon(
                                                                Icons.error))),
                                                imageBuilder:
                                                    (context, imageProvider) {
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
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    listing['minimum_offer'],
                                                    // overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      // fontFamily: 'Chillax',
                                                      color: grayColor,
                                                      fontWeight:
                                                          FontWeight.w600,
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

                          // SizedBox(
                          //   height: 25.h,
                          //   width: 100.w,
                          //   child: GestureDetector(
                          //     // onTap: (() => show(context, fetchedListings)),
                          //     child: Container(
                          //         // height: ,
                          //         // width: 125,
                          //         margin: const EdgeInsets.symmetric(
                          //             horizontal: 10, vertical: 10),
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 20, vertical: 20),
                          //         decoration: BoxDecoration(
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: grayColor.withOpacity(0.3),
                          //               offset: const Offset(
                          //                 3.0,
                          //                 3.0,
                          //               ),
                          //               blurRadius: 5.0,
                          //               spreadRadius: 2.0,
                          //             ), //BoxShadow
                          //           ],
                          //           borderRadius: BorderRadius.circular(30),
                          //           color: whiteColor,
                          //         ),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           crossAxisAlignment: CrossAxisAlignment.end,
                          //           children: [
                          //             SizedBox(
                          //               width: 20.w,
                          //               height: 25.h,
                          //               child: ExpandableCarousel.builder(
                          //                 options: CarouselOptions(
                          //                   height: 20.h,
                          //                   aspectRatio: 16 / 12,
                          //                   viewportFraction: 1.0,
                          //                   initialPage: 0,
                          //                   enableInfiniteScroll: false,
                          //                   reverse: true,
                          //                   autoPlay: true,
                          //                   autoPlayInterval:
                          //                       const Duration(seconds: 4),
                          //                   autoPlayAnimationDuration:
                          //                       const Duration(milliseconds: 800),
                          //                   autoPlayCurve: Curves.fastOutSlowIn,
                          //                   enlargeCenterPage: true,
                          //                   pageSnapping: true,
                          //                   scrollDirection: Axis.vertical,
                          //                   pauseAutoPlayOnTouch: true,
                          //                   pauseAutoPlayOnManualNavigate: true,
                          //                   pauseAutoPlayInFiniteScroll: false,
                          //                   enlargeStrategy:
                          //                       CenterPageEnlargeStrategy.scale,
                          //                   disableCenter: false,
                          //                   showIndicator: true,
                          //                   slideIndicator:
                          //                       const CircularSlideIndicator(),
                          //                 ),
                          //                 itemCount:
                          //                     fetchedListings['listing_images']
                          //                         .length,
                          //                 itemBuilder: (BuildContext context,
                          //                         int itemIndex,
                          //                         int pageViewIndex) =>
                          //                     CachedNetworkImage(
                          //                   imageBuilder:
                          //                       (context, imageProvider) {
                          //                     return Image(
                          //                       image: imageProvider,
                          //                       height: 20.h,
                          //                       width: 20.w,
                          //                       fit: BoxFit.cover,
                          //                     );
                          //                   },
                          //                   fit: BoxFit.cover,
                          //                   imageUrl:
                          //                       fetchedListings['listing_images']
                          //                           [itemIndex],
                          //                   placeholder: (context, url) =>
                          //                       const Center(
                          //                           child:
                          //                               CircularProgressIndicator()),
                          //                   errorWidget: (context, url, error) =>
                          //                       const Icon(Icons.error),
                          //                 ),
                          //               ),
                          //             ),
                          //             const SizedBox(
                          //               width: 10,
                          //             ),
                          //             Column(
                          //               mainAxisAlignment: MainAxisAlignment.end,
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 Text(
                          //                   "${fetchedListings['title'] ?? ''}",
                          //                   style: TextStyle(
                          //                     // fontFamily: 'Chillax',
                          //                     color: blackColor,
                          //                     fontWeight: FontWeight.w600,
                          //                     fontSize: 10.sp,
                          //                   ),
                          //                 ),
                          //                 Text(
                          //                   "for: ${fetchedListings['title'] ?? ''}",
                          //                   style: TextStyle(
                          //                     // fontFamily: 'Chillax',
                          //                     color: grayColor,
                          //                     fontWeight: FontWeight.w500,
                          //                     fontSize: 9.sp,
                          //                   ),
                          //                 ),
                          //                 Text(
                          //                   fetchedListings['category'] ?? '',
                          //                   style: TextStyle(
                          //                     // fontFamily: 'Chillax',
                          //                     color: blackColor,
                          //                     fontWeight: FontWeight.w500,
                          //                     fontSize: 14.sp,
                          //                   ),
                          //                 ),
                          //                 Text(
                          //                   "for: ${fetchedListings['title'] ?? ''}",
                          //                   style: TextStyle(
                          //                     // fontFamily: 'Chillax',
                          //                     color: grayColor,
                          //                     fontWeight: FontWeight.w500,
                          //                     fontSize: 9.sp,
                          //                   ),
                          //                 ),
                          //                 Expanded(
                          //                   flex: 1,
                          //                   child: Container(),
                          //                 ),
                          //                 Text(
                          //                   fetchedListings['minimum_offer'] ??
                          //                       '',
                          //                   style: TextStyle(
                          //                     // fontFamily: 'Chillax',
                          //                     color: blackColor,
                          //                     fontWeight: FontWeight.w500,
                          //                     fontSize: 14.sp,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //             Expanded(child: SizedBox()),
                          //             IconButton(
                          //               onPressed: () {
                          //                 Navigator.push(context,
                          //                     MaterialPageRoute(
                          //                         builder: (context) {
                          //                   return ProductDetailScreen(
                          //                     dataModel: fetchedListings,
                          //                     imageUrl: fetchedListings[
                          //                         'listing_images']!,
                          //                     index: 0,
                          //                   );
                          //                 }));
                          //               },
                          //               icon: const Icon(
                          //                 Icons.explore,
                          //                 size: 22,
                          //                 color: secondaryColor,
                          //               ),
                          //             )
                          //           ],
                          //         )),
                          //   ),
                          // ),
                        ],
                      ),
          ]),
        ),
      ),
    );
  }
}
