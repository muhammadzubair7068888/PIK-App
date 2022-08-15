// ignore_for_file: unused_element

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../Services/globals.dart';
import 'AppBar&Notification/appBarWidget.dart';
import 'Freelancer/bottomNavWidgetFreelancer_screen.dart';
import 'Freelancer/drawerWidgetFreelancer.dart';
import 'ProjectByCategories/appliedProjectModel.dart';
import 'Seeker/bottomNavWidgetSeeker.dart';
import 'Seeker/drawerWidgetSeeker.dart';

class ApplyHistory extends StatefulWidget {
  final String? active_imgUrl;
  final int? active_id;
  final String type;
  final int? freelancer_id;
  final int? receiverID;
  final int? seekProj_id;
  final String? activeAcc;
  final String active_name;
  final String email;
  const ApplyHistory({
    Key? key,
    required this.email,
    required this.active_imgUrl,
    required this.seekProj_id,
    required this.freelancer_id,
    required this.receiverID,
    required this.type,
    required this.active_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  _ApplyHistoryState createState() => _ApplyHistoryState();
}

class _ApplyHistoryState extends State<ApplyHistory> {
  final storage = new FlutterSecureStorage();
  List data = [];
  int count = 0;
  int? projID;
  final rows = <Widget>[];

  Future appliedProjects() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'projects/applied/list');
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
              rows.add(
                Card(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: ListTile(
                        title: Text(data[i]["project"]["name"]),
                        subtitle: Text(data[i]["project"]["due_date"]),
                        trailing: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: data[i]["status"] == 0
                                    ? Icon(
                                        Icons.hourglass_empty,
                                        size: 14,
                                        color: Colors.grey[400],
                                      )
                                    : data[i]["status"] == 1
                                        ? Icon(
                                            Icons.check_circle,
                                            size: 18,
                                            color: HexColor("#60B781"),
                                          )
                                        : data[i]["status"] == 2
                                            ? Icon(
                                                Icons.close,
                                                size: 14,
                                                color: Colors.grey[400],
                                              )
                                            : data[i]["status"] == 3
                                                ? Icon(
                                                    Icons.check_circle,
                                                    size: 18,
                                                    color: Colors.grey[400],
                                                  )
                                                : Icon(
                                                    Icons.close,
                                                    size: 14,
                                                    color: Colors.grey[400],
                                                  ),
                              ),
                              TextSpan(
                                text: data[i]["status"] == 0
                                    ? " Pending"
                                    : data[i]["status"] == 1
                                        ? " Approved"
                                        : data[i]["status"] == 2
                                            ? " Closed"
                                            : data[i]["status"] == 3
                                                ? " On Going"
                                                : " Declined",
                                style: TextStyle(
                                  color: data[i]["status"] == 0
                                      ? Colors.grey[400]
                                      : data[i]["status"] == 1
                                          ? HexColor("#60B781")
                                          : data[i]["status"] == 2
                                              ? Colors.grey[400]
                                              : data[i]["status"] == 3
                                                  ? HexColor("#60B781")
                                                  : Colors.grey[400],
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
    appliedProjects();
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
                freelancer_id: widget.freelancer_id,
                email: widget.email,
              ),
        body: count == 0
            ? Center(
                child: Text(
                  "There are no project's",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: DropdownSearch<AppliedProjectModel>(
                        onChanged: (value) {
                          projID = value!.project_id;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
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
                freelancer_id: widget.freelancer_id,
                email: widget.email,
              ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    AppliedProjectModel? item,
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
          trailing: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: item!.status == 0
                      ? Icon(
                          Icons.hourglass_empty,
                          size: 14,
                          color: Colors.grey[400],
                        )
                      : item.status == 1
                          ? Icon(
                              Icons.check_circle,
                              size: 18,
                              color: HexColor("#60B781"),
                            )
                          : item.status == 2
                              ? Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.grey[400],
                                )
                              : item.status == 3
                                  ? Icon(
                                      Icons.check_circle,
                                      size: 18,
                                      color: Colors.grey[400],
                                    )
                                  : Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.grey[400],
                                    ),
                ),
                TextSpan(
                  text: item.status == 0
                      ? " Pending"
                      : item.status == 1
                          ? " Approved"
                          : item.status == 2
                              ? " Closed"
                              : item.status == 3
                                  ? " On Going"
                                  : " Declined",
                  style: TextStyle(
                    color: item.status == 0
                        ? Colors.grey[400]
                        : item.status == 1
                            ? HexColor("#60B781")
                            : item.status == 2
                                ? Colors.grey[400]
                                : item.status == 3
                                    ? HexColor("#60B781")
                                    : Colors.grey[400],
                  ),
                ),
              ],
            ),
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

  Future<List<AppliedProjectModel>> getData(filter) async {
    String? token = await storage.read(key: "token");
    var response = await Dio().get(
      baseURL + "projects/applied/list",
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
      return AppliedProjectModel.fromJsonList(data);
    }

    return [];
  }
}

class _CheckBoxWidget extends StatefulWidget {
  final Widget child;
  final bool? isSelected;
  final ValueChanged<bool?>? onChanged;

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
