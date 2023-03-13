import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/user/home/screens/customer_market_place.dart';
import 'package:rise/pages/vendor/home_vendor/screens/inventory.dart';

import '../../user/customer_profile/customer_profile_page.dart';
import 'screens/vendor_listing.dart';
import 'screens/vendor_home.dart';

class HomeNavScreenVendor extends StatefulWidget {
  const HomeNavScreenVendor({Key? key}) : super(key: key);

  @override
  HomeNavScreenVendorState createState() => HomeNavScreenVendorState();
}

class HomeNavScreenVendorState extends State<HomeNavScreenVendor> {
  int selectedIndex = 0;

  var index = 0;

  @override
  initState() {
    super.initState();
  }

  List<Widget> listOfScreens = <Widget>[
    const VendorHomeScreen(),
    const VendorListing(),
    const CustomerMarketPlace(),
    const Inventory(),
    const CustomerProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: listOfScreens.elementAt(selectedIndex),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                child: buildBottomNavigation()))
        );
  }

  Widget buildBottomNavigation() {
    return BottomNavyBar(
        showElevation: false,
        backgroundColor: blackColor,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              activeColor: whiteColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              icon: Icon(Icons.list),
              title: Text("Listings"),
              activeColor: whiteColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              icon: Icon(Icons.storefront),
              title: Text("Marketplace"),
              activeColor: whiteColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              icon: Icon(Icons.bookmark_added),
              title: Text("Orders"),
              activeColor: whiteColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              icon: Icon(Icons.person_pin),
              title: Text("Profile"),
              activeColor: whiteColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center),
        ],
        selectedIndex: index,
        onItemSelected: (index) => setState(() {
              this.index = index;
              this.selectedIndex = index;
            }));
  }
}
