import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rise/constants.dart';
import 'package:rise/pages/user/home/screens/orders.dart';
import 'package:rise/pages/user/home/screens/customer_home.dart';

import '../customer_profile/customer_profile_page.dart';
import 'screens/customer_market_place.dart';

class HomeNavScreen extends StatefulWidget {
  const HomeNavScreen({Key? key}) : super(key: key);

  @override
  HomeNavScreenState createState() => HomeNavScreenState();
}

class HomeNavScreenState extends State<HomeNavScreen> {
  int selectedIndex = 0;

  @override
  initState() {
    super.initState();
  }

  int index = 0;

  List<Widget> listOfScreens = <Widget>[
    const CustomerHomeScreen(),
    const CustomerMarketPlace(),
    const CustomerOrders(),
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
          )),
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
              icon: Icon(Icons.storefront),
              title: Text("Market"),
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
