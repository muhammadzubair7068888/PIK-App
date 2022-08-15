import 'dart:async';
import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/auth_services.dart';
import 'emailConfiguration_screen.dart';
import 'signIn_screen.dart';
import 'termConditionWidget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Timer? timer;
  bool us = false;
  bool em = false;
  bool ps = false;
  bool cps = false;
  bool btnCheck = false;

  bool remember_me = false;

  bool _termsAndConditions = false;
  String _username = '';
  String _email = '';
  String _password = '';
  String _passwordConfirmation = '';
  final storage = new FlutterSecureStorage();

  signUpPressed() async {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    if (emailValid) {
      await EasyLoading.show(
        status: 'Processing...',
        maskType: EasyLoadingMaskType.black,
      );
      http.Response response = await AuthServices.signUp(_username, _email,
          _password, _passwordConfirmation, _termsAndConditions);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 201 && responseMap["status"] == "success") {
        await EasyLoading.dismiss();
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: EmailConfigurationScreen(
              email: _email,
            ),
          ),
          (route) => false,
        );
        _showTopFlash("#60B781", responseMap["message"]);

        await storage.write(key: "token", value: responseMap["token"]);
      } else if (response.statusCode == 422) {
        await EasyLoading.dismiss();
        _showTopFlash("#ff3333", "Provided data is not valid");
      } else {
        await EasyLoading.dismiss();
        _showTopFlash("#ff3333", "Server Error");
      }
    } else {
      _showTopFlash("#ff3333", "Email is not valid");
    }
  }

  Future checking() async {
    if (us == true &&
        em == true &&
        ps == true &&
        cps == true &&
        _termsAndConditions == true) {
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
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checking());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
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
                  height: 30,
                ),
                SizedBox(
                  width: 111,
                  height: 70,
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
                      image: AssetImage('images/bar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                        ),
                        child: FlatButton(
                          color: Colors.transparent,
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey[700],
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 40,
                        ),
                        child: FlatButton(
                          color: Colors.transparent,
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: HexColor("#60B781"),
                            ),
                          ),
                          onPressed: () {},
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
                          hintText: 'User Name',
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade700),
                          ),
                        ),
                        onChanged: (value) {
                          _username = value;
                          setState(() {
                            us = true;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Email Address',
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
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
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
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade700),
                          ),
                        ),
                        onChanged: (value) {
                          _passwordConfirmation = value;
                          setState(() {
                            cps = true;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 5.0),
                //   child: SizedBox(
                //     height: 30,
                //     child: Row(
                //       children: <Widget>[
                //         Transform.scale(
                //           scale: 0.7,
                //           child: Checkbox(
                //             shape: CircleBorder(),
                //             value: remember_me,
                //             fillColor: MaterialStateProperty.all(Colors.white),
                //             checkColor: HexColor("#60B781"),
                //             activeColor: HexColor("#60B781"),
                //             onChanged: (bool? value) {
                //               setState(() {
                //                 remember_me = value!;
                //               });
                //             },
                //           ),
                //         ),
                //         Text(
                //           'Remember me',
                //           style: TextStyle(
                //             color: Colors.grey[700],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        Transform.scale(
                          scale: 0.7,
                          child: Checkbox(
                            shape: CircleBorder(),
                            value: _termsAndConditions,
                            fillColor: MaterialStateProperty.all(Colors.white),
                            checkColor: HexColor("#60B781"),
                            activeColor: HexColor("#60B781"),
                            onChanged: (bool? value) {
                              setState(() {
                                _termsAndConditions = value!;
                              });
                            },
                          ),
                        ),
                        Text(
                          'I Agree to the terms and conditions',
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
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
                          signUpPressed();
                        }
                      : () {
                          null;
                        },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Already a User?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                            child: Text(
                              'Click here',
                              style: TextStyle(
                                color: HexColor("#60B781"),
                                fontSize: 13,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.leftToRightWithFade,
                                  child: SignInScreen(),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return TermConditionWidget();
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
