import 'dart:convert';
import 'package:flash/flash.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import '../../Services/globals.dart';
import '../../main.dart';
import '../Ads/advertise1_screen.dart';
import '../FreelancerPortfolio/freelancerPortfolio_screen.dart';
import '../ProjectByCategories/myProject_list.dart';
import '../ContractOfBoth/contractsHistory_screen.dart';
import '../Seeker/seekerHomePage_screen.dart';
import '../Seeker/switchSeekerIndivPersonalInfo_screen.dart';
import '../Settings/help&Support_screen.dart';
import '../Settings/settings_screen.dart';
import 'freelancerProfile_screen.dart';

class DrawerWidgetFreelancer extends StatefulWidget {
  final String? active_imgUrl;
  final String location;
  final String? activeAcc;
  final int? active_id;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const DrawerWidgetFreelancer({
    Key? key,
    required this.active_imgUrl,
    required this.location,
    required this.active_id,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
    required this.email,
  }) : super(key: key);

  @override
  State<DrawerWidgetFreelancer> createState() => _DrawerWidgetFreelancerState();
}

class _DrawerWidgetFreelancerState extends State<DrawerWidgetFreelancer> {
  final storage = const FlutterSecureStorage();
  Future logout() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'logout');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      await storage.deleteAll();
      await EasyLoading.dismiss();
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: SplashScreen(),
        ),
        (route) => false,
      );
      _showTopFlash("#60B781", "Successfully signed out");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Successfully signed out",
      //   ),
      // );
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Server Error",
      //   ),
      // );
    }
  }

  Future switchAccount() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'switch-account');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      if ((jsonData["data"]["freelancer"] != null) &&
          (jsonData["data"]["seeker"] == null)) {
        await EasyLoading.dismiss();
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: SwitchSeekerIndivPersonalInfoScreen(
              email: widget.email,
            ),
          ),
        );
      } else if ((jsonData["data"]["freelancer"] != null) &&
          (jsonData["data"]["seeker"] != null)) {
        await EasyLoading.dismiss();
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: SeekerHomePageScreen(),
          ),
        );
      }
      // await EasyLoading.dismiss();
    } else {
      // await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Server Error",
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: HexColor("#333232"),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),
            Container(
              // ignore: unnecessary_null_comparison
              child: widget.active_imgUrl == null || widget.active_imgUrl == ""
                  ? CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.grey[300],
                    )
                  : CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          NetworkImage("${baseURLImg}${widget.active_imgUrl}"),
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.active_name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: HexColor("#60B781"),
                ),
                Text(
                  '4.0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  Icons.check_box_rounded,
                  color: HexColor("#60B781"),
                ),
                Text(
                  '3 Applies',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FreelancerProfileScreen(
                      activeAcc: widget.activeAcc,
                      active_id: widget.active_id,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      search_id: null,
                      freelancer_id: widget.freelancer_id,
                      email: widget.email,
                    ),
                  ),
                );
              },
              title: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.account_circle,
                color: HexColor("#60B781"),
                size: 30.0,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FreelancerPortfolioScreen(
                      activeAcc: widget.activeAcc,
                      active_id: widget.active_id,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      location: widget.location,
                      catName: "",
                      search_id: null,
                      search_name: '',
                      freelancer_id: widget.freelancer_id,
                      fromUpload: '',
                      email: widget.email,
                    ),
                  ),
                );
              },
              title: Text(
                'Portfolio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.business_center,
                color: HexColor("#60B781"),
                size: 30.0,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => My_Projects_List(
                      email: widget.email,
                      activeAcc: widget.activeAcc,
                      active_id: widget.active_id,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      freelancer_id: widget.freelancer_id,
                      receiverID: null,
                      seekProj_id: null,
                      type: '',
                    ),
                  ),
                );
              },
              title: Text(
                'My Projects',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.check_box,
                color: HexColor("#60B781"),
                size: 30.0,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContractsHistoryScreen(
                      active_id: widget.active_id,
                      activeAcc: widget.activeAcc,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      freelancer_id: null,
                      receiverID: null,
                      email: widget.email,
                      navi: false,
                    ),
                  ),
                );
              },
              title: Text(
                'My Contracts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.border_color_rounded,
                color: HexColor("#60B781"),
                size: 30.0,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingScreen(
                      email: widget.email,
                      active_id: widget.active_id,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      activeAcc: widget.activeAcc,
                    ),
                  ),
                );
              },
              title: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.settings,
                color: HexColor("#60B781"),
                size: 30.0,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpSupportScreen(),
                  ),
                );
              },
              title: Text(
                'Help',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.help,
                color: HexColor("#60B781"),
                size: 30.0,
              ),
            ),
            ListTile(
              onTap: () {
                logout();
              },
              title: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.logout,
                color: HexColor("#60B781"),
                size: 30.0,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Want more exposure?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdvertiseScreen1(
                              active_id: widget.active_id,
                              active_imgUrl: widget.active_imgUrl,
                              active_name: widget.active_name,
                              activeAcc: widget.activeAcc,
                              email: widget.email,
                              freelancer_id: widget.freelancer_id,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Advertise',
                        style: TextStyle(
                          color: HexColor("#60B781"),
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Text(
                      'NOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: widget.activeAcc == 'freelancer'
                      ? () {
                          switchAccount();
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeekerHomePageScreen(),
                            ),
                          );
                        },
                  child: widget.activeAcc == 'freelancer'
                      ? Text(
                          "Create a seeker's account",
                          style: TextStyle(
                            color: HexColor("#60B781"),
                          ),
                        )
                      : Text(
                          "Switch to seeker's account",
                          style: TextStyle(
                            color: HexColor("#60B781"),
                          ),
                        ),
                ),
              ],
            ),
          ],
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
