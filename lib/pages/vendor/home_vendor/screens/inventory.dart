import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rise/constants.dart';
import 'package:rise/widgets/rise_button.dart';
import 'package:sizer/sizer.dart';

class Inventory extends StatelessWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    void show(BuildContext ctx) {
      showModalBottomSheet(
          context: ctx,
          shape: const RoundedRectangleBorder(
              // <-- SEE HERE
              borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.0),
          )),
          builder: (context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Vendor's price (in naira)",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          // fontFamily: 'Chillax',
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                        style: TextStyle(
                          // fontFamily: 'Chillax',
                          color: blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                        softWrap: false,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Icon(Icons.store, size: 18),
                            ),
                            TextSpan(
                              text: " Sunlight Ventures",
                              // overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Icon(Icons.payments, size: 18),
                            ),
                            TextSpan(
                              text: " N217,899",
                              // overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 45),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: RiseButtonNew(
                            text: Text(
                              "Chat with Vendor",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            buttonColor: whiteColor,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pop(ctx);
                              // showOffer(context);
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: RiseButtonNew(
                            text: Text(
                              "Update Status",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            buttonColor: blackColor,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pop(ctx);
                              // showOffer(context);
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: RiseButtonNew(
                            text: Text(
                              "Dispute",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                // fontFamily: 'Chillax',
                                color: blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            buttonColor: secondaryColor.withOpacity(0.3),
                            textColor: whiteColor,
                            onPressed: () {
                              Navigator.pop(ctx);
                              // showOffer(context);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Inventory",
                style: TextStyle(
                  // fontFamily: 'Chillax',
                  color: blackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                ),
              ),
            ),
            // const SizedBox(
            //   height: 30,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     RiseButtonNew(
            //         text: Padding(
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: 60.0, vertical: 10),
            //           child: Text(
            //             "Items",
            //             style: TextStyle(
            //               // fontFamily: 'Chillax',
            //               color: blackColor,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 12.sp,
            //             ),
            //           ),
            //         ),
            //         buttonColor: grayColor.withOpacity(0.2),
            //         textColor: blackColor,
            //         onPressed: () {}),
            //     RiseButtonNew(
            //         text: Padding(
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: 60.0, vertical: 10),
            //           child: Text(
            //             "Services",
            //             style: TextStyle(
            //               // fontFamily: 'Chillax',
            //               color: blackColor,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 12.sp,
            //             ),
            //           ),
            //         ),
            //         buttonColor: grayColor.withOpacity(0.0),
            //         textColor: blackColor,
            //         onPressed: () {}),
            //   ],
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            // ListView(
            //   itemExtent: 120,
            //   physics: const BouncingScrollPhysics(),
            //   shrinkWrap: true,
            //   padding: const EdgeInsets.all(8),
            //   children: <Widget>[
            //     ListTile(
            //       onTap: (() => show(context)),
            //       title: Text(
            //         "Microwave Oven",
            //         style: TextStyle(
            //           // fontFamily: 'Chillax',
            //           color: blackColor,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 14.sp,
            //         ),
            //       ),
            //       subtitle: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const SizedBox(
            //             height: 10,
            //           ),
            //           RichText(
            //             text: TextSpan(
            //               children: [
            //                 const WidgetSpan(
            //                   child: Icon(Icons.store, size: 14),
            //                 ),
            //                 TextSpan(
            //                   text: " Sunlight Ventures",
            //                   // overflow: TextOverflow.ellipsis,
            //                   style: TextStyle(
            //                     // fontFamily: 'Chillax',
            //                     color: blackColor,
            //                     fontWeight: FontWeight.w500,
            //                     fontSize: 9.sp,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           RichText(
            //             text: TextSpan(
            //               children: [
            //                 const WidgetSpan(
            //                   child: Icon(Icons.store, size: 14),
            //                 ),
            //                 TextSpan(
            //                   text: " N127.899.02",
            //                   // overflow: TextOverflow.ellipsis,
            //                   style: TextStyle(
            //                     // fontFamily: 'Chillax',
            //                     color: blackColor,
            //                     fontWeight: FontWeight.w500,
            //                     fontSize: 9.sp,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           const SizedBox(height: 10),
            //           Text(
            //             "payment made",
            //             style: TextStyle(
            //               // fontFamily: 'Chillax',
            //               color: greenColor,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 12.sp,
            //             ),
            //           ),
            //           SizedBox(
            //             height: 10,
            //           )
            //         ],
            //       ),
            //       leading: Container(
            //           width: 80,
            //           height: 80,
            //           decoration: const BoxDecoration(
            //               image: DecorationImage(
            //                   image: AssetImage("assets/images/mic.png")))),
            //     )
            //   ],
            // ),
            // ListTile(
            //   title: Text(
            //     "Microwave Oven",
            //     style: TextStyle(
            //       // fontFamily: 'Chillax',
            //       color: blackColor,
            //       fontWeight: FontWeight.w500,
            //       fontSize: 14.sp,
            //     ),
            //   ),
            //   subtitle: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const SizedBox(
            //         height: 10,
            //       ),
            //       RichText(
            //         text: TextSpan(
            //           children: [
            //             const WidgetSpan(
            //               child: Icon(Icons.store, size: 14),
            //             ),
            //             TextSpan(
            //               text: " Sunlight Ventures",
            //               // overflow: TextOverflow.ellipsis,
            //               style: TextStyle(
            //                 // fontFamily: 'Chillax',
            //                 color: blackColor,
            //                 fontWeight: FontWeight.w500,
            //                 fontSize: 9.sp,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       RichText(
            //         text: TextSpan(
            //           children: [
            //             const WidgetSpan(
            //               child: Icon(Icons.store, size: 14),
            //             ),
            //             TextSpan(
            //               text: " N127.899.02",
            //               // overflow: TextOverflow.ellipsis,
            //               style: TextStyle(
            //                 // fontFamily: 'Chillax',
            //                 color: blackColor,
            //                 fontWeight: FontWeight.w500,
            //                 fontSize: 9.sp,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(height: 10),
            //       Text(
            //         "payment made",
            //         style: TextStyle(
            //           // fontFamily: 'Chillax',
            //           color: greenColor,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 12.sp,
            //         ),
            //       ),
            //       SizedBox(
            //         height: 10,
            //       )
            //     ],
            //   ),
            //   leading: Container(
            //       width: 80,
            //       height: 80,
            //       decoration: const BoxDecoration(
            //           image: DecorationImage(
            //               image: AssetImage("assets/images/mic.png")))),
            // )
          ],
        ),
      )),
    );
  }
}
