// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:rise/constants.dart';
// import 'package:sizer/sizer.dart';

// class ArtisanCard extends StatefulWidget {
//   const ArtisanCard(
//       {Key? key,
//       required this.category,
//       required this.serviceOffering,
//       required this.title,
//       required this.description,
//       required this.profileImage,
//       required this.listingImages,
//       required this.minimumOffer,
//       required this.slug,
//       required this.tags,
//       required this.name,
//       required this.phoneNumber,
//       required this.email,
//       required this.residentialAddress,
//       required this.city,
//       required this.state,
//       required this.lat,
//       required this.lng,
//       required this.businessAddress,
//       required this.index,
//       required this.listingId,
//       required this.type})
//       : super(key: key);
//   final int listingId;
//   final String category;
//   final String serviceOffering;
//   final String title;
//   final String description;
//   final String profileImage;
//   final List listingImages;
//   final String minimumOffer;
//   final String slug;
//   final List tags;
//   final String name;
//   final String phoneNumber;
//   final String email;
//   final String residentialAddress;
//   final String city;
//   final String state;
//   final String lat;
//   final String lng;
//   final String businessAddress;
//   final int index;
//   final String type;

//   @override
//   ArtisanCardState createState() => ArtisanCardState();
// }

// class ArtisanCardState extends State<ArtisanCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//                 builder: (context) => ArtisanDetailsScreen(
//                       listingId: widget.listingId,
//                       profileImage: widget.profileImage,
//                       phoneNumber: widget.phoneNumber,
//                       serviceOffering: widget.serviceOffering,
//                       description: widget.description,
//                       listingImages: widget.listingImages,
//                       name: widget.name,
//                       state: widget.state,
//                       minimumOffer: widget.minimumOffer,
//                       residentialAddress: widget.residentialAddress,
//                       title: widget.title,
//                       city: widget.city,
//                       tags: widget.tags,
//                       slug: widget.slug,
//                       lng: widget.lng,
//                       lat: widget.lat,
//                       email: widget.email,
//                       category: widget.category,
//                       businessAddress: widget.businessAddress,
//                       index: widget.index,
//                       type: widget.type,
//                     )),
//           );
//         },
//         child: Container(
//           height: 185,
//           width: MediaQuery.of(context).size.width / 1.2,
//           margin: const EdgeInsets.only(
//               top: 30.0, bottom: 30.0, right: 4.0, left: 25.0),
//           decoration: BoxDecoration(
//             color: widget.type == "Artisan"
//                 ? const Color(0xfff9f9f9)
//                 : Colors.amber.shade50,
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.name,
//                             style: TextStyle(
//                                 color: primaryColor,
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 20.sp),
//                           ),
//                           Text(
//                             widget.serviceOffering,
//                             maxLines: 1,
//                             style: TextStyle(
//                                 color:
//                                     const Color(0xff201E1E).withOpacity(0.90),
//                                 fontWeight: FontWeight.w400,
//                                 overflow: TextOverflow.ellipsis,
//                                 fontSize: 10.sp),
//                           ),
//                           const SizedBox(
//                             height: defaultPadding,
//                           ),
//                           Flexible(
//                             child: Text(
//                               widget.description,
//                               maxLines: 3,
//                               style: TextStyle(
//                                   overflow: TextOverflow.ellipsis,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w200,
//                                   fontSize: 14.sp),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Stack(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 30, left: 40),
//                             child: Container(
//                               height: 65,
//                               width: 65,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(16.0),
//                                 // color: Colors.red,
//                                 image: DecorationImage(
//                                     image: NetworkImage(widget.profileImage),
//                                     fit: BoxFit.fill),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 0,
//                             bottom: 80,
//                             left: 45,
//                             right: 0,
//                             child: Row(
//                               children: [
//                                 Text(
//                                   "4.5",
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 10.sp),
//                                 ),
//                                 const SizedBox(width: 4.0),
//                                 SvgPicture.asset(
//                                   "assets/icons/star.svg",
//                                   width: 20,
//                                   height: 20,
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => BookOrBuyScreen(
//                                 listingId: widget.listingId,
//                                 businessAddress: widget.businessAddress,
//                                 profileImage: widget.profileImage,
//                                 name: widget.name,
//                                 serviceOffering: widget.serviceOffering,
//                                 phoneNumber: widget.phoneNumber,
//                                 type: widget.type,
//                                 minimumOffer: widget.minimumOffer,
//                               )));
//                 },
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: Container(
//                     margin: const EdgeInsets.only(bottom: 16.0),
//                     height: 40,
//                     width: 100,
//                     decoration: const BoxDecoration(
//                       color: secondaryColor,
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(8.0),
//                           bottomLeft: Radius.circular(8.0)),
//                     ),
//                     child: Center(
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         // mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(
//                             width: 16.0,
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               "Book",
//                               style: TextStyle(
//                                   color: primaryColor,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 11.sp),
//                             ),
//                           ),
//                           const Expanded(
//                               flex: 1,
//                               child: Icon(
//                                 Icons.arrow_forward_ios,
//                                 color: primaryColor,
//                                 size: 15,
//                               ))
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
