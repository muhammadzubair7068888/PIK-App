import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:multiselect/multiselect.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Freelancer/freelancerHomePage_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../Seeker/seekerHomePage_screen.dart';

class AccountSettingScreenEdit extends StatefulWidget {
  final String password;
  final String? activeAcc;
  final String language;
  final String active_name;
  final String mobile;
  final String email;
  final String? active_imgUrl;
  final int? active_id;
  final int? freelancer_id;

  const AccountSettingScreenEdit({
    Key? key,
    required this.active_imgUrl,
    required this.active_id,
    required this.freelancer_id,
    required this.password,
    required this.activeAcc,
    required this.language,
    required this.active_name,
    required this.mobile,
    required this.email,
  }) : super(key: key);

  @override
  State<AccountSettingScreenEdit> createState() =>
      _AccountSettingScreenEditState();
}

class _AccountSettingScreenEditState extends State<AccountSettingScreenEdit> {
  final storage = new FlutterSecureStorage();
  var lang = [];
  List<String> languages = [];
  String username = "";
  String email = "";
  String mobile = "";
  String new_password = "";

  Future language() async {
    var url = Uri.parse(baseURL + 'language');
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
          lang = jsonData["data"];
        });
      }
    } else {
      return "error";
    }
  }

  Future savePressed() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = Uri.parse(baseURL + 'change/detail/user');
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
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['mobile[]'] = mobile;
    request.fields['new_password'] = new_password;
    request.fields['old_password'] = widget.password;
    for (String item in languages) {
      request.files.add(http.MultipartFile.fromString('language_id[]', item));
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      if (widget.activeAcc == "freelancer") {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: FreelancerHomePageScreen(),
          ),
          (route) => false,
        );
      } else if (widget.activeAcc == "seeker") {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: SeekerHomePageScreen(),
          ),
          (route) => false,
        );
      }

      _showTopFlash(
          "#60B781", "Your personal information has been updated successfully");
    } else if (response.statusCode == 422) {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Fill all the required fields correctly");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Fill all the required fields correctly",
      //   ),
      // );
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  @override
  void initState() {
    language();
    if (this.mounted) {
      setState(() {
        username = widget.active_name;
        email = widget.email;
        mobile = widget.mobile;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: HexColor("#333232"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          centerTitle: true,
          title: const Text("Account Settings"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                color: HexColor("#60B781"),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                tileColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Username",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: TextFormField(
                    initialValue: username,
                    onChanged: (value) {
                      username = value;
                    },
                    decoration: InputDecoration(
                      fillColor: HexColor("#60B781"),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor("#60B781"),
                        ),
                      ),
                      // labelText: 'Name',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                tileColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: TextFormField(
                    initialValue: email,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      fillColor: HexColor("#60B781"),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor("#60B781"),
                        ),
                      ),
                      // labelText: 'Name',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                tileColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Mobile",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: mobile,
                    onChanged: (value) {
                      mobile = value;
                    },
                    decoration: InputDecoration(
                      fillColor: HexColor("#60B781"),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor("#60B781"),
                        ),
                      ),
                      // labelText: 'Name',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                tileColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Old Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: TextFormField(
                    enabled: false,
                    obscureText: true,
                    initialValue: "******",
                    onChanged: (value) {
                      // _username = value;
                    },
                    decoration: InputDecoration(
                      fillColor: HexColor("#60B781"),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor("#60B781"),
                        ),
                      ),
                      // labelText: 'Name',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                tileColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "New Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: TextFormField(
                    obscureText: true,
                    // initialValue: widget.mobile,
                    onChanged: (value) {
                      new_password = value;
                    },
                    decoration: InputDecoration(
                      fillColor: HexColor("#60B781"),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor("#60B781"),
                        ),
                      ),
                      // labelText: 'Name',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ListTile(
                tileColor: Colors.white,
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                  child: DropDownMultiSelect(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    onChanged: (List<String> x) {
                      setState(() {
                        languages = x;
                      });
                    },
                    options: (lang).map((e) => e["name"] as String).toList(),
                    selectedValues: languages,
                    whenEmpty: widget.language,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
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
                  savePressed();
                },
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.activeAcc == "seeker"
            ? BottomNavWidgetSeeker(
                active_id: widget.active_id,
                email: widget.email,
                activeAcc: widget.activeAcc,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
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
