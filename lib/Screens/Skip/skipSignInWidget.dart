import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/auth_services.dart';
import '../Freelancer/freelancerHomePage_screen.dart';
import '../Freelancer/freelancerPersonalInfo_screen.dart';
import '../Seeker/seekerHomePage_screen.dart';
import '../SignUp_SignIn/signUp_screen.dart';

class ShowDialogWidget extends StatefulWidget {
  const ShowDialogWidget({Key? key}) : super(key: key);

  @override
  State<ShowDialogWidget> createState() => _ShowDialogWidgetState();
}

class _ShowDialogWidgetState extends State<ShowDialogWidget> {
  final storage = new FlutterSecureStorage();
  String _email = '';
  String _password = '';

  loginPressed() async {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      await EasyLoading.show(
        status: 'Processing...',
        maskType: EasyLoadingMaskType.black,
      );
      http.Response response = await AuthServices.login(_email, _password);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200 && responseMap["status"] == "success") {
        if ((responseMap["data"]["freelancer"] != null) &&
            (responseMap["data"]["seeker"] == null)) {
          await EasyLoading.dismiss();
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.leftToRightWithFade,
              child: FreelancerHomePageScreen(),
            ),
            (route) => false,
          );
        } else if ((responseMap["data"]["freelancer"] == null) &&
            (responseMap["data"]["seeker"] != null)) {
          await EasyLoading.dismiss();
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.leftToRightWithFade,
              child: SeekerHomePageScreen(),
            ),
            (route) => false,
          );
        } else if ((responseMap["data"]["freelancer"] == null) &&
            (responseMap["data"]["seeker"] == null)) {
          await EasyLoading.dismiss();
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.leftToRightWithFade,
              child: FreelancerPersonalInfoScreen(
                email: responseMap["data"]["email"],
              ),
            ),
            (route) => false,
          );
        } else if ((responseMap["data"]["freelancer"] != null) &&
            (responseMap["data"]["seeker"] != null &&
                responseMap["data"]["last_active_account"] == "seeker")) {
          await EasyLoading.dismiss();
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.leftToRightWithFade,
              child: SeekerHomePageScreen(),
            ),
            (route) => false,
          );
        } else if ((responseMap["data"]["freelancer"] != null) &&
            (responseMap["data"]["seeker"] != null &&
                responseMap["data"]["last_active_account"] == "freelancer")) {
          await EasyLoading.dismiss();
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.leftToRightWithFade,
              child: FreelancerHomePageScreen(),
            ),
            (route) => false,
          );
        }
        _showTopFlash("#60B781", responseMap["message"]);

        await storage.write(key: "token", value: responseMap["token"]);
        await storage.write(
            key: "userId", value: jsonEncode(responseMap["data"]["id"]));
      } else if (response.statusCode == 203) {
        await EasyLoading.dismiss();
        _showTopFlash("#ff3333", responseMap["message"]);
      } else {
        await EasyLoading.dismiss();
        _showTopFlash("#ff3333", "Server Error");
      }
    } else {
      _showTopFlash("#ff3333", "Enter all required fields correctly");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: Colors.white,
      scrollable: true,
      title: Container(
        margin: EdgeInsets.only(
          left: 5,
          right: 1,
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 25,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 40, color: HexColor("#60B781")),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "To start exploring - ",
                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "already a user sign in",
                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 30.0,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                  labelText: 'Enter Email',
                ),
                onChanged: (value) {
                  _email = value;
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 30.0,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  labelText: 'Enter Password',
                ),
                onChanged: (value) {
                  _password = value;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              color: HexColor("#60B781"),
              splashColor: Colors.white,
              onPressed: () {
                loginPressed();
              },
              child: Text(
                "Let's go!",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Don't have an account?",
              style: TextStyle(fontSize: 15),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ),
                );
              },
              child: Text(
                'Sign up',
                style: TextStyle(color: HexColor("#60B781")),
              ),
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
