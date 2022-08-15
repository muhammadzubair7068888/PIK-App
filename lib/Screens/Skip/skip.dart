import 'package:flutter/material.dart';
import 'package:Pik/Screens/Skip/skipSignInWidget.dart';
import 'package:hexcolor/hexcolor.dart';

class SkipScreen extends StatefulWidget {
  const SkipScreen({Key? key}) : super(key: key);

  @override
  _SkipScreenState createState() => _SkipScreenState();
}

class _SkipScreenState extends State<SkipScreen> {
  String catOrFie = "Category";
  Color white = Colors.white;
  Color white24 = Colors.white24;
  double size14 = 10;
  double size12 = 8;
  String one = 'graphicdesing';
  String two = 'motiondes';
  String three = 'photovid';
  String four = 'int';
  String five = 'anim';
  String six = 'web';
  String seven = 'ui';
  String eight = 'voiceover';
  String nine = 'arts';

  String oneName = 'Graphic Design';
  String twoName = 'Motion Graphics';
  String threeName = 'Photo/Videography';
  String fourName = 'Interior Design';
  String fiveName = 'Animation';
  String sixName = 'Web Design';
  String sevenName = 'UI/UX Design';
  String eightName = 'Voice Over';
  String nineName = 'Visual Arts';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
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
                  height: 70,
                  width: 111,
                  child: Image.asset('images/pik.png'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Pik',
                        style: TextStyle(
                          color: HexColor("#60B781"),
                          fontSize: 17.0,
                        ),
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        'a $catOrFie',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowDialogWidget();
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.grey[850],
                            highlightColor: HexColor("#60B781"),
                            padding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              // horizontal: 20.0,
                            ),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                'images/${one}.png',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            oneName,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowDialogWidget();
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.grey[850],
                            highlightColor: HexColor("#60B781"),
                            padding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              // horizontal: 20.0,
                            ),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                'images/${two}.png',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            twoName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowDialogWidget();
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.grey[850],
                            highlightColor: HexColor("#60B781"),
                            padding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              // horizontal: 20.0,
                            ),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                'images/${three}.png',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            threeName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // ///Interior Design//////
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowDialogWidget();
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.grey[850],
                            highlightColor: HexColor("#60B781"),
                            padding: EdgeInsets.symmetric(
                              vertical: 18.0,
                              // horizontal: 20.0,
                            ),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                'images/${four}.png',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            fourName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowDialogWidget();
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.grey[850],
                            highlightColor: HexColor("#60B781"),
                            padding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              // horizontal: 20.0,
                            ),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                'images/${five}.png',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            fiveName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowDialogWidget();
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.grey[850],
                            highlightColor: HexColor("#60B781"),
                            padding: EdgeInsets.symmetric(
                              vertical: 17.0,
                              // horizontal: 20.0,
                            ),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                'images/${six}.png',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            sixName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowDialogWidget();
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.grey[850],
                            highlightColor: HexColor("#60B781"),
                            padding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              // horizontal: 20.0,
                            ),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                'images/${seven}.png',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            sevenName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowDialogWidget();
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.grey[850],
                            highlightColor: HexColor("#60B781"),
                            padding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              // horizontal: 20.0,
                            ),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset(
                                'images/${eight}.png',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            eightName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      ///////Visual Arts/////////
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowDialogWidget();
                                },
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.grey[850],
                            highlightColor: HexColor("#60B781"),
                            padding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              // horizontal: 20.0,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset(
                                    'images/${nine}.png',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            nineName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Wrap(
                  children: [
                    SizedBox(
                      width: 24,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            catOrFie = "Category";
                            white = Colors.white;
                            white24 = Colors.white24;
                            size14 = 10;
                            size12 = 8;
                            one = 'graphicdesing';
                            two = 'motiondes';
                            three = 'photovid';
                            four = 'int';
                            five = 'anim';
                            six = 'web';
                            seven = 'ui';
                            eight = 'voiceover';
                            nine = 'arts';
                            oneName = 'Graphic Design';
                            twoName = 'Motion Graphics';
                            threeName = 'Photo/Videography';
                            fourName = 'Interior Design';
                            fiveName = 'Animation';
                            sixName = 'Web Design';
                            sevenName = 'UI/UX Design';
                            eightName = 'Voice Over';
                            nineName = 'Visual Arts';
                          });
                        },
                        icon: Icon(Icons.circle),
                        iconSize: size14,
                        color: white,
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            catOrFie = "Field";
                            white24 = Colors.white;
                            white = Colors.white24;
                            size14 = 8;
                            size12 = 10;
                            one = 't';
                            two = 'f';
                            three = 'm';
                            four = 'c';
                            five = 'med';
                            six = 'entr';
                            seven = 'govrn';
                            eight = 'char';
                            nine = 'trsm';
                            oneName = 'Technology';
                            twoName = 'Food&Beverages';
                            threeName = 'Medical';
                            fourName = 'Commercial';
                            fiveName = 'Media';
                            sixName = 'Entertainment';
                            sevenName = 'Government';
                            eightName = 'Charity';
                            nineName = 'Tourism';
                          });
                        },
                        icon: Icon(Icons.circle),
                        iconSize: size12,
                        color: white24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
