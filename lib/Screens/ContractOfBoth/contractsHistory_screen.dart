import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Freelancer/drawerWidgetFreelancer.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../Seeker/drawerWidgetSeeker.dart';

class ContractsHistoryScreen extends StatefulWidget {
  final int? receiverID;
  final String active_name;
  final String email;
  final int? active_id;
  final int? freelancer_id;
  final String? active_imgUrl;
  final bool navi;
  final String? activeAcc;
  const ContractsHistoryScreen({
    Key? key,
    required this.email,
    required this.receiverID,
    required this.freelancer_id,
    required this.active_id,
    required this.active_name,
    required this.active_imgUrl,
    required this.navi,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<ContractsHistoryScreen> createState() => _ContractsHistoryScreenState();
}

class _ContractsHistoryScreenState extends State<ContractsHistoryScreen> {
  final storage = new FlutterSecureStorage();
  final rows = <Widget>[];
  int count = 0;
  var data;

  Future getContractList() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'contracts/list');
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
          count = jsonData["data"].length;
          data = jsonData["data"];
          for (var i = 0; i < jsonData["data"].length; i++) {
            var date = data[i]["end_date"];
            if (date != null) {
              date = date.substring(0, date.length - 8);
            }
            rows.add(
              Card(
                  child: InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(
                    5,
                  ),
                  child: ListTile(
                    title: Text("${data[i]["name"]}"),
                    subtitle: InkWell(
                      onTap: () {},
                      child: date != null
                          ? Text(
                              date,
                              style: TextStyle(fontSize: 12),
                            )
                          : Text(""),
                    ),
                    trailing: data[i]["status"] == 0
                        ? RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.pending_actions_outlined,
                                    size: 17,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextSpan(
                                  text: "Pending",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : data[i]["status"] == 1
                            ? RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.check_circle_outline,
                                        size: 17,
                                        color: HexColor('#60B781'),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Approved",
                                      style: TextStyle(
                                        color: HexColor('#60B781'),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : data[i]["status"] == 2
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            size: 17,
                                            color: HexColor('#60B781'),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Ongoing",
                                          style: TextStyle(
                                            color: HexColor('#60B781'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : data[i]["status"] == 3
                                    ? RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.dangerous_outlined,
                                                size: 17,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Closed",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.dangerous_outlined,
                                                size: 17,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Declined",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
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
    getContractList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBarWidget(
          centerTitle: '',
          leading: true,
          active_id: widget.active_id,
          active_imgUrl: widget.active_imgUrl,
          active_name: widget.active_name,
          activeAcc: widget.activeAcc,
          freelancer_id: widget.freelancer_id,
          notifi: false,
          nav: widget.navi,
          no: null,
          email: widget.email,
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
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                active_id: widget.active_id,
                location: '',
                email: widget.email,
                freelancer_id: widget.freelancer_id,
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
                      "You have no Contracts",
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
                active_id: widget.active_id,
                active_imgUrl: widget.active_imgUrl,
                email: widget.email,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                freelancer_id: null,
              )
            : BottomNavWidgetFreelancer(
                active_id: widget.active_id,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                email: widget.email,
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
