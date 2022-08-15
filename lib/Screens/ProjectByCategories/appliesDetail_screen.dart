import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Freelancer/freelancerProfile_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'applyApprovedDialog_screen.dart';

class AppliesDetailScreen extends StatefulWidget {
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final String active_name;
  final String email;
  final int? freelancer_id;
  final List? applies;
  final int? projID;
  final String type;
  final int? receiverID;
  final int? seekProj_id;
  final String category_name;
  const AppliesDetailScreen({
    Key? key,
    required this.email,
    required this.active_imgUrl,
    required this.category_name,
    required this.projID,
    required this.applies,
    required this.seekProj_id,
    required this.freelancer_id,
    required this.receiverID,
    required this.type,
    required this.active_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<AppliesDetailScreen> createState() => _AppliesDetailScreenState();
}

class _AppliesDetailScreenState extends State<AppliesDetailScreen> {
  bool visibility = false;
  final rows = <Widget>[];
  String name = "";
  String? f_id;
  int? id;
  String? p_id;
  final storage = new FlutterSecureStorage();
  Future approve() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );

    var uri = Uri.parse(baseURL + 'project/approvel/1');
    String? token = await storage.read(key: "token");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = new http.MultipartRequest(
      'POST',
      uri,
    )..headers.addAll(headers);

    request.fields['id'] = f_id!;
    request.fields['project_id'] = p_id!;

    var response = await request.send();
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      if (this.mounted) {
        setState(() {
          visibility = true;
        });
      }

      _showTopFlash("#ff3333", "Approved sucessfully");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Approved sucessfully",
      //   ),
      // );
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future disapprove() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );

    var uri = Uri.parse(baseURL + 'project/approvel/0');
    String? token = await storage.read(key: "token");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = new http.MultipartRequest(
      'POST',
      uri,
    )..headers.addAll(headers);

    request.fields['id'] = f_id!;
    request.fields['project_id'] = p_id!;

    var response = await request.send();
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: AppliesDetailScreen(
              email: widget.email,
              seekProj_id: widget.seekProj_id,
              active_id: widget.active_id,
              activeAcc: widget.activeAcc,
              active_imgUrl: widget.active_imgUrl,
              active_name: widget.active_name,
              type: widget.type,
              freelancer_id: widget.freelancer_id,
              receiverID: widget.receiverID,
              applies: widget.applies,
              projID: widget.projID,
              category_name: widget.category_name,
            )),
      );
      _showTopFlash("#60B781", "Declined sucessfully");
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future projectById() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url =
        Uri.parse(baseURL + 'getAppliedFreelancers/${widget.seekProj_id}');

    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      var rest = jsonData["data"] as List;
      var filteredList;
      filteredList = rest.where((val) => val["status"] == 1).toList();
      await EasyLoading.dismiss();
      if (this.mounted) {
        setState(
          () {
            if (filteredList.isEmpty) {
              for (var i = 0; i < jsonData["data"].length; i++) {
                id = jsonData["data"][i]["freelancer"]["user_id"];
                rows.add(
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: jsonData["data"][i]["status"] != 4
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: jsonData["data"][i]["freelancer"]
                                                ["image"] ==
                                            null
                                        ? CircleAvatar(
                                            radius: 30.0,
                                            backgroundColor: Colors.grey[300],
                                          )
                                        : Image.network(
                                            '${baseURLImg}${jsonData["data"][i]["freelancer"]["image"]}',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${jsonData["data"][i]["freelancer"]["first_name"]} ${jsonData["data"][i]["freelancer"]["last_name"]}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.grey[600],
                                            size: 15.0,
                                          ),
                                          Text(
                                            "4.0",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${jsonData["data"][i]["freelancer"]["categories"][0]["name"]}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FreelancerProfileScreen(
                                            activeAcc: widget.activeAcc,
                                            email: widget.email,
                                            active_imgUrl: widget.active_imgUrl,
                                            active_name: widget.active_name,
                                            search_id: jsonData["data"][i]
                                                ["freelancer_id"],
                                            active_id: widget.active_id,
                                            freelancer_id: widget.freelancer_id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "View Profile",
                                      style: TextStyle(
                                        color: HexColor("#60B781"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            f_id =
                                                "${jsonData["data"][i]["freelancer_id"]}";
                                            p_id =
                                                "${jsonData["data"][i]["project_id"]}";
                                            name =
                                                "${jsonData["data"][i]["freelancer"]["first_name"]}";
                                          });
                                          approve();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: HexColor("#60B781"),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            f_id =
                                                "${jsonData["data"][i]["freelancer_id"]}";
                                            p_id =
                                                "${jsonData["data"][i]["project_id"]}";
                                          });
                                          disapprove();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: HexColor("#60B781"),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: jsonData["data"][i]["freelancer"]
                                                ["image"] ==
                                            null
                                        ? CircleAvatar(
                                            radius: 30.0,
                                            backgroundColor: Colors.grey[300],
                                          )
                                        : Image.network(
                                            '${baseURLImg}${jsonData["data"][i]["freelancer"]["image"]}',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${jsonData["data"][i]["freelancer"]["first_name"]} ${jsonData["data"][i]["freelancer"]["last_name"]}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.grey[600],
                                            size: 15.0,
                                          ),
                                          Text(
                                            "4.0",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${jsonData["data"][i]["freelancer"]["categories"][0]["name"]}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.grey[400],
                                      ),
                                      Text(
                                        "Declined",
                                        style:
                                            TextStyle(color: Colors.grey[400]),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                  ),
                );
              }
            } else {
              rows.add(
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child:
                                filteredList[0]["freelancer"]["image"] == null
                                    ? CircleAvatar(
                                        radius: 30.0,
                                        backgroundColor: Colors.grey[300],
                                      )
                                    : Image.network(
                                        '${baseURLImg}${filteredList[0]["freelancer"]["image"]}',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.fill,
                                      ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${filteredList[0]["freelancer"]["first_name"]} ${filteredList[0]["freelancer"]["last_name"]}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.grey[600],
                                    size: 15.0,
                                  ),
                                  Text(
                                    "4.0",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${filteredList[0]["freelancer"]["categories"][0]["name"]}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: HexColor("#60B781"),
                          ),
                          Text(
                            "Approved",
                            style: TextStyle(color: HexColor("#60B781")),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  @override
  void initState() {
    super.initState();
    projectById();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          email: widget.email,
          centerTitle: '',
          leading: true,
          active_id: widget.active_id,
          active_imgUrl: widget.active_imgUrl,
          active_name: widget.active_name,
          activeAcc: widget.activeAcc,
          freelancer_id: widget.freelancer_id,
          nav: false,
          notifi: false,
          no: null,
        ),
        body: Stack(
          children: [
            Column(
              children: rows,
            ),
            Visibility(
              child: ApplyApprovedDialog(
                receiverID: id,
                email: widget.email,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                active_id: widget.active_id,
                freelancer_id: widget.freelancer_id,
                chatID: null,
                free_name: name,
              ),
              visible: visibility,
            )
          ],
        ),
        bottomNavigationBar: widget.activeAcc == "seeker"
            ? BottomNavWidgetSeeker(
                active_id: widget.active_id,
                email: widget.email,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                freelancer_id: widget.freelancer_id,
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
