import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/user/home/screens/customer_home.dart';
import 'package:rise/pages/artisan/home_artisan/screens/artisan_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../user/home/screens/customer_market_place.dart';
import '../artisan_tasks/artisan_task.dart';
import '../../user/customer_profile/customer_profile_page.dart';
import 'screens/artisan_listings.dart';

class HomeNavScreenArtisan extends StatefulWidget {
  const HomeNavScreenArtisan({Key? key}) : super(key: key);

  @override
  HomeNavScreenArtisanState createState() => HomeNavScreenArtisanState();
}

class HomeNavScreenArtisanState extends State<HomeNavScreenArtisan> {
  int selectedIndex = 0;

  var index = 0;

  @override
  initState() {
    super.initState();
  }

  List<Widget> listOfScreens = <Widget>[
    const ArtisanHomeScreen(),
    const ArtisanListing(),
    const CustomerMarketPlace(),
    const ArtisanTask(),
    const CustomerProfilePage(),
  ];

  var tap = 0;

  @override
  Widget build(BuildContext context) {
    DateTime pre_backpress = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          //show snackbar
          const snack = SnackBar(
            backgroundColor: blackColor,
            content: Text('Press Back button again to exit Rise'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {

          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
          return true;
        }
      },
      child: Scaffold(
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
            child: buildBottomNavigation(),
          ),
        ),
      ),
    );
  }

  Widget buildBottomNavigation() {
    return BottomNavyBar(
        showElevation: false,
        backgroundColor: blackColor,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text(
                "Home",
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              activeColor: whiteColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              icon: Icon(Icons.list),
              title: Text(
                "Listings",
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              activeColor: whiteColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              icon: Icon(Icons.storefront),
              title: Text(
                "Marketplace",
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              activeColor: whiteColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              icon: Icon(Icons.bookmark_added),
              title: Text(
                "Tasks",
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              activeColor: whiteColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center),
          BottomNavyBarItem(
              icon: Icon(Icons.person_pin),
              title: Text(
                "Profile",
                style: GoogleFonts.poppins(fontSize: 12),
              ),
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
