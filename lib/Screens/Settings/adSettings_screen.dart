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
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'adSettingDetails_screen.dart';

class ADSettingScreen extends StatefulWidget {
  final String? active_imgUrl;
  final int? active_id;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const ADSettingScreen({
    Key? key,
    required this.email,
    required this.freelancer_id,
    required this.active_imgUrl,
    required this.active_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<ADSettingScreen> createState() => _ADSettingScreenState();
}

class _ADSettingScreenState extends State<ADSettingScreen> {
  final rows = <Widget>[];
  List data = [];
  int count = 0;
  final storage = new FlutterSecureStorage();

  Future getPackages() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'user/ads/list');
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
        setState(
          () {
            count = jsonData[0]["data"].length;
            data = jsonData[0]["data"];
            for (var i = 0; i < jsonData[0]["data"].length; i++) {
              rows.add(
                Card(
                  child: InkWell(
                    onTap: data[i]["status"] == 2
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdSettingDetailScreen(
                                  endD: data[i]["end_date"],
                                  name: data[i]["title"],
                                  price: "${data[i]["amount"]}",
                                  startD: data[i]["start_date"],
                                  id: data[i]["id"],
                                ),
                              ),
                            );
                          }
                        : () {},
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: ListTile(
                        title: Text('${data[i]["title"]}'),
                        subtitle: Text('${data[i]["end_date"]}'),
                        trailing: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                          child: Column(
                            children: [
                              RichText(
                                  text: data[i]["status"] == 1
                                      ? TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.check_circle_outline,
                                                size: 18,
                                                color: HexColor("#60B781"),
                                              ),
                                            ),
                                            TextSpan(
                                              text: " Active",
                                              style: TextStyle(
                                                color: HexColor("#60B781"),
                                              ),
                                            ),
                                          ],
                                        )
                                      : data[i]["status"] == 2
                                          ? TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.dangerous_outlined,
                                                    size: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " Expired",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.money,
                                                    size: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " Pending",
                                                  style: TextStyle(
                                                    color: HexColor("#60B781"),
                                                  ),
                                                ),
                                              ],
                                            )),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          " Total Price ${data[i]["amount"]} USD",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
    getPackages();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#333232"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: count > 0
                ? Wrap(
                    children: rows, //code here
                    spacing: 20.0,
                    runSpacing: 20.0,
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 250),
                    child: Center(
                      child: Text(
                        "You have created no Ad's",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  )),
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
