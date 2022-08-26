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
import '../Ads/advertise1_screen.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Chat/chat_screen.dart';
import '../FreelancerPortfolio/freelancerPortfolio_screen.dart';
import '../Seeker/seekerHomePage_screen.dart';
import 'bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'drawerWidgetFreelancer.dart';
import '../Seeker/drawerWidgetSeeker.dart';

class FreelancerProfileScreen extends StatefulWidget {
  final int? search_id;
  final int? active_id;
  final String? active_imgUrl;
  final int? freelancer_id;
  final String? activeAcc;
  final String active_name;
  final String email;
  const FreelancerProfileScreen({
    Key? key,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_id,
    required this.search_id,
    required this.email,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  _FreelancerProfileScreenState createState() =>
      _FreelancerProfileScreenState();
}

class _FreelancerProfileScreenState extends State<FreelancerProfileScreen> {
  final storage = new FlutterSecureStorage();
  String? imgURLF = null;
  String fname = "";
  int followers = 0;
  int applies = 0;
  bool pressAttention = false;
  int following = 0;
  int ongoingProj = 0;
  int portfolios = 0;
  int newFollowers = 0;
  String lname = "";
  String search_name = "";
  String location = "";
  String years = "";
  int status = 0;
  String about = "";
  int count = 0;
  int? receiverID;
  int countL = 0;
  List data = [];
  List dataL = [];
  bool toggle = false;
  final rows = <Widget>[];
  int? res;

  Future getFreelancerInfo() async {
    print("widget.search_id");
    print(widget.search_id);
    print("widget.active_id");
    print(widget.active_id);
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = widget.activeAcc == "seeker"
        ? Uri.parse('${baseURL}freelancerS/${widget.search_id}')
        : widget.activeAcc == "freelancer" && widget.search_id == null
            ? Uri.parse('${baseURL}freelancer/${widget.active_id}')
            : Uri.parse('${baseURL}freelancer/${widget.search_id}');
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
          if (widget.activeAcc == "seeker") {
            status = jsonData["follow_status"];
          }
          if (widget.activeAcc == "freelancer") {
            applies = jsonData["applies"];
          }
          followers = jsonData["follower"];
          following = jsonData["following"];
          ongoingProj = jsonData["project"];
          portfolios = jsonData["freelancer_portfolio"];
          newFollowers = jsonData["latest_follower"];
          receiverID = jsonData["data"]["user_id"];
          fname = jsonData["data"]["first_name"];
          lname = jsonData["data"]["last_name"];
          search_name = jsonData["data"]["first_name"] +
              " " +
              jsonData["data"]["last_name"];
          location = jsonData["data"]["location"];
          about = jsonData["data"]["about"];
          years = jsonData["data"]["years_of_experience"].toString();
          count = jsonData["data"]["categories"].length;
          countL = jsonData["data"]["languages"].length;
          dataL = jsonData["data"]["languages"];
          data = jsonData["data"]["categories"];
          if (jsonData["data"]["image"] != null) {
            imgURLF = jsonData["data"]["image"];
          }
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Server Error ${response.statusCode}",
      //   ),
      // );
    }
  }

  Future portfolioById() async {
    var url = widget.activeAcc == "seeker"
        ? Uri.parse(baseURL + 'freelancers/${widget.search_id}/portfolios')
        : Uri.parse(baseURL + 'freelancers/${widget.freelancer_id}/portfolios');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    res = response.statusCode;
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      if (this.mounted) {
        setState(
          () {
            for (var i = 0; i < jsonData["data"].length; i++) {
              rows.add(
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: 100,
                    height: 100,
                    child: InkWell(
                      onTap: () {},
                      child: Image(
                        fit: BoxFit.cover,
                        width: 100,
                        height: 70,
                        image: NetworkImage(
                            "${baseURLImg}${jsonData["data"][i]["thumbnail"]}"),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        );
      }
      await EasyLoading.dismiss();
    } else if (response.statusCode == 404) {
      await EasyLoading.dismiss();
      _showTopFlash("#60B781", "No portfolio was found");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "No portfolio was found",
      //   ),
      // );
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

  Future follow() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );

    var uri = Uri.parse(baseURL + 'following/freelancer/${widget.search_id}');
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

    request.fields['status'] = "1";
    request.fields['name'] = search_name;

    var response = await request.send();
    if (response.statusCode == 200) {
      getFreelancerInfo();
      if (this.mounted) {
        setState(() {
          pressAttention = !pressAttention;
        });
      }
      await EasyLoading.dismiss();

      _showTopFlash("#60B781", "Followed sucessfully");
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

    var uri = Uri.parse(baseURL + 'following/freelancer/${widget.search_id}');
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

    request.fields['status'] = "0";
    request.fields['name'] = search_name;

    var response = await request.send();
    if (response.statusCode == 200) {
      getFreelancerInfo();
      if (this.mounted) {
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

    var uri = Uri.parse(baseURL + 'following/freelancer/${widget.search_id}');
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

    request.fields['status'] = "2";
    if (search_name == "") {
      request.fields['name'] = search_name;
    } else {
      request.fields['name'] = search_name;
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      // getSeekerInfo();
      // setState(() {
      //   pressAttention = !pressAttention;
      // });
      await EasyLoading.dismiss();
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: SeekerHomePageScreen(),
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
    getFreelancerInfo();
    portfolioById();
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
          freelancer_id: widget.freelancer_id,
          nav: false,
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
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: widget.activeAcc == 'freelancer'
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(),
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
                                SizedBox(),
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
                  child: imgURLF == null
                      ? CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.grey[300],
                        )
                      : CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.grey,
                          child: ClipOval(
                            child: Image.network(
                              "${baseURLImg}${imgURLF}",
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                ),
                Text(
                  "${fname} ${lname}",
                  style: TextStyle(
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${following} Following',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '|',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 25.0,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        '${followers} Followers',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: widget.activeAcc == "seeker"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      receiverID: receiverID,
                                      active_imgUrl: widget.active_imgUrl,
                                      active_name: widget.active_name,
                                      activeAcc: widget.activeAcc,
                                      active_id: widget.active_id,
                                      freelancer_id: widget.freelancer_id,
                                      email: widget.email,
                                      chatID: null,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.message_sharp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: widget.activeAcc == "freelancer"
                      ? null
                      : Container(
                          child: status == 0
                              ? FlatButton(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
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
                                      ? Text(
                                          "Follow",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "Following",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                )
                              : FlatButton(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
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
                                      ? Text(
                                          "Following",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "Follow",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                        ),
                ),
                Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              "${portfolios}",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              'Projects',
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  years,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  'yrs',
                                ),
                              ],
                            ),
                            Text(
                              'Experience',
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: widget.activeAcc == "freelancer"
                      ? Container(
                          color: HexColor("#60B781"),
                          height: 120.0,
                          width: double.infinity,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Your weekly dashboard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${ongoingProj}',
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
                                    width: 9.0,
                                  ),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 9.0,
                                  ),
                                  Text(
                                    '${newFollowers}',
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
                                    width: 9.0,
                                  ),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 9.0,
                                  ),
                                  Text(
                                    '${applies}',
                                    style: TextStyle(
                                      fontSize: 23,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    'Applies',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdvertiseScreen1(
                                        active_id: widget.active_id,
                                        active_imgUrl: widget.active_imgUrl,
                                        active_name: widget.active_name,
                                        activeAcc: widget.activeAcc,
                                        email: widget.email,
                                        freelancer_id: widget.freelancer_id,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Want more exposure?',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      ' Advertise',
                                    ),
                                    Text(
                                      ' Now',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  child: Text(
                    about,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 50.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset('images/icon1.png'),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: count,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 30.0),
                      child: FlatButton(
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.play_arrow,
                              color: HexColor("#60B781"),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              data[index]["name"],
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 50.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.language,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        "Languages",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: countL,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 30.0),
                      child: FlatButton(
                        onPressed: () {},
                        child: Row(
                          children: <Widget>[
                            // Image.asset('images/globe.png'),
                            Icon(
                              Icons.play_arrow,
                              color: HexColor("#60B781"),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              dataL[index]["name"],
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  height: 250,
                  child: res == 200
                      ? Stack(
                          children: <Widget>[
                            Container(
                                child: Wrap(
                              children: rows, //code here
                              spacing: 20.0,
                              runSpacing: 20.0,
                            )),
                            Container(
                              color: Colors.black54,
                              height: MediaQuery.of(context).size.height,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Portfolio',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                right: 40,
                                bottom: 40,
                              ),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FreelancerPortfolioScreen(
                                            activeAcc: widget.activeAcc,
                                            active_id: widget.active_id,
                                            active_imgUrl: widget.active_imgUrl,
                                            active_name: widget.active_name,
                                            catName: "",
                                            location: location,
                                            search_id: widget.search_id,
                                            search_name: search_name,
                                            freelancer_id: widget.freelancer_id,
                                            fromUpload: '',
                                            email: widget.email,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'View all',
                                      style: TextStyle(
                                        color: HexColor("#60B781"),
                                        fontSize: 18,
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Portfolios not uploaded yet",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: widget.activeAcc == "seeker"
                      ? TextButton(
                          onPressed: () {
                            followBlock();
                          },
                          child: Text(
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
