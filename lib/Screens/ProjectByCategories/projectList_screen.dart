import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../Freelancer/drawerWidgetFreelancer.dart';
import '../Seeker/drawerWidgetSeeker.dart';
import 'projectDetails_screen.dart';
import 'project_model.dart';

class ProjectListScreen extends StatefulWidget {
  final int? catId;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? active_id;
  final int? freelancer_id;
  final String type;
  final String active_name;
  final String email;
  final String cat_name;
  const ProjectListScreen({
    Key? key,
    required this.email,
    required this.active_id,
    required this.catId,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.type,
    required this.activeAcc,
    required this.active_name,
    required this.cat_name,
  }) : super(key: key);

  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final storage = new FlutterSecureStorage();
  List data = [];
  int applied = 0;
  int count = 0;
  int? projID;
  final rows = <Widget>[];
  int? receiverID;

  Future projects() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'projectsByCat/${widget.catId}');
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
          data = jsonData["data"];
          count = jsonData["data"].length;
          for (var i = 0; i < jsonData["data"].length; i++) {
            rows.add(
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeekerProjectDetailsScreen(
                          seekProj_id: data[i]["id"],
                          email: widget.email,
                          active_id: widget.active_id,
                          activeAcc: widget.activeAcc,
                          active_imgUrl: widget.active_imgUrl,
                          active_name: widget.active_name,
                          type: widget.type,
                          freelancer_id: null,
                          receiverID: data[i]['user_id'],
                          applies: data[i]["applied"],
                          projID: data[i]["id"],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: ListTile(
                      title: Text(data[i]["name"]),
                      subtitle: Text(data[i]["due_date"]),
                      trailing: RaisedButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 35.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        child: data[i]["applied"].isEmpty
                            ? Text("Apply")
                            : Text("Applied"),
                        color: data[i]["applied"].isEmpty
                            ? HexColor("#60B781")
                            : Colors.grey[400],
                        textColor: Colors.white,
                        onPressed: data[i]["applied"].isEmpty
                            ? () {
                                setState(() {
                                  projID = data[i]["id"];
                                  receiverID = data[i]['user_id'];
                                });
                                apply();
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future apply() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = Uri.parse(baseURL + 'project/${projID}/apply');
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
          child: SeekerProjectDetailsScreen(
            email: widget.email,
            seekProj_id: projID,
            active_id: widget.active_id,
            activeAcc: widget.activeAcc,
            active_imgUrl: widget.active_imgUrl,
            active_name: widget.active_name,
            type: widget.type,
            freelancer_id: null,
            receiverID: receiverID,
            applies: ["notempty"],
            projID: projID,
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
    projects();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(
          email: widget.email,
          centerTitle: widget.cat_name,
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
                active_name: widget.active_name,
                email: widget.email,
                activeAcc: widget.activeAcc,
                active_id: widget.active_id,
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
          child: count != 0
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: DropdownSearch<ProjectModel>(
                        onChanged: (value) {
                          projID = value!.id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeekerProjectDetailsScreen(
                                seekProj_id: value.id,
                                email: widget.email,
                                active_id: widget.active_id,
                                activeAcc: widget.activeAcc,
                                active_imgUrl: widget.active_imgUrl,
                                active_name: widget.active_name,
                                type: widget.type,
                                freelancer_id: null,
                                receiverID: value.seeker_id,
                                applies: value.applied,
                                projID: value.id,
                              ),
                            ),
                          );
                        },
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Search Projects",
                          ),
                        ),
                        asyncItems: (String? filter) => getData(filter),
                        popupProps: PopupPropsMultiSelection.modalBottomSheet(
                          // showSelectedItems: true,
                          itemBuilder: _customPopupItemBuilderExample2,
                          showSearchBox: true,
                        ),
                        compareFn: (item, sItem) => item.id == sItem.id,
                      ),
                    ),
                    Wrap(
                      children: rows, //code here
                      spacing: 20.0,
                      runSpacing: 20.0,
                    ),
                  ],
                )
              : Container(
                  height: 200,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "No Projects Found",
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

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    ProjectModel? item,
    bool isSelected,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListTile(
          selected: isSelected,
          title: Text(item?.name ?? ''),
          subtitle: Text(item?.due_date ?? ''),
          // trailing: RaisedButton(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: 35.0,
          //   ),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(35.0),
          //   ),
          //   child: item!.applied!.isEmpty ? Text("Apply") : Text("Applied"),
          //   color:
          //       item.applied!.isEmpty ? HexColor("#60B781") : Colors.grey[400],
          //   textColor: Colors.white,
          //   onPressed: item.applied!.isEmpty
          //       ? () {
          //           setState(() {
          //             projID = item.id;
          //             receiverID = item.seeker_id;
          //           });
          //           apply();
          //         }
          //       : null,
          // ),
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

  Future<List<ProjectModel>> getData(filter) async {
    String? token = await storage.read(key: "token");
    var response = await Dio().get(
      baseURL + "projectsByCat/${widget.catId}",
      queryParameters: {"filter": filter},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    final data = response.data["data"];
    if (data != null) {
      return ProjectModel.fromJsonList(data);
    }

    return [];
  }
}

class _CheckBoxWidget extends StatefulWidget {
  final Widget child;
  final bool? isSelected;
  final ValueChanged<bool?>? onChanged;

  // ignore: unused_element
  _CheckBoxWidget({required this.child, this.isSelected, this.onChanged});

  @override
  CheckBoxState createState() => CheckBoxState();
}

class CheckBoxState extends State<_CheckBoxWidget> {
  bool? isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant _CheckBoxWidget oldWidget) {
    if (widget.isSelected != isSelected) isSelected = widget.isSelected;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0x88F44336),
            Colors.blue,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Select: '),
              Checkbox(
                  value: isSelected,
                  tristate: true,
                  onChanged: (bool? v) {
                    if (v == null) v = false;
                    setState(() {
                      isSelected = v;
                      if (widget.onChanged != null) widget.onChanged!(v);
                    });
                  }),
            ],
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
