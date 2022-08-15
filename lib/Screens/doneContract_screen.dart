import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import 'Seeker/seekerHomePage_screen.dart';

class DoneContractScreen extends StatefulWidget {
  final int? receiverID;
  final String active_name;
  final int? active_id;
  final int? freelancer_id;
  final String? active_imgUrl;
  final String? activeAcc;
  const DoneContractScreen({
    Key? key,
    required this.receiverID,
    required this.freelancer_id,
    required this.active_id,
    required this.active_name,
    required this.active_imgUrl,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<DoneContractScreen> createState() => _DoneContractScreenState();
}

class _DoneContractScreenState extends State<DoneContractScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: Container(
            margin: EdgeInsets.only(),
            height: 450.0,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Done!',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: HexColor("#60B781"),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: Image.asset(
                          'images/Group 533.png',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Image.asset(
                          'images/checkcircle.png',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Image.asset(
                          'images/Group 533.png',
                        ),
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
                    "Your details have been saved.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "You will get your contract once it is ready",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    "for your approval.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Edit your details from contract settings.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: HexColor("#60B781"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  highlightColor: HexColor("#60B781"),
                  color: HexColor("#60B781"),
                  splashColor: Colors.black12,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRightWithFade,
                        child: SeekerHomePageScreen(),
                      ),
                      (route) => true,
                    );
                  },
                  child: Text(
                    "Finish",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
