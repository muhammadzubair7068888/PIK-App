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
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';

class FromDrawer extends StatefulWidget {
  final String email;
  final int? receiverID;
  final int? chatID;
  final String active_name;
  final int? active_id;
  final int? freelancer_id;
  final String? active_imgUrl;
  final String? activeAcc;
  const FromDrawer({
    Key? key,
    required this.email,
    required this.receiverID,
    required this.chatID,
    required this.freelancer_id,
    required this.active_id,
    required this.active_name,
    required this.active_imgUrl,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<FromDrawer> createState() => _FromDrawerState();
}

class _FromDrawerState extends State<FromDrawer> {
  final storage = new FlutterSecureStorage();
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
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
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
        ),
        body: count == 0
            ? const Center(
                child: Text(
                  "There are no contract's",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: count,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ListTile(
                      onTap: () {
                        // if (widget.activeAcc == 'freelancer') {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) =>
                        //           ContractFormFreelancerScreen(
                        //         active_id: widget.active_id,
                        //         activeAcc: widget.activeAcc,
                        //         active_imgUrl: widget.active_imgUrl,
                        //         active_name: widget.active_name,
                        //         freelancer_id: null,
                        //         chatID: null,
                        //         receiverID: null,
                        //         contract_id: data[index]["id"],
                        //       ),
                        //     ),
                        //   );
                        // } else {}
                      },
                      tileColor: Colors.white,
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Text("${data[index]["name"]}"),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                        child: widget.activeAcc == "freelancer"
                            ? Text(
                                "${data[index]["second_party_approve_date"]}")
                            : Text(
                                "${data[index]["first_party_approve_date"]}"),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                        child: data[index]["status"] == 0
                            ? RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.pending_outlined,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " Pending",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : data[index]["status"] == 1
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.check_circle_outline,
                                            size: 18,
                                            color: HexColor("#60B781"),
                                          ),
                                        ),
                                        TextSpan(
                                          text: " Approved",
                                          style: TextStyle(
                                            color: HexColor("#60B781"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : data[index]["status"] == 2
                                    ? RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.check_circle_outline,
                                                size: 18,
                                                color: HexColor("#60B781"),
                                              ),
                                            ),
                                            TextSpan(
                                              text: " On Going",
                                              style: TextStyle(
                                                color: HexColor("#60B781"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : data[index]["status"] == 3
                                        ? RichText(
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.check_circle_outline,
                                                    size: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " Closed",
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
                                                    Icons.cancel_outlined,
                                                    size: 18,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " Declined",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                      ),
                    ),
                  );
                }),
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
