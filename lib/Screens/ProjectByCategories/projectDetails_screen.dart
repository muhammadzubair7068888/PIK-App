import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Chat/chat_screen.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../Freelancer/drawerWidgetFreelancer.dart';
import '../Seeker/drawerWidgetSeeker.dart';
import 'appliesDetail_screen.dart';
import 'myProject_list.dart';

class SeekerProjectDetailsScreen extends StatefulWidget {
  final String? active_imgUrl;
  final List? applies;
  final int? active_id;
  final int? projID;
  final String type;
  final int? freelancer_id;
  final int? receiverID;
  final int? seekProj_id;
  final String? activeAcc;
  final String active_name;
  final String email;
  const SeekerProjectDetailsScreen({
    Key? key,
    required this.email,
    required this.active_imgUrl,
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
  State<SeekerProjectDetailsScreen> createState() =>
      _SeekerProjectDetailsScreenState();
}

class _SeekerProjectDetailsScreenState
    extends State<SeekerProjectDetailsScreen> {
  final storage = new FlutterSecureStorage();
  int noa = 0;
  String name = "";
  String nameC = "";
  String date = "";
  final rows = <Widget>[];
  String desc = "";
  String loc = "";
  String budget = "";
  int count = 0;
  List linkProj = [];
  int countS = 0;
  List skills = [];
  String textTitle = 'Apply';
  bool isChanged = true;

  Future projectById() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = widget.activeAcc == "freelancer"
        ? Uri.parse('${baseURL}seekerProject/${widget.seekProj_id}')
        : Uri.parse('${baseURL}profile/project/${widget.seekProj_id}/view');

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
      if (mounted) {
        setState(() {
          if (widget.activeAcc == "seeker") {
            noa = jsonData["total_applied"];
          }
          name = jsonData["data"]["name"];
          nameC = jsonData["data"]["category"]["name"];
          date = jsonData["data"]["due_date"];
          desc = jsonData["data"]["description"];
          loc = jsonData["data"]["location"]["name"];
          budget = jsonData["data"]["budget"];
          count = jsonData["data"]["linked_project"].length;
          linkProj = jsonData["data"]["linked_project"];
          countS = jsonData["data"]["skills"].length;
          skills = jsonData["data"]["skills"];
          if (jsonData["data"]["applied"].length >= 5) {
            for (var i = 0; i < 4; i++) {
              rows.add(
                ClipOval(
                  child: jsonData["data"]["applied"][i]["image"] == null
                      ? CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey[300],
                        )
                      : Image.network(
                          '${baseURLImg}${jsonData["data"]["applied"][i]["image"]}',
                          width: 40,
                          height: 40,
                          fit: BoxFit.fill,
                        ),
                ),
              );
            }
          } else {
            for (var i = 0; i < jsonData["data"]["applied"].length; i++) {
              rows.add(
                ClipOval(
                  child: jsonData["data"]["applied"][i]["image"] == null
                      ? CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey[300],
                        )
                      : Image.network(
                          '$baseURLImg${jsonData["data"]["applied"][i]["image"]}',
                          width: 40,
                          height: 40,
                          fit: BoxFit.fill,
                        ),
                ),
              );
            }
          }
        });
      }
    } else {
      var jsonBody = response.body;
      // ignore: unused_local_variable
      var jsonData = jsonDecode(jsonBody);
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future apply() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = Uri.parse(baseURL + 'project/${widget.seekProj_id}/apply');
    String? token = await storage.read(key: "token");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = new http.MultipartRequest(
      'GET',
      uri,
    )..headers.addAll(headers);

    var response = await request.send();
    var responseS = await http.Response.fromStream(response);
    // final result = jsonDecode(responseS.body) as Map<String, dynamic>;
    final result = jsonDecode(responseS.body);
    if (response.statusCode == 200 && result["success"] == true) {
      await EasyLoading.dismiss();
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: My_Projects_List(
            email: widget.email,
            active_id: widget.active_id,
            active_imgUrl: widget.active_imgUrl,
            active_name: widget.active_name,
            activeAcc: widget.activeAcc,
            freelancer_id: widget.freelancer_id,
            receiverID: widget.receiverID,
            seekProj_id: widget.seekProj_id,
            type: widget.type,
          ),
        ),
      );
      _showTopFlash("#60B781", "Applied successfully");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Applied successfully",
      //   ),
      // );
    } else if (response.statusCode == 200 && result["success"] == false) {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Kindly buy applies to apply on projects");
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
    // else if (response.statusCode == 500) {
    //   await EasyLoading.dismiss();
    //   showTopSnackBar(
    //     context,
    //     CustomSnackBar.error(
    //       message: 'Server Error',
    //     ),
    //   );
    // }
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
          nav: false,
          active_imgUrl: widget.active_imgUrl,
          active_name: widget.active_name,
          activeAcc: widget.activeAcc,
          freelancer_id: widget.freelancer_id,
          notifi: false,
          no: null,
        ),
        drawer: widget.activeAcc == "seeker"
            ? DrawerWidgetSeeker(
                active_imgUrl: widget.active_imgUrl,
                email: widget.email,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                active_id: widget.active_id,
                freelancer_id: null,
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
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      nameC,
                      style: TextStyle(color: HexColor("#60B781")),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Linked Projects",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: count,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // index = 0;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(50, 5, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        linkProj[index]["name"],
                        style: TextStyle(color: HexColor("#60B781")),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Due Date",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 5, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    date,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Project Description",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    desc,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Project Skills",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: countS,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(50, 5, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        skills[index]["name"],
                        style: TextStyle(color: HexColor("#60B781")),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Location",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 5, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    loc,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Budget Range",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 5, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${budget} USD",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                child: widget.activeAcc == "freelancer"
                    ? Container(
                        child: widget.type == 'Projects'
                            ? RaisedButton(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 35.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                                child: widget.applies!.isNotEmpty
                                    ? Text(
                                        'Applied',
                                      )
                                    : Text(
                                        'Apply',
                                      ),
                                color: widget.applies!.isNotEmpty
                                    ? Colors.grey
                                    : HexColor("#60B781"),
                                textColor: Colors.white,
                                onPressed: widget.applies!.isNotEmpty
                                    ? () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => ChatScreen(
                                        //       receiverID: widget.receiverID,
                                        //     ),
                                        //   ),
                                        // );
                                        setState(() {});
                                      }
                                    : () {
                                        apply();

                                        setState(() {});
                                      })
                            : Image.asset(
                                'images/triangle.png',
                              ),
                      )
                    : null,
              ),
              SizedBox(
                child: widget.activeAcc == "freelancer"
                    ? Column(
                        children: [
                          Container(
                            child: widget.type == 'Projects'
                                ? RaisedButton(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 35.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                    child: Text(
                                      'Go to my projects',
                                    ),
                                    color: HexColor("#60B781"),
                                    textColor: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              My_Projects_List(
                                            email: widget.email,
                                            active_id: widget.active_id,
                                            active_imgUrl: widget.active_imgUrl,
                                            active_name: widget.active_name,
                                            activeAcc: widget.activeAcc,
                                            freelancer_id: widget.freelancer_id,
                                            receiverID: widget.receiverID,
                                            seekProj_id: widget.seekProj_id,
                                            type: widget.type,
                                          ),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                  )
                                : null,
                          ),
                          Container(
                            child: widget.type == 'approved' &&
                                    widget.activeAcc == "freelancer"
                                ? TextButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            receiverID: widget.receiverID,
                                            email: widget.email,
                                            active_imgUrl: widget.active_imgUrl,
                                            active_name: widget.active_name,
                                            activeAcc: widget.activeAcc,
                                            active_id: widget.active_id,
                                            freelancer_id: widget.freelancer_id,
                                            chatID: null,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.chat_bubble),
                                    label: Text('Start a chat'),
                                  )
                                : null,
                          ),
                        ],
                      )
                    : null,
              ),
              SizedBox(
                child: widget.activeAcc == "seeker"
                    ? Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: HexColor("#60B781"),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 0, 10),
                              child: Text(
                                "Status",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Text(
                                "Applies",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 5, 0, 0),
                              child: Text(
                                "${noa} applies on this project",
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.fromLTRB(40, 10, 10, 0),
                              //   child: Row(
                              //     children: rows, //code here
                              //   ),
                              // ),
                              SizedBox(
                                child: noa != 0
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 0),
                                        child: TextButton.icon(
                                          icon: Icon(Icons.add),
                                          label: Text('View All'),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AppliesDetailScreen(
                                                  email: widget.email,
                                                  seekProj_id:
                                                      widget.seekProj_id,
                                                  active_id: widget.active_id,
                                                  active_imgUrl:
                                                      widget.active_imgUrl,
                                                  active_name:
                                                      widget.active_name,
                                                  activeAcc: widget.activeAcc,
                                                  freelancer_id:
                                                      widget.freelancer_id,
                                                  applies: widget.applies,
                                                  receiverID: widget.receiverID,
                                                  type: widget.type,
                                                  projID: widget.projID,
                                                  category_name: nameC,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      )
                    : null,
              )
            ],
          ),
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
