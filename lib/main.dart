import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'Screens/Freelancer/freelancerHomePage_screen.dart';
import 'Screens/Freelancer/freelancerPersonalInfo_screen.dart';
import 'Screens/Seeker/seekerHomePage_screen.dart';
import 'Screens/SignUp_SignIn/signIn_screen.dart';
import 'Screens/SignUp_SignIn/signUp_screen.dart';
import 'Screens/Skip/skip.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Colors.white,
        errorColor: Colors.red,
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: HexColor("#60B781")),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      builder: EasyLoading.init(),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = true;
  bool _visible2 = false;
  bool _visible3 = false;
  bool _visible4 = false;
  final storage = const FlutterSecureStorage();
  String? token;
  String? remember;
  Future check() async {
    // String? token = await storage.read(key: "token");
    String? remember = await storage.read(key: "remember");
    String? type = await storage.read(key: "type");
    String? email = await storage.read(key: "email");
    if (remember == "1") {
      if (type == "freelancer") {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: FreelancerHomePageScreen(),
          ),
          (route) => false,
        );
      } else if (type == "seeker") {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: SeekerHomePageScreen(),
          ),
          (route) => false,
        );
      } else if (type == "null") {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: FreelancerPersonalInfoScreen(
              email: email!,
            ),
          ),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LandingScreen(),
          ),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LandingScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      if (this.mounted) {
        setState(() {
          _visible = false;
          _visible2 = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (this.mounted) {
        setState(() {
          _visible2 = false;
          _visible3 = true;
        });
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (this.mounted) {
        setState(() {
          _visible3 = false;
          _visible4 = true;
        });
      }
    });

    Timer(
      Duration(seconds: 4),
      check,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
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
                      Image.asset(
                        'images/pik.png',
                        height: 110,
                        width: 173,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Visibility(
                        visible: _visible,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'images/load.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _visible2,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _visible3,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _visible4,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load2.png',
                                height: 16,
                                width: 15,
                              ),
                              Image.asset(
                                'images/load.png',
                                height: 16,
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                Image.asset(
                  'images/pik.png',
                  height: 110,
                  width: 173,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Container(
                  // padding: EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        color: Colors.transparent,
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.topToBottom,
                              child: SignInScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        child: Text(
                          '|',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      FlatButton(
                        color: Colors.transparent,
                        // highlightColor: HexColor("#60B781"),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.topToBottom,
                              child: SignUpScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Sign Up with',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
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
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            child: SkipScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.grey[700], fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
