import 'dart:async';
import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import 'congratulation_screen.dart';

class EmailConfigurationScreen extends StatefulWidget {
  final String email;
  const EmailConfigurationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _EmailConfigurationScreenState createState() =>
      _EmailConfigurationScreenState();
}

class _EmailConfigurationScreenState extends State<EmailConfigurationScreen> {
  Timer? timer;
  String? _status;
  final storage = new FlutterSecureStorage();

  Future getFreelancerInfo() async {
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
      if (this.mounted) {
        setState(() {
          _status = jsonData["data"]["email_verified_at"];
        });
      }
      if (_status != null) {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: CongratulationScreen(),
          ),
          (route) => false,
        );
      }
    } else {
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(Duration(seconds: 2), (Timer t) => getFreelancerInfo());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: Image.asset(
                      'images/pik.png',
                    ),
                  ),
                  SizedBox(
                    height: 45.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    height: 500.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 25.0,
                          ),
                        ),
                        Text(
                          'Thank You',
                          style: TextStyle(
                            fontSize: 40.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'for signing up',
                              style: TextStyle(
                                fontSize: 25.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                  top: 60,
                                  left: 30,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/email.png',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Image.asset(
                                'images/send.png',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Text(
                          'Confirm your email address',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'We sent a confirmation email to:',
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.email,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Check your email and click on the \n confirmation link to continue.',
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => CongratulationScreen(),
                        //       ),
                        //     );
                        //   },
                        //   child: Text(
                        //     'Resend email',
                        //     style: TextStyle(
                        //       color: HexColor("#60B781"),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
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
