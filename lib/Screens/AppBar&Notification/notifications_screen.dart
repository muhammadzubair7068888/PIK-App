import 'dart:async';
import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import '../../Services/globals.dart';
import '../ContractOfBoth/appDissapp_screen.dart';
import '../ContractOfBoth/contractFormFreelancer_screen.dart';
import '../ContractOfBoth/contractFormSeeker_screen.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../ProjectByCategories/appliesDetail_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'appBarWidget.dart';

class Notifications extends StatefulWidget {
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final String active_name;
  final String email;
  final int? freelancer_id;
  const Notifications({
    Key? key,
    required this.email,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.activeAcc,
    required this.active_name,
  }) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final storage = new FlutterSecureStorage();
  final rows = <Widget>[];
  List data = [];
  int count = 0;
  Timer? timer;
  int _status = 0;
  Future notifyCount() async {
    var url = Uri.parse(baseURL + 'notification/count');
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
          _status = jsonData["data"];
        });
      }
    } else {
      _showTopFlash("#ff3333", "Server Error");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Server Error",
      //   ),
      // );
    }
  }

  Future notifications() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'notification/read');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      await EasyLoading.dismiss();
      if (this.mounted) {
        setState(() {
          data = jsonData["data"];
          count = jsonData["data"].length;
          for (var i = 0; i < jsonData["data"].length; i++) {
            rows.add(
              Card(
                  child: InkWell(
                onTap: data[i]["notification"]["description"] ==
                            "Start contract" &&
                        widget.activeAcc == "freelancer"
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContractFormFreelancerScreen(
                              active_id: widget.active_id,
                              email: widget.email,
                              activeAcc: widget.activeAcc,
                              active_imgUrl: widget.active_imgUrl,
                              active_name: widget.active_name,
                              freelancer_id: widget.freelancer_id,
                              receiverID: data[i]["notification"]["user_id"],
                              contract_id: data[i]["contract_id"],
                            ),
                          ),
                        );
                      }
                    : data[i]["notification"]["description"] ==
                                "Start contract" &&
                            widget.activeAcc == "seeker"
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContractFormSeekerScreen(
                                  active_id: widget.active_id,
                                  activeAcc: widget.activeAcc,
                                  active_imgUrl: widget.active_imgUrl,
                                  active_name: widget.active_name,
                                  freelancer_id: widget.freelancer_id,
                                  receiverID: data[i]["notification"]
                                      ["user_id"],
                                  contract_id: data[i]["contract_id"],
                                ),
                              ),
                            );
                          }
                        : data[i]["notification"]["description"] ==
                                    "Review and Approve" &&
                                widget.activeAcc == "seeker"
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AppDissappScreen(
                                      active_id: widget.active_id,
                                      activeAcc: widget.activeAcc,
                                      active_imgUrl: widget.active_imgUrl,
                                      email: widget.email,
                                      active_name: widget.active_name,
                                      freelancer_id: widget.freelancer_id,
                                      receiverID: data[i]["notification"]
                                          ["user_id"],
                                      contract_id: data[i]["contract_id"],
                                    ),
                                  ),
                                );
                              }
                            : data[i]["notification"]["description"] ==
                                        "Review and Approve" &&
                                    widget.activeAcc == "freelancer"
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AppDissappScreen(
                                          active_id: widget.active_id,
                                          activeAcc: widget.activeAcc,
                                          active_imgUrl: widget.active_imgUrl,
                                          active_name: widget.active_name,
                                          email: widget.email,
                                          freelancer_id: widget.freelancer_id,
                                          receiverID: data[i]["notification"]
                                              ["user_id"],
                                          contract_id: data[i]["contract_id"],
                                        ),
                                      ),
                                    );
                                  }
                                : data[i]["project_id"] != null &&
                                        data[i]["category_name"] != null
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AppliesDetailScreen(
                                              seekProj_id: data[i]
                                                  ["project_id"],
                                              email: widget.email,
                                              active_id: widget.active_id,
                                              activeAcc: widget.activeAcc,
                                              active_imgUrl:
                                                  widget.active_imgUrl,
                                              active_name: widget.active_name,
                                              type: "",
                                              freelancer_id:
                                                  widget.freelancer_id,
                                              receiverID: data[i]
                                                  ["notification"]["user_id"],
                                              applies: null,
                                              projID: null,
                                              category_name: data[i]
                                                  ["category_name"],
                                            ),
                                          ),
                                        );
                                      }
                                    : () {},
                child: Container(
                  padding: EdgeInsets.all(
                    5,
                  ),
                  child: ListTile(
                    leading: data[i]["notification"]["user"]["avatar"] == null
                        ? CircleAvatar(
                            radius: 60.0,
                            backgroundColor: Colors.grey[300],
                          )
                        : CircleAvatar(
                            child: ClipOval(
                              child: Image.network(
                                "${baseURLImg}${data[i]["notification"]["user"]["avatar"]}",
                                width: 60,
                                height: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                            radius: 60.0,
                            backgroundColor: Colors.grey,
                            // backgroundImage: NetworkImage(
                            //   "${baseURLImg}${data[index]["image"]}",
                            // ),
                          ),
                    title: Text("${data[i]["notification"]["title"]}"),
                    subtitle: Text(
                      "${data[i]["notification"]["description"]}",
                      style: TextStyle(
                        color: HexColor('#60B781'),
                      ),
                    ),
                  ),
                ),
              )),
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
    notifyCount();
    notifications();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(
          centerTitle: '',
          leading: true,
          nav: false,
          active_id: widget.active_id,
          email: widget.email,
          active_imgUrl: widget.active_imgUrl,
          active_name: widget.active_name,
          activeAcc: widget.activeAcc,
          freelancer_id: widget.freelancer_id,
          notifi: true,
          no: _status,
        ),
        body: SingleChildScrollView(
          child: count != 0
              ? Column(
                  children: <Widget>[
                    Wrap(
                      children: rows, //code here
                    ),
                  ],
                )
              : Container(
                  height: 200,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "You have no notifications",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
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
                active_id: widget.active_id,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                freelancer_id: widget.freelancer_id,
                email: widget.email,
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
