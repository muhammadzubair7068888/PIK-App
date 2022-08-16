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
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../Freelancer/drawerWidgetFreelancer.dart';
import '../Seeker/drawerWidgetSeeker.dart';

class FreelancerPortfolioDetailScreen extends StatefulWidget {
  final int? portfolio_id;
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const FreelancerPortfolioDetailScreen({
    Key? key,
    required this.email,
    required this.portfolio_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  _FreelancerPortfolioDetailScreenState createState() =>
      _FreelancerPortfolioDetailScreenState();
}

class _FreelancerPortfolioDetailScreenState
    extends State<FreelancerPortfolioDetailScreen> {
  String name = "";
  String desc = "";
  String? file = null;
  List data = [];
  List files = [];
  final columns = <Widget>[];

  final storage = new FlutterSecureStorage();
  Future portfolio() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url =
        Uri.parse(baseURL + 'freelancers/portfolios/${widget.portfolio_id}');
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
          name = jsonData["data"]["project_name"];
          desc = jsonData["data"]["description"];
          data = jsonData["data"]["tools"];
          file = jsonData["data"]["thumbnail"];
          files = jsonData["data"]["files"];
          for (var i = 0; i < jsonData['data']['files'].length; i++) {
            columns.add(
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: file != null
                    ? Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "${baseURLImg}${files[i]["file"]}"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          }
          ;
        });
      }
      await EasyLoading.dismiss();
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
    portfolio();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(
          centerTitle: '',
          email: widget.email,
          leading: true,
          active_id: widget.active_id,
          active_imgUrl: widget.active_imgUrl,
          active_name: widget.active_name,
          activeAcc: widget.activeAcc,
          nav: false,
          freelancer_id: widget.freelancer_id,
          notifi: false,
          no: null,
        ),
        drawer: widget.activeAcc == "seeker"
            ? DrawerWidgetSeeker(
                email: widget.email,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                active_id: widget.active_id,
                freelancer_id: null,
              )
            : DrawerWidgetFreelancer(
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                active_id: widget.active_id,
                location: '',
                freelancer_id: widget.freelancer_id,
                email: widget.email,
              ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Tools',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow,
                        color: HexColor("#60B781"),
                        size: 15,
                      ),
                      Text(
                        '${data[index]["name"]}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '100',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Icon(
                    Icons.favorite,
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: file != null
                    ? Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "${baseURLImg}${files[0]["file"]}"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: files.length == 0 || files.length == 1
                    ? []
                    : [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              NetworkImage("${baseURLImg}${files[1]["file"]}"),
                        ),
                        Text(
                          "Counter Design",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 40,
                  right: 60,
                ),
                child: SizedBox(
                  height: 20.0,
                  width: double.infinity,
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
              ),
              Column(
                children: columns,
              ),
              SizedBox(
                height: 15.0,
              ),
              // Center(
              //   child: Column(
              //     children: [
              //       Text("Contact Us"),
              //       SizedBox(
              //         height: 5.0,
              //       ),
              //       Text(
              //         "Empowered by Brandaphic",
              //         style: TextStyle(color: Colors.grey),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.activeAcc == "seeker"
            ? BottomNavWidgetSeeker(
                email: widget.email,
                active_id: widget.active_id,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                freelancer_id: null,
              )
            : BottomNavWidgetFreelancer(
                email: widget.email,
                active_id: widget.active_id,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                freelancer_id: widget.freelancer_id,
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
