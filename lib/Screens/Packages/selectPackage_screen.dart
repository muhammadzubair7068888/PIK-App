import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'packagePayment_screen.dart';

class SelectPackage extends StatefulWidget {
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const SelectPackage({
    Key? key,
    required this.email,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<SelectPackage> createState() => _SelectPackageState();
}

class _SelectPackageState extends State<SelectPackage> {
  final storage = new FlutterSecureStorage();
  final rows = <Widget>[];
  List data = [];
  int count = 0;
  String groupValue = "0";
  String price = "";

  Future packages() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'packages/all');
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
          data = jsonData[0]["data"];
          count = jsonData[0]["data"].length;
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
    packages();
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
          body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: SizedBox(
                      width: 100,
                      child: Image.asset(
                        'images/pik.png',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Select your Package",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: count,
                  itemBuilder: (context, index) {
                    // index = 0;
                    if (data[index]["check"] == 0) {
                      data[index]["check"] = false;
                    }
                    return data[index]["second_price"] == null
                        ? Padding(
                            padding: const EdgeInsets.all(40),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: data[index]["check"]
                                    ? HexColor("#60B781")
                                    : Colors.white,
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  children: [
                                    Text(
                                      data[index]["name"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    // data[index]["second_price"] == null
                                    // ?
                                    Text(
                                      String.fromCharCodes(new Runes(
                                          '\u0024 ${data[index]["first_price"]}')),
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: data[index]["check"]
                                            ? Colors.white
                                            : HexColor("#60B781"),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      data[index]["first_text"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: data[index]["check"]
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        data[index]["second_text"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: data[index]["check"]
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    CheckboxListTile(
                                      side: BorderSide(
                                        color: Colors.black,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      title: Transform.translate(
                                        offset: const Offset(-12, 0),
                                        child: Text(
                                          "I Agree to the terms and conditions",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: data[index]["check"]
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: Colors.white,
                                      checkColor: HexColor("#60B781"),
                                      value: data[index]["check"],
                                      onChanged: (value) {
                                        setState(() {
                                          data.forEach((element) async {
                                            element["check"] = false;
                                          });
                                          data[index]["check"] = value!;
                                          if (data[index]["check"] == 0) {
                                            data[index]["check"] = false;
                                          } else if (data[index]["check"] ==
                                              1) {
                                            data[index]["check"] = true;
                                          } else if (data[index]["check"] ==
                                              true) {
                                            data[index]["check"] == 1;
                                          } else if (data[index]["check"] ==
                                              false) {
                                            data[index]["check"] == 0;
                                          }
                                        });
                                      },
                                    ),
                                    FlatButton(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: data[index]["check"]
                                                ? Colors.white
                                                : Colors.transparent,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                            BorderRadius.circular(35.0),
                                      ),
                                      highlightColor: data[index]["check"]
                                          ? HexColor("#60B781")
                                          : Colors.grey,
                                      color: data[index]["check"]
                                          ? HexColor("#60B781")
                                          : Colors.grey,
                                      splashColor: Colors.black12,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType
                                                .leftToRightWithFade,
                                            child: PackagePayment(
                                              active_imgUrl:
                                                  widget.active_imgUrl,
                                              active_name: widget.active_name,
                                              activeAcc: widget.activeAcc,
                                              active_id: widget.active_id,
                                              email: widget.email,
                                              freelancer_id:
                                                  widget.freelancer_id,
                                              p_name: '${data[index]["name"]}',
                                              p_price:
                                                  '${data[index]["first_price"]}',
                                              p_textOne: '',
                                              p_textTwo:
                                                  '${data[index]["second_text"]}',
                                              p_id: "${data[index]["id"]}",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Buy Now",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(40),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: data[index]["check"]
                                    ? HexColor("#60B781")
                                    : Colors.white,
                              ),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  children: [
                                    Text(
                                      data[index]["name"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    // data[index]["second_price"] == null
                                    // ?
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RadioButton(
                                          description: "",
                                          value: "0",
                                          groupValue: groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              groupValue = value as String;
                                              price =
                                                  data[index]["first_price"];
                                            });
                                          },
                                          activeColor: data[index]["check"]
                                              ? Colors.white
                                              : HexColor("#60B781"),
                                        ),
                                        Text(
                                          String.fromCharCodes(new Runes(
                                              '\u0024 ${data[index]["first_price"]}')),
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: data[index]["check"]
                                                ? Colors.white
                                                : HexColor("#60B781"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RadioButton(
                                          description: "",
                                          value: "1",
                                          groupValue: groupValue,
                                          onChanged: (value) {
                                            setState(() {
                                              groupValue = value as String;
                                              price =
                                                  data[index]["second_price"];
                                            });
                                          },
                                          activeColor: data[index]["check"]
                                              ? Colors.white
                                              : HexColor("#60B781"),
                                        ),
                                        Text(
                                          String.fromCharCodes(new Runes(
                                              '\u0024 ${data[index]["second_price"]}')),
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: data[index]["check"]
                                                ? Colors.white
                                                : HexColor("#60B781"),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      data[index]["first_text"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: data[index]["check"]
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        data[index]["second_text"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: data[index]["check"]
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    CheckboxListTile(
                                      side: BorderSide(
                                        color: Colors.black,
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      title: Transform.translate(
                                        offset: const Offset(-12, 0),
                                        child: Text(
                                          "I Agree to the terms and conditions",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: data[index]["check"]
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: Colors.white,
                                      checkColor: HexColor("#60B781"),
                                      value: data[index]["check"],
                                      onChanged: (value) {
                                        setState(() {
                                          data.forEach((element) async {
                                            element["check"] = false;
                                          });
                                          data[index]["check"] = value!;
                                          if (data[index]["check"] == 0) {
                                            data[index]["check"] = false;
                                          } else if (data[index]["check"] ==
                                              1) {
                                            data[index]["check"] = true;
                                          } else if (data[index]["check"] ==
                                              true) {
                                            data[index]["check"] == 1;
                                          } else if (data[index]["check"] ==
                                              false) {
                                            data[index]["check"] == 0;
                                          }
                                        });
                                      },
                                    ),
                                    FlatButton(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: data[index]["check"]
                                                ? Colors.white
                                                : Colors.transparent,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                            BorderRadius.circular(35.0),
                                      ),
                                      highlightColor: data[index]["check"]
                                          ? HexColor("#60B781")
                                          : Colors.grey,
                                      color: data[index]["check"]
                                          ? HexColor("#60B781")
                                          : Colors.grey,
                                      splashColor: Colors.black12,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType
                                                .leftToRightWithFade,
                                            child: PackagePayment(
                                              email: widget.email,
                                              active_imgUrl:
                                                  widget.active_imgUrl,
                                              active_name: widget.active_name,
                                              activeAcc: widget.activeAcc,
                                              active_id: widget.active_id,
                                              freelancer_id:
                                                  widget.freelancer_id,
                                              p_name: '${data[index]["name"]}',
                                              p_price: '${price}',
                                              p_textOne:
                                                  '${data[index]["first_text"]}',
                                              p_textTwo:
                                                  '${data[index]["second_text"]}',
                                              p_id: "${data[index]["id"]}",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Buy Now",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                  },
                )
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
