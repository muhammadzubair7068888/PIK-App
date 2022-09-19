import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'accountSettingEdit_screen.dart';

class AccountSettingScreen extends StatefulWidget {
  final String? active_imgUrl;
  final int? active_id;
  final String? activeAcc;
  final String active_name;
  final int? freelancer_id;
  final String email;

  const AccountSettingScreen({
    Key? key,
    required this.freelancer_id,
    required this.email,
    required this.active_imgUrl,
    required this.active_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  String active_name = "";
  String mobile = "";
  String email = "";
  String password = "";
  String language = "";
  int? active_id;
  int? freelancer_id;
  final storage = new FlutterSecureStorage();
  Future activeUser() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'detail/user');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      print(jsonData);
      if (mounted) {
        setState(() {
          password = jsonData[0]["data"]["password"];
          active_name = jsonData[0]["data"]["username"];
          email = jsonData[0]["data"]["email"];
          if (widget.activeAcc == "freelancer") {
            language =
                jsonData[0]["data"]["freelancer"]["languages"][0]["name"];
            mobile = jsonData[0]["data"]["freelancer"]["phone_number"][0];
          } else if (widget.activeAcc == "seeker") {
            language = jsonData[0]["data"]["seeker"]["languages"][0]["name"];
            mobile = jsonData[0]["data"]["seeker"]["phone"][0].toString();
          }
        });
      }
      await EasyLoading.dismiss();
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  @override
  void initState() {
    activeUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: HexColor("#333232"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          centerTitle: true,
          title: const Text("Account Settings"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountSettingScreenEdit(
                      active_name: active_name,
                      email: email,
                      mobile: mobile,
                      language: language,
                      password: password,
                      activeAcc: widget.activeAcc,
                      active_id: widget.active_id,
                      active_imgUrl: widget.active_imgUrl,
                      freelancer_id: widget.freelancer_id,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.edit,
                color: HexColor("#60B781"),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            ListTile(
              tileColor: Colors.white,
              title: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Username",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Text(
                  active_name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              tileColor: Colors.white,
              title: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Text(
                  email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              tileColor: Colors.white,
              title: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Mobile",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Text(
                  "${mobile}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const ListTile(
              tileColor: Colors.white,
              title: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Text(
                  "********",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              tileColor: Colors.white,
              title: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Language",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Text(
                  language,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
        bottomNavigationBar: widget.activeAcc == "seeker"
            ? BottomNavWidgetSeeker(
                active_id: widget.active_id,
                email: widget.email,
                activeAcc: widget.activeAcc,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
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
          boxShadows: const [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: FlashBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
            progressIndicatorBackgroundColor: Colors.white,
            progressIndicatorValueColor:
                AlwaysStoppedAnimation<Color>(HexColor(color)),
            showProgressIndicator: true,
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child: const Text('DISMISS', style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }
}
