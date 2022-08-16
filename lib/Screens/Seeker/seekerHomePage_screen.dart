import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../Services/globals.dart';
import '../Ads/advertise1_screen.dart';
import '../Freelancer/categories_screen.dart';
import '../AppBar&Notification/appBarWidget.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'bottomNavWidgetSeeker.dart';
import 'drawerWidgetSeeker.dart';

class SeekerHomePageScreen extends StatefulWidget {
  const SeekerHomePageScreen({Key? key}) : super(key: key);

  @override
  State<SeekerHomePageScreen> createState() => _SeekerHomePageScreenState();
}

class _SeekerHomePageScreenState extends State<SeekerHomePageScreen> {
  String? active_imgUrl = "";
  String? activeAcc = "";
  String active_name = "";
  String email = "";
  late IO.Socket socket;
  String location = "";
  String about = "";
  int? active_id;
  int? res;
  int? freelancer_id;
  int _current = 0;
  String? file = null;
  List imgList = [];
  final imageSliders = <Widget>[];
  final imageSliders2 = <Widget>[];
  final storage = new FlutterSecureStorage();
  final CarouselController _controller = CarouselController();
  Future activeUser() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'user');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      socket.emit('connected-user', jsonData["data"]["id"]);
      if (this.mounted) {
        setState(() {
          email = jsonData["data"]["email"];
          active_id = jsonData["data"]["id"];
          if (active_imgUrl != null) {
            active_imgUrl = jsonData["data"]["seeker"]["image"];
          }
          if (jsonData["data"]["freelancer"] == null) {
            activeAcc = "seeker";
          }
          if (jsonData["data"]["seeker"]["type"] == "1") {
            active_name = jsonData["data"]["seeker"]["first_name"] +
                " " +
                jsonData["data"]["seeker"]["last_name"];
          } else {
            active_name = jsonData["data"]["seeker"]["business_name"];
          }
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future ads() async {
    var url = Uri.parse(baseURL + 'random/ads');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    res = response.statusCode;
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      if (this.mounted) {
        setState(() {
          // file = jsonData["data"]["thumbnail"];
          imgList = jsonData[0]["data"];
          for (var i = 0; i < jsonData[0]['data'].length; i++) {
            if (imgList[i]["box_type"] == 0) {
              imageSliders.add(
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "${baseURLImg}${imgList[i]["image"]}",
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
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 0, 0),
                              Color.fromARGB(216, 0, 0, 0),
                              Color.fromARGB(106, 0, 0, 0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          color: Colors.black54,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${imgList[i]["title"]}',
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
                                '${imgList[i]["description"]}',
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
                ),
              );
            } else if (imgList[i]["box_type"] == 1) {
              imageSliders2.add(
                SizedBox(
                  height: 200,
                  width: 350,
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          "${baseURLImg}${imgList[i]["image"]}",
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
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 0, 0, 0),
                                Color.fromARGB(216, 0, 0, 0),
                                Color.fromARGB(106, 0, 0, 0),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            color: Colors.black54,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${imgList[i]["title"]}',
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
                                  '${imgList[i]["description"]}',
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
                  ),
                ),
              );
            }
          }
        });
      }
      await EasyLoading.dismiss();
    } else if (response.statusCode == 422) {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "No Ads Found");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "No Ads Found",
      //   ),
      // );
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  @override
  void initState() {
    super.initState();
    socket = IO.io(
        '${chatURL}',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    activeUser();
    ads();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(
          centerTitle: '',
          email: email,
          nav: false,
          leading: false,
          active_id: active_id,
          active_imgUrl: active_imgUrl,
          active_name: active_name,
          activeAcc: activeAcc,
          freelancer_id: freelancer_id,
          notifi: false,
          no: null,
        ),
        drawer: DrawerWidgetSeeker(
          email: email,
          active_imgUrl: active_imgUrl,
          active_name: active_name,
          activeAcc: activeAcc,
          active_id: active_id,
          freelancer_id: null,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 100,
                  child: Image.asset(
                    'images/pikBlack.png',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: imageSliders.isEmpty && imageSliders2.isEmpty
                      ? Column(
                          children: const [
                            SizedBox(
                              height: 150,
                            ),
                            // Text(
                            //   "No ad's found.!",
                            //   style: TextStyle(
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // SizedBox(
                            // height: 80,
                            // ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: imageSliders.isEmpty
                                  ? SizedBox()
                                  : CarouselSlider(
                                      items: imageSliders,
                                      carouselController: _controller,
                                      options: CarouselOptions(
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          // aspectRatio: 1.3,
                                          height: 350,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          }),
                                    ),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: imageSliders.isEmpty && imageSliders2.isEmpty
                      ? null
                      : Row(
                          children: [
                            Expanded(
                              child: imageSliders2.isEmpty
                                  ? SizedBox()
                                  : CarouselSlider(
                                      items: imageSliders2,
                                      carouselController: _controller,
                                      options: CarouselOptions(
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          height: 200,
                                          // aspectRatio: 1.3,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          }),
                                    ),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoriesScreen(
                          activeAcc: activeAcc,
                          active_imgUrl: active_imgUrl,
                          email: email,
                          active_name: active_name,
                          active_id: active_id,
                          type: 'Freelancers',
                          freelancer_id: null,
                        ),
                      ),
                    );
                  },
                  color: HexColor("#60B781"),
                  child: Text(
                    'Find your freelancer now!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdvertiseScreen1(
                          active_id: active_id,
                          active_imgUrl: active_imgUrl,
                          email: email,
                          active_name: active_name,
                          activeAcc: activeAcc,
                          freelancer_id: freelancer_id,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'ADVERTISE',
                    style: TextStyle(
                      color: HexColor("#60B781"),
                    ),
                  ),
                ),
                Text('Create Your ad and optimize your results'),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavWidgetSeeker(
          active_id: active_id,
          email: email,
          activeAcc: activeAcc,
          active_imgUrl: active_imgUrl,
          active_name: active_name,
          freelancer_id: null,
        ),
      ),
    );
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
