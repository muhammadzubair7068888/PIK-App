import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../FreelancerByCategories/freelancerByCategories.dart';
import '../ProjectByCategories/projectList_screen.dart';
import '../Freelancer/drawerWidgetFreelancer.dart';
import '../Seeker/drawerWidgetSeeker.dart';
import 'allSeeker_screen.dart';
import 'seekerByFields_screen.dart';

class FieldsToSearchScreen extends StatefulWidget {
  final String? active_imgUrl;
  final String? activeAcc;
  final int? active_id;
  final int? freelancer_id;
  final String active_name;
  final String email;
  final String type;
  const FieldsToSearchScreen({
    Key? key,
    required this.email,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_id,
    required this.active_name,
    required this.type,
    required this.activeAcc,
  }) : super(key: key);

  @override
  _FieldsToSearchScreenState createState() => _FieldsToSearchScreenState();
}

class _FieldsToSearchScreenState extends State<FieldsToSearchScreen> {
  final storage = new FlutterSecureStorage();
  final rows = <Widget>[];

  Future categories() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'fields');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      if (this.mounted) {
        setState(() {
          for (var i = 0; i < jsonData["data"].length; i++) {
            rows.add(
              Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      if (widget.type == 'Freelancers') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FreelancerByCategoriesScreen(
                              catId: jsonData["data"][i]["id"],
                              email: widget.email,
                              catName: jsonData["data"][i]["name"],
                              active_imgUrl: widget.active_imgUrl,
                              active_name: widget.active_name,
                              activeAcc: widget.activeAcc,
                              active_id: widget.active_id,
                              freelancer_id: widget.freelancer_id,
                            ),
                          ),
                        );
                      } else if (widget.type == 'Projects') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectListScreen(
                              catId: jsonData["data"][i]["id"],
                              email: widget.email,
                              active_imgUrl: widget.active_imgUrl,
                              active_name: widget.active_name,
                              activeAcc: widget.activeAcc,
                              active_id: widget.active_id,
                              type: widget.type,
                              freelancer_id: widget.freelancer_id,
                              cat_name: jsonData["data"][i]["name"],
                            ),
                          ),
                        );
                      } else if (widget.type == 'Businesses') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeekerByFieldScreen(
                              email: widget.email,
                              catId: jsonData["data"][i]["id"],
                              catName: jsonData["data"][i]["name"],
                              active_imgUrl: widget.active_imgUrl,
                              active_name: widget.active_name,
                              activeAcc: widget.activeAcc,
                              active_id: widget.active_id,
                              freelancer_id: widget.freelancer_id,
                            ),
                          ),
                        );
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.grey[850],
                    highlightColor: HexColor("#60B781"),
                    padding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      // horizontal: 20.0,
                    ),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Image.network(
                        "${baseURLImg2}${jsonData["data"][i]["image"]}",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    jsonData["data"][i]["name"],
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            );
          }
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Server Error",
      //   ),
      // );
    }
  }

  @override
  void initState() {
    super.initState();
    categories();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: <Widget>[
        Image.asset(
          "images/background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            bottomOpacity: 100,
          ),
          drawer: widget.activeAcc == "seeker"
              ? DrawerWidgetSeeker(
                  active_imgUrl: widget.active_imgUrl,
                  email: widget.email,
                  active_name: widget.active_name,
                  activeAcc: widget.activeAcc,
                  active_id: widget.active_id,
                )
              : DrawerWidgetFreelancer(
                  email: widget.email,
                  active_imgUrl: widget.active_imgUrl,
                  active_name: widget.active_name,
                  activeAcc: widget.activeAcc,
                  active_id: widget.active_id,
                  location: '',
                  freelancer_id: widget.freelancer_id,
                ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 100,
                  width: 130,
                  child: Image.asset('images/pik.png'),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Pik',
                        style: TextStyle(
                          color: HexColor("#60B781"),
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      SizedBox(
                        child: widget.type == 'Businesses'
                            ? Text(
                                'a field',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              )
                            : Text(
                                'a Category',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.type,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Wrap(
                  children: rows, //code here
                  spacing: 20.0,
                  runSpacing: 20.0,
                ),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () {
                    // Respond to button press
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllSeekerScreen(
                          // fLanceId: data[index]["id"],
                          activeAcc: widget.activeAcc,
                          active_imgUrl: widget.active_imgUrl,
                          email: widget.email,
                          active_name: widget.active_name,
                          active_id: widget.active_id,
                          freelancer_id: null,
                          // catName: widget.catName,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: HexColor("#60B781"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
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
