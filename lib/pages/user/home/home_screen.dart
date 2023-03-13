// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_widget/google_maps_widget.dart';
// import 'package:rise/business_logic/category/category_bloc.dart';
// import 'package:rise/business_logic/search/search_bloc.dart';
// import 'package:rise/pages/user/home/components/artisan_card.dart';
// import 'package:rise/views/notification/notification_screen.dart';
// import 'package:rise/widgets/rise_button.dart';
// import 'package:sizer/sizer.dart';
// import 'package:swipe_refresh/swipe_refresh.dart';
// import 'dart:io' show Platform;

// import '../../../business_logic/get_auth_user/get_auth_user_bloc.dart';
// import '../../../constants.dart';
// import '../../../widgets/custom_snack_bar.dart';
// import '../../auth/signin_screen.dart';
// import 'components/filter_card.dart';
// import 'account_type_selection.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return HomeScreenState();
//   }
// }

// class HomeScreenState extends State<HomeScreen> {
//   final _controller = StreamController<SwipeRefreshState>.broadcast();

//   Stream<SwipeRefreshState> get _stream => _controller.stream;

//   TextEditingController searchEditingController = TextEditingController();

//   String fullName = " ", phoneNumber = " ", email = " ", userType = " ";
//   int? id;
//   bool? isVerified;

//   Position? _currentPosition;
//   double getLatitude = 0.0;
//   double getLongitude = 0.0;
//   String city = " ";
//   String state = " ";
//   String street = " ";

//   bool isSearching = false;
//   bool isLoading = false;

//   Future<dynamic> _getCurrentLocation() async {
//     Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.best,
//             forceAndroidLocationManager: true)
//         .then((Position position) {
//       if (mounted) {
//         setState(() {
//           _currentPosition = position;
//           getLatitude = _currentPosition!.latitude;
//           getLongitude = _currentPosition!.longitude;
//           isLoading = true;
//           _getAddressFromLatLng();
//         });
//       }
//     }).catchError((e) {
//       //// print(e);
//     });
//   }

//   _getAddressFromLatLng() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition!.latitude, _currentPosition!.longitude);

//       Placemark place = placemarks[0];
//       setState(() {
//         city = place.locality!;
//         street = place.street!;
//         state = place.administrativeArea!;
//       });
//     } catch (e) {
//       //// print(e);
//     }
//   }

//   showFilterModalSheet(BuildContext context) {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       backgroundColor: Colors.white.withOpacity(0.85),
//       builder: (context) => BlocBuilder<CategoryBloc, CategoryState>(
//         builder: (context, state) {
//           if (state is CategoryLoadingState) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (state is CategoryLoadedState) {
//             if (state.categoryResponse.data.data.isNotEmpty) {
//               return SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom),
//                   child: Container(
//                     padding: const EdgeInsets.all(defaultPadding * 2),
//                     height: MediaQuery.of(context).size.height / 1.45,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Categories",
//                           style: TextStyle(
//                               fontSize: 16.0, fontWeight: FontWeight.w400),
//                         ),
//                         GridView.builder(
//                           shrinkWrap: true,
//                           itemCount: state.categoryResponse.data.data.length,
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 3,
//                                   childAspectRatio: 2,
//                                   mainAxisSpacing: 1.5),
//                           itemBuilder: (BuildContext context, int index) {
//                             return FilterCard(
//                               text: state.categoryResponse.data.data[index]
//                                   ['name'],
//                               isSelected: false,
//                               onPressed: () {
//                                 setState(() {
//                                   searchEditingController.text = state
//                                       .categoryResponse
//                                       .data
//                                       .data[index]['name'];
//                                 });
//                                 Navigator.of(context).pop();
//                               },
//                             );
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             } else {
//               return SizedBox(
//                 height: 250,
//                 child: Center(
//                   child: Text(
//                     "No Category found",
//                     style: TextStyle(fontSize: 12.sp),
//                   ),
//                 ),
//               );
//             }
//           }
//           if (state is CategoryErrorState) {
//             Container();
//             showCustomSnackBar(context, state.error, Colors.red, Colors.white);
//           }
//           return Container();
//         },
//       ),
//     );
//   }

//   Future<void> _refresh() async {
//     // When all needed is done change state.
//     BlocProvider.of<GetAuthUserBloc>(context).add(RefreshGetAuthUserEvent());
//     _controller.sink.add(SwipeRefreshState.hidden);
//   }

//   final List<Marker> marker = [];
//   final List<Marker> list = [];
//   bool isKYCVerified = true;

//   static final CameraPosition _cameraPosition =
//       CameraPosition(target: LatLng(3.36997836828231, -3.369978368282318));
//   final Set<Marker> _makers = {};
//   late MapType _currentMapType = MapType.normal;
//   late final GoogleMapController mapController;

//   void _changeMapType() {
//     setState(() {
//       _currentMapType = _currentMapType == MapType.normal
//           ? MapType.satellite
//           : MapType.normal;
//     });
//   }

//   void _addMakers() {
//     setState(() {
//       _makers.add(
//         Marker(
//           markerId: const MarkerId('defaultNotification'),
//           position:
//               CameraPosition(target: LatLng(getLatitude, getLongitude)).target,
//           icon: BitmapDescriptor.defaultMarker,
//           infoWindow: const InfoWindow(title: "Current Location"),
//         ),
//       );
//     });
//   }

//   Future<void> _moveToNewLocation() async {
//     var newPosition = LatLng(getLatitude, getLongitude);
//     mapController.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 50));
//     setState(() {
//       var marker = Marker(
//         markerId: const MarkerId('defaultNotification'),
//         position: newPosition,
//         icon: BitmapDescriptor.defaultMarker,
//         infoWindow: const InfoWindow(title: "Current Location"),
//       );
//       _makers
//         ..clear()
//         ..add(marker);
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<GetAuthUserBloc>().add(LoadGetAuthUserEvent());
//       context.read<CategoryBloc>().add(LoadCategoryEvent());
//     });
//     // getProvider();
//     // getCategory();
//     _getCurrentLocation();
//     _addMakers();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(100),
//         child: AppBar(
//           flexibleSpace: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Platform.isAndroid
//                   ? Container(
//                       height: 70,
//                       width: MediaQuery.of(context).size.width / 1.1,
//                       margin: const EdgeInsets.only(top: 45.0, bottom: 0.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(32.0),
//                         color: const Color(0xfff3f2f2),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           controller: searchEditingController,
//                           keyboardType: TextInputType.text,
//                           textInputAction: TextInputAction.search,
//                           decoration: InputDecoration(
//                             hintText: " I want ...",
//                             hintStyle: TextStyle(
//                               color: const Color(0xffb5b5b5).withOpacity(0.5),
//                               fontWeight: FontWeight.w500,
//                               fontSize: 12.sp,
//                               // fontFamily: 'Outfit',
//                             ),
//                             prefixIcon: const Padding(
//                               padding: EdgeInsets.all(4.0),
//                               child: Icon(
//                                 Icons.search,
//                                 size: 26,
//                                 color: primaryColor,
//                               ),
//                               // child: Container(
//                               //   height: 20,
//                               //   width: 20,
//                               //   padding: const EdgeInsets.all(8.0),
//                               //   decoration: BoxDecoration(
//                               //     borderRadius: BorderRadius.circular(8.0),
//                               //     color: Colors.grey.withOpacity(0.20),
//                               //   ),
//                               //   child: const Icon(
//                               //     Icons.search,
//                               //     size: 26,
//                               //     color: primaryColor,
//                               //   ),
//                               // ),
//                             ),
//                             suffixIcon: GestureDetector(
//                               onTap: () {
//                                 showFilterModalSheet(context);
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12.0),
//                                 child:
//                                     SvgPicture.asset("assets/icons/filter.svg"),
//                               ),
//                             ),
//                             fillColor: grayColor.withOpacity(0.27),
//                             filled: false,
//                             isDense: true,
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 0.0, vertical: 0),
//                             border: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(8.0),
//                               ),
//                             ),
//                             // If  you are using latest version of flutter then table text and hint text shown like this
//                             // if you r using flutter less then 1.20.* then maybe this is not working properly
//                           ),
//                           validator: emailValidator,
//                           onSaved: (value) =>
//                               searchEditingController.text = value!,
//                           onFieldSubmitted: (value) {
//                             BlocProvider.of<SearchBloc>(context)
//                                 .add(LoadSearchEvent(
//                               searchValue: searchEditingController.text,
//                               city: city,
//                               state: state,
//                             ));
//                           },
//                         ),
//                       ),
//                     )
//                   : Container(
//                       height: 55,
//                       width: MediaQuery.of(context).size.width / 1.1,
//                       margin: const EdgeInsets.only(top: 55.0, bottom: 10.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(32.0),
//                         color: const Color(0xfff3f2f2),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           controller: searchEditingController,
//                           keyboardType: TextInputType.text,
//                           textInputAction: TextInputAction.search,
//                           decoration: InputDecoration(
//                             hintText: " I want ...",
//                             hintStyle: TextStyle(
//                               color: const Color(0xffb5b5b5).withOpacity(0.5),
//                               fontWeight: FontWeight.w500,
//                               fontSize: 12.sp,
//                               // fontFamily: 'Outfit',
//                             ),
//                             prefixIcon: const Padding(
//                               padding: EdgeInsets.all(4.0),
//                               child: Icon(
//                                 Icons.search,
//                                 size: 26,
//                                 color: primaryColor,
//                               ),
//                               // child: Container(
//                               //   height: 20,
//                               //   width: 20,
//                               //   padding: const EdgeInsets.all(8.0),
//                               //   decoration: BoxDecoration(
//                               //     borderRadius: BorderRadius.circular(8.0),
//                               //     color: Colors.grey.withOpacity(0.20),
//                               //   ),
//                               //   child: const Icon(
//                               //     Icons.search,
//                               //     size: 26,
//                               //     color: primaryColor,
//                               //   ),
//                               // ),
//                             ),
//                             suffixIcon: GestureDetector(
//                               onTap: () {
//                                 showFilterModalSheet(context);
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12.0),
//                                 child:
//                                     SvgPicture.asset("assets/icons/filter.svg"),
//                               ),
//                             ),
//                             fillColor: grayColor.withOpacity(0.27),
//                             filled: false,
//                             isDense: true,
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 0.0, vertical: 0),
//                             border: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(8.0),
//                               ),
//                             ),
//                             // If  you are using latest version of flutter then table text and hint text shown like this
//                             // if you r using flutter less then 1.20.* then maybe this is not working properly
//                           ),
//                           validator: emailValidator,
//                           onSaved: (value) =>
//                               searchEditingController.text = value!,
//                           onFieldSubmitted: (value) {
//                             BlocProvider.of<SearchBloc>(context)
//                                 .add(LoadSearchEvent(
//                               searchValue: searchEditingController.text,
//                               city: city,
//                               state: state,
//                             ));
//                           },
//                         ),
//                       ),
//                     ),
//               // Expanded(
//               //   flex: 1,
//               //   child: SvgPicture.asset("assets/icons/location_appbar.svg"),
//               // ),
//               // Expanded(
//               //   flex: 2,
//               //   child: Padding(
//               //     padding: const EdgeInsets.only(top: 60.0),
//               //     child: Column(
//               //       crossAxisAlignment: CrossAxisAlignment.start,
//               //       children: [
//               //          Text(
//               //           street,
//               //           style: const TextStyle(
//               //               fontSize: 20.0, fontWeight: FontWeight.bold),
//               //         ),
//               //         const SizedBox(
//               //           height: 4.0,
//               //         ),
//               //         Row(
//               //           children: [
//               //             SvgPicture.asset("assets/icons/mark_appbar.svg"),
//               //             const SizedBox(
//               //               width: 4.0,
//               //             ),
//               //             Text(
//               //               "Change Task Location?",
//               //               style: TextStyle(
//               //                   fontSize: 12.0,
//               //                   color: Colors.grey.withOpacity(0.50),
//               //                   fontWeight: FontWeight.bold),
//               //             ),
//               //           ],
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//               // Expanded(
//               //   flex: 1,
//               //   child: GestureDetector(
//               //     onTap: (){
//               //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const NotificationScreen()));
//               //     },
//               //     child: Column(
//               //       children: [
//               //         Padding(
//               //           padding: const EdgeInsets.only(top: 60.0, left: 16.0),
//               //           child: Container(
//               //             height: 35,
//               //             width: 35,
//               //             padding: const EdgeInsets.all(8.0),
//               //             decoration: BoxDecoration(
//               //               borderRadius: BorderRadius.circular(8.0),
//               //               color: Colors.grey.withOpacity(0.20),
//               //             ),
//               //             child: SvgPicture.asset(
//               //                 "assets/icons/notification_menu.svg"),
//               //           ),
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: BlocListener<GetAuthUserBloc, GetAuthUserState>(
//           listener: (context, state) {
//             if (state is GetAuthUserLoadingState) {
//               EasyLoading.show(status: '');
//             }
//             if (state is GetAuthUserLoadedState) {
//               EasyLoading.dismiss();
//               if (state.getAuthUserResponse.data.kycVerified == false) {
//                 isKYCVerified = true;
//               }
//             }
//             if (state is GetAuthUserErrorState) {
//               EasyLoading.dismiss();
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => const SignInScreen()),
//                   (route) => false);
//               showCustomSnackBar(
//                   context, state.error, Colors.red, Colors.white);
//             }
//           },
//           child: SingleChildScrollView(
//             physics: const NeverScrollableScrollPhysics(),
//             child: Stack(
//               children: [
//                 isKYCVerified
//                     ? Container()
//                     : Positioned(
//                         top: 0,
//                         left: 0,
//                         right: 0,
//                         child: Container(
//                           height: 100,
//                           padding: const EdgeInsets.all(15),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(25),
//                             color: Colors.white,
//                           ),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 4,
//                                 child: Text(
//                                   "Fill in your KYC to proceed with\nVendor booking",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     // fontFamily: 'Outfit',
//                                     color: primaryColor,
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 18.sp,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: RiseButton(
//                                   text: "KYC Form",
//                                   buttonColor: secondaryColor,
//                                   textColor: primaryColor,
//                                   onPressed: () {
//                                     // Navigator.pushAndRemoveUntil(
//                                     //     context,
//                                     //     MaterialPageRoute(
//                                     //         builder: (context) =>
//                                     //             const AccountTypeSelection()),
//                                     //     (route) => false);
//                                   },
//                                 ),
//                               )
//                             ],
//                           ),
//                         )),
//                 Column(
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height,
//                       child: GoogleMap(
//                         markers: _makers,
//                         mapType: _currentMapType,
//                         scrollGesturesEnabled: true,
//                         zoomControlsEnabled: true,
//                         zoomGesturesEnabled: true,
//                         myLocationButtonEnabled: true,
//                         myLocationEnabled: true,
//                         compassEnabled: true,
//                         onMapCreated: (controller) {
//                           mapController = controller;
//                         },
//                         initialCameraPosition: CameraPosition(
//                             target: LatLng(getLatitude, getLongitude)),
//                       ),
//                     ),
//                     // Container(
//                     //   height: 70,
//                     //   width: MediaQuery.of(context).size.width / 1.3,
//                     //   margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
//                     //   color: Colors.white,
//                     //   child: Padding(
//                     //     padding: const EdgeInsets.all(8.0),
//                     //     child: TextFormField(
//                     //       controller: searchEditingController,
//                     //       keyboardType: TextInputType.text,
//                     //       textInputAction: TextInputAction.search,
//                     //       decoration: InputDecoration(
//                     //         hintText: " I want ...",
//                     //         hintStyle: TextStyle(
//                     //           color: const Color(0xffb5b5b5).withOpacity(0.5),
//                     //           fontWeight: FontWeight.w500,
//                     //           fontSize: 12.sp,
//                     //           // fontFamily: 'Outfit',
//                     //         ),
//                     //         prefixIcon: Padding(
//                     //           padding: const EdgeInsets.all(4.0),
//                     //           child: Container(
//                     //             height: 20,
//                     //             width: 20,
//                     //             padding: const EdgeInsets.all(8.0),
//                     //             decoration: BoxDecoration(
//                     //               borderRadius: BorderRadius.circular(8.0),
//                     //               color: Colors.grey.withOpacity(0.20),
//                     //             ),
//                     //             child: const Icon(
//                     //               Icons.search,
//                     //               size: 26,
//                     //               color: primaryColor,
//                     //             ),
//                     //           ),
//                     //         ),
//                     //         suffixIcon: GestureDetector(
//                     //           onTap: (){
//                     //             showFilterModalSheet(context);
//                     //           },
//                     //           child: Padding(
//                     //             padding: const EdgeInsets.all(12.0),
//                     //             child: SvgPicture.asset("assets/icons/filter.svg"),
//                     //           ),
//                     //         ),
//                     //         fillColor: grayColor.withOpacity(0.27),
//                     //         filled: false,
//                     //         isDense: true,
//                     //         contentPadding: const EdgeInsets.symmetric(
//                     //             horizontal: 0.0, vertical: 0),
//                     //         border: const OutlineInputBorder(
//                     //           borderRadius: BorderRadius.all(
//                     //             Radius.circular(8.0),
//                     //           ),
//                     //         ),
//                     //         // If  you are using latest version of flutter then table text and hint text shown like this
//                     //         // if you r using flutter less then 1.20.* then maybe this is not working properly
//                     //       ),
//                     //       validator: emailValidator,
//                     //       onSaved: (value) => searchEditingController.text = value!,
//                     //       onFieldSubmitted: (value){
//                     //         BlocProvider.of<SearchBloc>(context).add(LoadSearchEvent(searchValue: searchEditingController.text,city: "Sabo Yaba",state: "Lagos",));
//                     //       },
//                     //     ),
//                     //   ),
//                     // ),
//                     // Expanded(
//                     //   child: Stack(
//                     //     children: [
//                     //       SizedBox(
//                     //         height: MediaQuery.of(context).size.height,
//                     //         child: GoogleMap(
//                     //           markers: Set<Marker>.of(list),
//                     //           initialCameraPosition: _cameraPosition,
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//                 Positioned(
//                   bottom: Platform.isAndroid ? 200 : 275,
//                   left: 0,
//                   right: 0,
//                   child: BlocBuilder<SearchBloc, SearchState>(
//                     builder: (context, state) {
//                       if (state is SearchLoadedState) {
//                         EasyLoading.dismiss();
//                         state.searchResponse.data.listing.map((e) => {
//                               list.add(Marker(
//                                 markerId: MarkerId(e.id.toString()),
//                                 position: LatLng(
//                                     double.tryParse(e.user.lat) ?? 0.0,
//                                     double.tryParse(e.user.lng) ?? 0.0),
//                                 infoWindow: InfoWindow(title: e.user.name),
//                               )),
//                             });
//                         if (state.searchResponse.data.listing.isEmpty) {
//                           showCustomSnackBar(context, "No record found",
//                               Colors.green, Colors.white);
//                         }
//                         return Align(
//                           alignment: FractionalOffset.bottomCenter,
//                           child: SizedBox(
//                             height: 250,
//                             child: ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const AlwaysScrollableScrollPhysics(),
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount:
//                                     state.searchResponse.data.listing.length,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return ArtisanCard(
//                                     listingId: state
//                                         .searchResponse.data.listing[index].id,
//                                     profileImage: state.searchResponse.data
//                                         .listing[index].profileImage,
//                                     phoneNumber: state.searchResponse.data
//                                         .listing[index].user.phoneNumber,
//                                     serviceOffering: state.searchResponse.data
//                                         .listing[index].serviceOffering,
//                                     description: state.searchResponse.data
//                                         .listing[index].description,
//                                     listingImages: state.searchResponse.data
//                                         .listing[index].listingImages,
//                                     name: state.searchResponse.data
//                                         .listing[index].user.name,
//                                     state: state.searchResponse.data
//                                         .listing[index].user.state,
//                                     minimumOffer: state.searchResponse.data
//                                         .listing[index].minimumOffer,
//                                     residentialAddress: state
//                                         .searchResponse
//                                         .data
//                                         .listing[index]
//                                         .user
//                                         .residentialAddress,
//                                     title: state.searchResponse.data
//                                         .listing[index].title,
//                                     city: state.searchResponse.data
//                                         .listing[index].user.city,
//                                     tags: state.searchResponse.data
//                                         .listing[index].tags,
//                                     slug: state.searchResponse.data
//                                         .listing[index].slug,
//                                     lng: state.searchResponse.data
//                                         .listing[index].user.lng,
//                                     lat: state.searchResponse.data
//                                         .listing[index].user.lat,
//                                     email: state.searchResponse.data
//                                         .listing[index].user.email,
//                                     category: state.searchResponse.data
//                                         .listing[index].category,
//                                     businessAddress: state.searchResponse.data
//                                         .listing[index].user.businessAddress,
//                                     index: index,
//                                     type: state.searchResponse.data
//                                         .listing[index].user.type,
//                                   );
//                                 }),
//                           ),
//                         );
//                       }
//                       return Container();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.small(
//         onPressed: () async {
//           await _moveToNewLocation();
//         },
//         backgroundColor: Colors.white,
//         child: const Icon(
//           Icons.location_on,
//           color: Colors.blue,
//         ),
//       ),
//     );
//   }
// }
