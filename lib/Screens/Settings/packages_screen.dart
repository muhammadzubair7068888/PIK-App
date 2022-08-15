import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({Key? key}) : super(key: key);

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  final rows = <Widget>[];
  List data = [];
  int count = 0;
  bool? _checked = false;
  final storage = new FlutterSecureStorage();
  String amount = "";
  int? package_id;

  Future savePressed() async {
    var uri = Uri.parse(baseURL + 'package/renew');
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
    request.fields['amount'] = amount;
    request.fields['package_id'] = package_id.toString();
    if (_checked == false) {
      request.fields['renew'] = 1.toString();
    } else {
      request.fields['renew'] = 0.toString();
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();

      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: PackageScreen(),
        ),
      );

      _showTopFlash("#60B781", "Package will renew when expires");
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future getPackages() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'package/detail');
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
            count = jsonData["data"].length;
            data = jsonData["data"];
            for (var i = 0; i < jsonData["data"].length; i++) {
              // amount = "${data[i]["deposit"]["amount"]}";
              // package_id = data[i]["package_id"];
              rows.add(
                SizedBox(
                  child: data[i]["plan"]["number_of_projects"] < 50
                      ? ListTile(
                          onTap: () {},
                          tileColor: Colors.white,
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                            child: Text("${data[i]["plan"]["name"]}"),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text("${data[i]["date"]}"),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "${data[i]["plan"]["second_text"]}",
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                            child: RichText(
                              text: data[i]["status"] == "1"
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
                                  : TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.dangerous_outlined,
                                            size: 20,
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
                                    ),
                            ),
                          ),
                        )
                      : ListTile(
                          onTap: () {},
                          tileColor: Colors.white,
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                            child: Text("${data[i]["plan"]["name"]}"),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text("${data[i]["date"]}"),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "USD ${data[i]["deposit"]["amount"]}",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                CheckboxListTile(
                                  value: data[i]["auto_renew"] == 0
                                      ? _checked = false
                                      : _checked = true,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      amount = data[i]["deposit"]["amount"];
                                      package_id = data[i]["package_id"];
                                    });
                                    savePressed();
                                  },
                                  title: Text("Auto Renew"),
                                  controlAffinity:
                                      ListTileControlAffinity.platform,
                                  activeColor: HexColor("#60B781"),
                                  checkColor: Colors.black,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "${data[i]["plan"]["second_text"]}",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "- 2% discount on contract fees",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                            child: RichText(
                              text: data[i]["status"] == "1"
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
                                  : TextSpan(
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
        backgroundColor: Colors.grey[300],
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
          centerTitle: true,
          title: Text("Packages"),
        ),
        body: SingleChildScrollView(
          child: Wrap(
            children: rows, //code here
            spacing: 20.0,
            runSpacing: 20.0,
          ),
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
