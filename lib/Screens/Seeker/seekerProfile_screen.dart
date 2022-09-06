import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Chat/chat_screen.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Freelancer/freelancerHomePage_screen.dart';
import 'bottomNavWidgetSeeker.dart';
import '../Freelancer/drawerWidgetFreelancer.dart';
import 'drawerWidgetSeeker.dart';

class SeekerProfileScreen extends StatefulWidget {
  final int? search_id;
  final int? active_id;
  final int? freelancer_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final String active_name;
  final String email;
  const SeekerProfileScreen({
    Key? key,
    required this.search_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_name,
    required this.email,
    required this.activeAcc,
    required this.active_id,
  }) : super(key: key);

  @override
  _SeekerProfileScreenState createState() => _SeekerProfileScreenState();
}

class _SeekerProfileScreenState extends State<SeekerProfileScreen> {
  final storage = const FlutterSecureStorage();
  String? imgURL;
  bool toggle = false;
  bool pressAttention = false;
  String? fname;
  String? bname;
  String? lname;
  String location = "";
  String founded = "";
  String about = "";
  int follower = 0;
  int following = 0;
  int status = 0;
  int count = 0;
  int? receiverID;
  List data = [];

  Future getSeekerInfo() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = widget.activeAcc == "seeker"
        ? Uri.parse('${baseURL}seeker/${widget.active_id}')
        : Uri.parse('${baseURL}seekerS/${widget.search_id}');
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
      if (mounted) {
        setState(() {
          if (widget.activeAcc == "freelancer") {
            status = jsonData["follow_status"];
          }
          follower = jsonData["follower"];
          following = jsonData["following"];
          print(follower);
          print(following);
          receiverID = jsonData["data"]["user_id"];
          if (jsonData["data"]["first_name"] == null &&
              jsonData["data"]["last_name"] == null) {
            bname = jsonData["data"]["business_name"];
          } else {
            fname = jsonData["data"]["first_name"];
            lname = jsonData["data"]["last_name"];
          }
          location = jsonData["data"]["location"];
          about = jsonData["data"]["about"];
          founded = jsonData["data"]["founded"].toString();
          count = jsonData["data"]["specialities"].length;
          data = jsonData["data"]["specialities"];
          if (jsonData["data"]["image"] != null) {
            imgURL = jsonData["data"]["image"];
          }
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future follow() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );

    var uri = Uri.parse('${baseURL}following/seeker/${widget.search_id}');
    String? token = await storage.read(key: "token");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.MultipartRequest(
      'POST',
      uri,
    )..headers.addAll(headers);

    request.fields['status'] = "1";
    if (bname == null) {
      request.fields['name'] = "${fname!} ${lname!}";
    } else {
      request.fields['name'] = bname!;
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      getSeekerInfo();
      if (mounted) {
        setState(() {
          pressAttention = !pressAttention;
        });
      }
      await EasyLoading.dismiss();

      _showTopFlash("#60B781", "Followed sucessfully");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Followed sucessfully",
      //   ),
      // );
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future unfollow() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );

    var uri = Uri.parse('${baseURL}following/seeker/${widget.search_id}');
    String? token = await storage.read(key: "token");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.MultipartRequest(
      'POST',
      uri,
    )..headers.addAll(headers);

    request.fields['status'] = "0";
    if (bname == null) {
      request.fields['name'] = "${fname!} ${lname!}";
    } else {
      request.fields['name'] = bname!;
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      getSeekerInfo();
      if (mounted) {
        setState(() {
          pressAttention = !pressAttention;
        });
      }
      await EasyLoading.dismiss();

      _showTopFlash("#60B781", "Unfollowed sucessfully");
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future followBlock() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );

    var uri = Uri.parse('${baseURL}following/seeker/${widget.search_id}');
    String? token = await storage.read(key: "token");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.MultipartRequest(
      'POST',
      uri,
    )..headers.addAll(headers);

    request.fields['status'] = "2";
    if (bname == null) {
      request.fields['name'] = "${fname!} ${lname!}";
    } else {
      request.fields['name'] = bname!;
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      // getSeekerInfo();
      // setState(() {
      //   pressAttention = !pressAttention;
      // });
      await EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: const FreelancerHomePageScreen(),
        ),
        (route) => false,
      );
      _showTopFlash("#60B781", "Blocked sucessfully");
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  @override
  void initState() {
    super.initState();
    // EasyLoading.show(
    //   status: 'Loading...',
    //   maskType: EasyLoadingMaskType.black,
    // );
    getSeekerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(
          centerTitle: '',
          nav: false,
          leading: true,
          email: widget.email,
          active_id: widget.active_id,
          active_imgUrl: widget.active_imgUrl,
          active_name: widget.active_name,
          activeAcc: widget.activeAcc,
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
                email: widget.email,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                active_id: widget.active_id,
                location: '',
                freelancer_id: widget.freelancer_id,
              ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: widget.activeAcc == 'freelancer'
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const SizedBox(),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      toggle = !toggle;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: toggle
                                            ? HexColor("#60B781")
                                            : Colors.grey,
                                      ),
                                      Text(
                                        '4.0',
                                        style: TextStyle(
                                          color: toggle
                                              ? HexColor("#60B781")
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const SizedBox(),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      toggle = !toggle;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: toggle
                                            ? HexColor("#60B781")
                                            : Colors.grey,
                                      ),
                                      Text(
                                        '4.0',
                                        style: TextStyle(
                                          color: toggle
                                              ? HexColor("#60B781")
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                Container(
                  child: imgURL == null
                      ? CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.grey[300],
                        )
                      : CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage("$baseURLImg$imgURL"),
                        ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  child: bname == null
                      ? Text(
                          "$fname $lname",
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          "$bname",
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$following Following',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '|',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 25.0,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      '$follower Followers',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  child: widget.activeAcc == "seeker"
                      ? null
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      email: widget.email,
                                      receiverID: receiverID,
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
                              child: const Icon(
                                Icons.message_sharp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                ),
                Container(
                  child: widget.activeAcc == "seeker"
                      ? null
                      : Container(
                          child: status == 0
                              ? FlatButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                  highlightColor: HexColor("#60B781"),
                                  color: pressAttention
                                      ? Colors.grey[400]
                                      : HexColor("#60B781"),
                                  // HexColor("#60B781"),
                                  splashColor: Colors.black12,
                                  onPressed: () {
                                    follow();
                                    setState(
                                        () => pressAttention = !pressAttention);
                                  },
                                  child: pressAttention == false
                                      ? const Text(
                                          "Follow",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          "Following",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                )
                              : FlatButton(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                  highlightColor: HexColor("#60B781"),
                                  color: pressAttention
                                      ? HexColor("#60B781")
                                      : Colors.grey[400],
                                  // HexColor("#60B781"),
                                  splashColor: Colors.black12,
                                  onPressed: () {
                                    unfollow();
                                    setState(
                                        () => pressAttention = !pressAttention);
                                  },
                                  child: pressAttention == false
                                      ? const Text(
                                          "Following",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          "Follow",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                        ),
                ),
                SizedBox(
                  height: widget.activeAcc == "seeker" ? 15 : null,
                ),
                Container(
                    color: widget.activeAcc == "seeker"
                        ? HexColor("#60B781")
                        : null,
                    height: widget.activeAcc == "seeker" ? 85.0 : null,
                    width:
                        widget.activeAcc == "seeker" ? double.infinity : null,
                    child: widget.activeAcc == "seeker"
                        ? Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 5.0,
                              ),
                              const Text(
                                'Your weekly dashboard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    '2',
                                    style: TextStyle(
                                      fontSize: 23,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    'Ongoing Projects',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '4',
                                    style: TextStyle(
                                      fontSize: 23,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    'New Followers',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    '3',
                                    style: TextStyle(
                                      fontSize: 23,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    'New Shares',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : null),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  child: Text(
                    about,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset('images/icon1.png'),
                      const SizedBox(
                        width: 8.0,
                      ),
                      const Text(
                        'Specialities',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: count,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 30.0),
                      child: FlatButton(
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.play_arrow,
                              color: HexColor("#60B781"),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              data[index]["name"],
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Founded',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            founded,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 20.0,
                        width: double.infinity,
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Contact Information',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.local_phone_outlined,
                              color: HexColor("#60B781"),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.mail_outline_outlined,
                              color: HexColor("#60B781"),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             SeekerAddProjectScreen()));
                            },
                            child: Icon(
                              Icons.language_outlined,
                              color: HexColor("#60B781"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: widget.activeAcc == "freelancer"
                      ? TextButton(
                          onPressed: () {
                            followBlock();
                          },
                          child: const Text(
                            "Block this user",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : null,
                ),
              ],
            ),
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
                active_id: widget.active_id,
                email: widget.email,
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
          boxShadows: const [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: FlashBar(
            content: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            progressIndicatorBackgroundColor: Colors.white,
            progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(
              HexColor(color),
            ),
            showProgressIndicator: true,
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child: const Text(
                'DISMISS',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
