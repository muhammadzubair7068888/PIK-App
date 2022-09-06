import 'dart:async';
import 'dart:convert';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect/multiselect.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import 'freelancerPortfolio_screen.dart';

class FreelancerUploadPortfolioScreen extends StatefulWidget {
  final List<XFile> images;
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const FreelancerUploadPortfolioScreen({
    Key? key,
    required this.email,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
    required this.images,
  }) : super(key: key);

  @override
  _FreelancerUploadPortfolioScreenState createState() =>
      _FreelancerUploadPortfolioScreenState();
}

class _FreelancerUploadPortfolioScreenState
    extends State<FreelancerUploadPortfolioScreen> {
  Timer? timer;
  bool pn = false;
  bool c = false;
  bool s = false;
  bool t = false;
  bool pd = false;
  bool btnCheck = false;

  final storage = const FlutterSecureStorage();

  String _projectname = '';
  String _about = '';
  var items = [];
  var itemsT = [];
  var itemsS = [];
  List<String> selected = [];
  List<String> selectedT = [];
  List<String> selectedS = [];
  Future categories() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse('${baseURL}categories');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      if (mounted) {
        setState(() {
          items = jsonData["data"];
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future tools() async {
    var url = Uri.parse('${baseURL}tools');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      if (mounted) {
        setState(() {
          itemsT = jsonData["data"];
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future skills() async {
    var url = Uri.parse('${baseURL}skills');
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
          itemsS = jsonData["data"];
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future savePressed() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = Uri.parse('${baseURL}portfolios/upload');
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

    for (XFile item in widget.images) {
      request.files.add(
        await http.MultipartFile.fromPath('files[]', item.path),
      );
    }

    request.fields['project_name'] = _projectname;
    request.fields['description'] = _about;
    for (String item in selected) {
      request.files.add(http.MultipartFile.fromString('category_id[]', item));
    }
    for (String item in selectedT) {
      request.files.add(http.MultipartFile.fromString('tool_id[]', item));
    }
    for (String item in selectedS) {
      request.files.add(http.MultipartFile.fromString('skill_id[]', item));
    }

    var response = await request.send();
    if (response.statusCode == 201) {
      await EasyLoading.dismiss();
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: FreelancerPortfolioScreen(
            active_id: widget.active_id,
            active_imgUrl: widget.active_imgUrl,
            active_name: widget.active_name,
            activeAcc: widget.activeAcc,
            freelancer_id: widget.freelancer_id,
            catName: '',
            location: '',
            search_id: widget.active_id,
            search_name: '',
            fromUpload: 'true',
            email: widget.email,
            forPortfId: widget.freelancer_id,
          ),
        ),
        (route) => false,
      );
      _showTopFlash("#60B781", "Your portfolio has been uploaded successfully");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Your portfolio has been uploaded successfully",
      //   ),
      // );
    } else if (response.statusCode == 422) {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Fill all the required fields");
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future checking() async {
    if (pn == true && c == true && s == true && t == true && pd == true) {
      setState(() {
        btnCheck = true;
      });
    } else {
      setState(() {
        btnCheck = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    categories();
    tools();
    skills();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => checking());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: <Widget>[
              // InkWell(
              //   onTap: () {},
              //   child: Scrollbar(
              //     child: GridView.builder(
              //         itemCount:
              //             widget.images!.isEmpty ? 0 : widget.images!.length,
              //         shrinkWrap: true,
              //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 3),
              //         itemBuilder: (context, index) {
              //           return Container(
              //             padding: EdgeInsets.only(
              //               right: 5,
              //               left: 5,
              //             ),
              //             child: widget.images!.isEmpty
              //                 ? Icon(
              //                     CupertinoIcons.camera,
              //                     color: Colors.grey.withOpacity(0.5),
              //                   )
              //                 : Image.file(
              //                     File(widget.images![index].path),
              //                     fit: BoxFit.cover,
              //                   ),
              //           );
              //         }),
              //   ),
              // ),
              // SizedBox(
              //   height: 30,
              // ),
              TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                onChanged: (value) {
                  _projectname = value;
                  setState(() {
                    pn = true;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Project Name',
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              DropDownMultiSelect(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                onChanged: (List<String> x) {
                  setState(() {
                    selected = x;
                    c = true;
                  });
                },
                options: (items).map((e) => e["name"] as String).toList(),
                // options: ["hello"],
                selectedValues: selected,
                whenEmpty: 'Categories',
              ),
              DropDownMultiSelect(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                onChanged: (List<String> x) {
                  setState(() {
                    selectedT = x;
                    t = true;
                  });
                },
                options: (itemsT).map((e) => e["name"] as String).toList(),
                // options: ["hello"],
                selectedValues: selectedT,
                whenEmpty: 'Tools',
              ),
              DropDownMultiSelect(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                onChanged: (List<String> x) {
                  setState(() {
                    selectedS = x;
                    s = true;
                  });
                },
                options: (itemsS).map((e) => e["name"] as String).toList(),
                // options: ["hello"],
                selectedValues: selectedS,
                whenEmpty: 'Skills',
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                onChanged: (value) {
                  _about = value;
                  setState(() {
                    pd = true;
                  });
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 7,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Project Description',
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              FlatButton(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                highlightColor: btnCheck
                    ? HexColor("#60B781")
                    : const Color.fromARGB(151, 158, 158, 158),
                color: btnCheck
                    ? HexColor("#60B781")
                    : const Color.fromARGB(151, 158, 158, 158),
                splashColor: Colors.black12,
                onPressed: btnCheck
                    ? () {
                        savePressed();
                      }
                    : () {
                        null;
                      },
                child: const Text(
                  "Save",
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
      bottomNavigationBar: BottomNavWidgetFreelancer(
        active_id: widget.active_id,
        active_imgUrl: widget.active_imgUrl,
        active_name: widget.active_name,
        activeAcc: widget.activeAcc,
        freelancer_id: widget.freelancer_id,
        email: widget.email,
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
            content: Text(message, style: const TextStyle(color: Colors.white)),
            progressIndicatorBackgroundColor: Colors.white,
            progressIndicatorValueColor:
                AlwaysStoppedAnimation<Color>(HexColor(color)),
            showProgressIndicator: true,
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child:
                  const Text('DISMISS', style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }
}
