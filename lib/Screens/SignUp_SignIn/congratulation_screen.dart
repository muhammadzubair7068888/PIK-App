import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import 'signIn_screen.dart';

class CongratulationScreen extends StatefulWidget {
  const CongratulationScreen({Key? key}) : super(key: key);

  @override
  _CongratulationScreenState createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  final storage = new FlutterSecureStorage();
  Future destroyStorage() async {
    await storage.deleteAll();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      PageTransition(
        type: PageTransitionType.leftToRightWithFade,
        child: const SignInScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background.png"),
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
                    height: 440.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Congratulations!',
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                  top: 40,
                                  left: 30,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/checkcircle.png',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 25,
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
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            "Don't forget that you can always edit your personal information and prefrence by tapping on the settings icon.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        TextButton.icon(
                          icon: Icon(
                            Icons.send,
                            size: 45,
                            color: HexColor("#60B781"),
                          ),
                          label: Text(
                            'GO',
                            style: TextStyle(
                              fontSize: 30,
                              color: HexColor("#60B781"),
                            ),
                          ),
                          onPressed: () {
                            destroyStorage();
                          },
                        ),
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
}
