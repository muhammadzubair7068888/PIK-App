import 'dart:async';
import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../Services/auth_services.dart';
import '../ForgotPassword/forgotpassword_screen.dart';
import '../Freelancer/freelancerHomePage_screen.dart';
import '../Freelancer/freelancerPersonalInfo_screen.dart';
import '../Seeker/seekerHomePage_screen.dart';
import 'signUp_screen.dart';
import 'package:http/http.dart' as http;

import 'termConditionWidget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Timer? timer;
  bool firstVal = false;
  String remember = "0";
  bool em = false;
  bool ps = false;
  bool btnCheck = false;

  String _email = '';
  String _password = '';

  final storage = new FlutterSecureStorage();

  rememberMe() async {
    await storage.write(
      key: "remember",
      value: remember,
    );
  }

  loginPressed() async {
    rememberMe();
    if (_email.isNotEmpty && _password.isNotEmpty) {
      await EasyLoading.show(
        status: 'Processing...',
        maskType: EasyLoadingMaskType.black,
      );
      http.Response response = await AuthServices.login(_email, _password);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if ((responseMap["data"]["freelancer"] != null) &&
            (responseMap["data"]["seeker"] == null)) {
          await storage.write(
            key: "type",
            value: "freelancer",
          );
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
          await storage.write(
            key: "type",
            value: "seeker",
          );
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
          await storage.write(
            key: "type",
            value: "null",
          );
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
          await storage.write(
            key: "type",
            value: "seeker",
          );
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
          await storage.write(
            key: "type",
            value: "freelancer",
          );
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
        _showTopFlash("#60B781", "Signed in successfully");

        await storage.write(
          key: "token",
          value: responseMap["token"].toString(),
        );
        await storage.write(
          key: "userId",
          value: responseMap["data"]["id"].toString(),
        );
        await storage.write(
          key: "email",
          value: responseMap["data"]["email"].toString(),
        );
      } else {
        await EasyLoading.dismiss();
        _showTopFlash("#ff3333", responseMap.values.first);
      }
    } else {
      _showTopFlash("#ff3333", "Enter all required fields");
    }
  }

  Future check() async {
    if (em == true && ps == true) {
      setState(() {
        btnCheck = true;
      });
    } else {
      setState(() {
        btnCheck = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => check());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // var floatingActionButton;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: Image.asset(
                    'images/pik.png',
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 15.0,
                    bottom: 12.0,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/test.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50,
                        ),
                        child: FlatButton(
                          color: Colors.transparent,
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: HexColor("#60B781"),
                            ),
                          ),
                          onPressed: null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 50,
                        ),
                        child: FlatButton(
                          color: Colors.transparent,
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey[700],
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey[700],
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade700),
                          ),
                        ),
                        onChanged: (value) {
                          _email = value;
                          setState(() {
                            em = true;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey[700],
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade700),
                          ),
                        ),
                        onChanged: (value) {
                          _password = value;
                          setState(() {
                            ps = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 13.0,
                    right: 13.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.7,
                            child: Checkbox(
                              shape: CircleBorder(),
                              value: firstVal,
                              fillColor:
                                  MaterialStateProperty.all(Colors.white),
                              checkColor: HexColor("#60B781"),
                              activeColor: HexColor("#60B781"),
                              onChanged: (bool? value) {
                                setState(() {
                                  firstVal = value!;
                                  if (firstVal) {
                                    remember = "1";
                                  } else {
                                    remember = "0";
                                  }
                                });
                              },
                            ),
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRightWithFade,
                              child: ForgotPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  child: Text(
                    'Or sign in with your account',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {},
                          icon: Icon(
                            FontAwesomeIcons.google,
                            color: Colors.grey[800],
                            size: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {},
                          icon: Icon(
                            Icons.facebook,
                            color: Colors.grey[800],
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FlatButton(
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  highlightColor: btnCheck
                      ? HexColor("#60B781")
                      : Color.fromARGB(22, 158, 158, 158),
                  color: btnCheck
                      ? HexColor("#60B781")
                      : Color.fromARGB(22, 158, 158, 158),
                  splashColor: Colors.black12,
                  onPressed: btnCheck
                      ? () {
                          loginPressed();
                        }
                      : () {
                          null;
                        },
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const TermConditionWidget();
                      },
                    );
                  },
                  child: Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      color: HexColor("#60B781"),
                      fontSize: 11,
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
