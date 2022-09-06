import 'dart:convert';
import 'dart:io';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'advertise4_screen.dart';

class AdvertiseScreen3 extends StatefulWidget {
  final File? singleImage;
  final DateTime? sDate;
  final DateTime? eDate;
  final String? secondValue;
  final String? title;
  final String? description;
  final String? boxValue;
  final String? total;
  final String? country;
  final String? city;
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const AdvertiseScreen3({
    Key? key,
    required this.email,
    required this.secondValue,
    required this.title,
    required this.description,
    required this.singleImage,
    required this.sDate,
    required this.eDate,
    required this.boxValue,
    required this.total,
    required this.country,
    required this.city,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<AdvertiseScreen3> createState() => _AdvertiseScreen3State();
}

class _AdvertiseScreen3State extends State<AdvertiseScreen3> {
  final storage = new FlutterSecureStorage();

  Future NextPressed() async {
    // await EasyLoading.show(
    //   status: 'Processing...',
    //   maskType: EasyLoadingMaskType.black,
    // );
    var uri = Uri.parse('${baseURL}create/ad');
    String? token = await storage.read(key: "token");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.MultipartRequest(
      'POST',
      uri,
    )..headers.addAll(headers);
    if (widget.singleImage != null) {
      request.files.add(
          await http.MultipartFile.fromPath('image', widget.singleImage!.path));
    }
    request.fields['country'] = widget.country!;
    request.fields['city'] = widget.city!;
    request.fields['box_type'] = widget.boxValue!;
    request.fields['start_date'] = "${widget.sDate}";
    request.fields['end_date'] = "${widget.eDate}";
    request.fields['amount'] = widget.total!;
    request.fields['description'] = widget.description!;
    request.fields['link_type'] = widget.secondValue!;
    request.fields['title'] = widget.title!;

    var response = await request.send();
    var responseS = await http.Response.fromStream(response);
    // final result = jsonDecode(responseS.body) as Map<String, dynamic>;
    final result = jsonDecode(responseS.body);
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: AdvertiseScreen4(
            active_id: widget.active_id,
            active_imgUrl: widget.active_imgUrl,
            active_name: widget.active_name,
            activeAcc: widget.activeAcc,
            freelancer_id: widget.freelancer_id,
            total: widget.total,
            country: widget.country,
            city: widget.city,
            sDate: widget.sDate,
            eDate: widget.eDate,
            id: "${result[0]["data"]["id"]}",
            email: widget.email,
          ),
        ),
        (route) => false,
      );
      _showTopFlash(
          "#60B781", "Your ad information has been saved successfully");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Your ad information has been saved successfully",
      //   ),
      // );
    } else if (response.statusCode == 422) {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Fill all the required fields");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Fill all the required fields",
      //   ),
      // );
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Error processing your request. Please try again",
      //   ),
      // );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (SafeArea(
      child: Stack(
        children: [
          Image.asset(
            "images/background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBarWidget(
              centerTitle: '',
              leading: true,
              active_id: widget.active_id,
              active_imgUrl: widget.active_imgUrl,
              email: widget.email,
              active_name: widget.active_name,
              activeAcc: widget.activeAcc,
              freelancer_id: widget.freelancer_id,
              nav: false,
              notifi: false,
              no: null,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Create Ad",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const Divider(
                          thickness: 1, // thickness of the line
                          indent:
                              20, // empty space to the leading edge of divider.
                          endIndent:
                              20, // empty space to the trailing edge of the divider.
                          color: Colors
                              .black, // The color to use when painting the line.
                          height: 20, // The divider's height extent.
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            "Expose your projects and tell people more about your services.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Text(
                              "Upload",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Preview",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Finish",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            child: widget.boxValue == "0"
                                ? Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          File(widget.singleImage!.path),
                                          fit: BoxFit.fill,
                                          height: 350,
                                          width: 350,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(255, 0, 0, 0),
                                                Color.fromARGB(216, 0, 0, 0),
                                                Color.fromARGB(26, 0, 0, 0),
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                            color: Colors.black54,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Business Name',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'About the ad About the ad',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          File(widget.singleImage!.path),
                                          fit: BoxFit.fill,
                                          height: 200,
                                          width: 350,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(255, 0, 0, 0),
                                                Color.fromARGB(216, 0, 0, 0),
                                                Color.fromARGB(26, 0, 0, 0),
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                            color: Colors.black54,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Business Name',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'About the ad About the ad',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                              padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                              highlightColor: Colors.grey[400],
                              color: HexColor("#60B781"),
                              splashColor: Colors.black12,
                              onPressed: () {},
                              child: Text(
                                "Back",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            FlatButton(
                              padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                              highlightColor: Colors.grey[400],
                              color: HexColor("#60B781"),
                              splashColor: Colors.black12,
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => AdvertiseScreen4(
                                //       sDate: widget.sDate,
                                //       eDate: widget.eDate,
                                //       total: widget.total,
                                //       country: widget.country,
                                //       city: widget.city,
                                //       active_id: widget.active_id,
                                //       active_imgUrl: widget.active_imgUrl,
                                //       active_name: widget.active_name,
                                //       activeAcc: widget.activeAcc,
                                //       freelancer_id: widget.freelancer_id,
                                //     ),
                                //   ),
                                // );
                                NextPressed();
                              },
                              child: Text(
                                "Finish",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: HexColor("#60B781"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: widget.activeAcc == "seeker"
                ? BottomNavWidgetSeeker(
                    active_id: widget.active_id,
                    email: widget.email,
                    active_imgUrl: widget.active_imgUrl,
                    active_name: widget.active_name,
                    activeAcc: widget.activeAcc,
                    freelancer_id: null,
                  )
                : BottomNavWidgetFreelancer(
                    active_id: widget.active_id,
                    active_imgUrl: widget.active_imgUrl,
                    active_name: widget.active_name,
                    activeAcc: widget.activeAcc,
                    freelancer_id: widget.freelancer_id,
                    email: widget.email,
                  ),
          )
        ],
      ),
    ));
  }

  void _showTopFlash(String color, String message) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 2),
      // persistent: false,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: HexColor(color),
          brightness: Brightness.light,
          boxShadows: [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: FlashBar(
            content: Text(message, style: TextStyle(color: Colors.white)),
            progressIndicatorBackgroundColor: Colors.white,
            progressIndicatorValueColor:
                AlwaysStoppedAnimation<Color>(HexColor(color)),
            showProgressIndicator: true,
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child: Text('DISMISS', style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }
}
