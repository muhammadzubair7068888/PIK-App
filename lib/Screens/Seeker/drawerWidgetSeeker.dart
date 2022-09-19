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
import '../ContractOfBoth/contractsHistory_screen.dart';
import '../Freelancer/freelancerHomePage_screen.dart';
import '../Freelancer/switchFreelancerPersonalInfo_screen.dart';
import '../SeekerProject/seekerProjectList_screen.dart';
import '../Settings/contactUs_screen.dart';
import '../Settings/settings_screen.dart';
import 'seekerProfile_screen.dart';

class DrawerWidgetSeeker extends StatefulWidget {
  final String? active_imgUrl;
  final int? active_id;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const DrawerWidgetSeeker({
    Key? key,
    required this.email,
    required this.freelancer_id,
    required this.active_imgUrl,
    required this.active_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<DrawerWidgetSeeker> createState() => _DrawerWidgetSeekerState();
}

class _DrawerWidgetSeekerState extends State<DrawerWidgetSeeker> {
  final storage = new FlutterSecureStorage();
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
    }
  }

  Future close() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse('${baseURL}account/closed');
    String? token = await storage.read(key: "token");
    http.Response response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      await storage.deleteAll();
      await EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: const SplashScreen(),
        ),
        (route) => false,
      );
      _showTopFlash("#60B781", "Your account has been closed");
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
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
      if ((jsonData["data"]["freelancer"] == null) &&
          (jsonData["data"]["seeker"] != null)) {
        await EasyLoading.dismiss();
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: SwitchFreelancerPersonalInfoScreen(
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
            child: FreelancerHomePageScreen(),
          ),
        );
      }
      // await EasyLoading.dismiss();
    } else {
      // await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
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
            Container(
              child: Row(
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
            ),
            Container(
              // ignore: unnecessary_null_comparison
              child: widget.active_imgUrl == null
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
                    builder: (context) => SeekerProfileScreen(
                      active_id: widget.active_id,
                      activeAcc: widget.activeAcc,
                      email: widget.email,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      search_id: null,
                      freelancer_id: null,
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
                    builder: (context) => SeekerProjectListScreen(
                      active_id: widget.active_id,
                      email: widget.email,
                      activeAcc: widget.activeAcc,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      freelancer_id: null,
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
                      email: widget.email,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      freelancer_id: null,
                      navi: false,
                      receiverID: null,
                    ),
                  ),
                );
              },
              title: const Text(
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
                      active_id: widget.active_id,
                      email: widget.email,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      activeAcc: widget.activeAcc,
                      freelancer_id: null,
                    ),
                  ),
                );
              },
              title: const Text(
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
                    builder: (context) => ContactUs(
                      active_id: widget.active_id,
                      email: widget.email,
                      activeAcc: widget.activeAcc,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      freelancer_id: null,
                    ),
                  ),
                );
              },
              title: const Text(
                'Contact Us',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.contact_support,
                color: HexColor("#60B781"),
                size: 30.0,
              ),
            ),
            ListTile(
              onTap: () {
                close();
              },
              title: const Text(
                'Close Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              leading: Icon(
                Icons.close,
                color: HexColor("#60B781"),
                size: 30.0,
              ),
            ),
            ListTile(
              onTap: () {
                logout();
              },
              title: const Text(
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
            const SizedBox(
              height: 15.0,
            ),
            Column(
              children: [
                TextButton(
                  onPressed: widget.activeAcc == 'seeker'
                      ? () {
                          switchAccount();
                        }
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const FreelancerHomePageScreen(),
                            ),
                          );
                        },
                  child: widget.activeAcc == 'seeker'
                      ? Text(
                          "Create a freelancer's account",
                          style: TextStyle(
                            color: HexColor("#60B781"),
                          ),
                        )
                      : Text(
                          "Switch to freelancer's account",
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
