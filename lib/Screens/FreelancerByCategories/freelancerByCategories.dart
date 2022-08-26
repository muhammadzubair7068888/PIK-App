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

import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Freelancer/freelancerProfile_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../Freelancer/drawerWidgetFreelancer.dart';
import '../Seeker/drawerWidgetSeeker.dart';
import 'freelancer_model.dart';

class FreelancerByCategoriesScreen extends StatefulWidget {
  final int catId;
  final String catName;
  final String? active_imgUrl;
  final int? active_id;
  final int? freelancer_id;
  final String? activeAcc;
  final String active_name;
  final String email;
  const FreelancerByCategoriesScreen({
    Key? key,
    required this.email,
    required this.catId,
    required this.catName,
    required this.freelancer_id,
    required this.active_imgUrl,
    required this.active_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  _FreelancerByCategoriesScreenState createState() =>
      _FreelancerByCategoriesScreenState();
}

class _FreelancerByCategoriesScreenState
    extends State<FreelancerByCategoriesScreen> {
  final storage = const FlutterSecureStorage();
  List data = [];
  int count = 0;
  int? frID;

  Future getFreelancers() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse('${baseURL}freelancerByCategory/${widget.catId}');
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
          data = jsonData["data"];
          count = jsonData["data"].length;
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
    getFreelancers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(
          email: widget.email,
          centerTitle: widget.catName,
          leading: true,
          active_id: widget.active_id,
          active_imgUrl: widget.active_imgUrl,
          active_name: widget.active_name,
          nav: false,
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
          child: count != 0
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: DropdownSearch<FreelancerModel>(
                        onChanged: (value) {
                          setState(() {
                            frID = value!.userId;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FreelancerProfileScreen(
                                activeAcc: widget.activeAcc,
                                active_imgUrl: widget.active_imgUrl,
                                active_name: widget.active_name,
                                search_id: frID,
                                active_id: widget.active_id,
                                freelancer_id: widget.freelancer_id,
                                email: widget.email,
                              ),
                            ),
                          );
                        },
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Search Freelancers",
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
                    ListView.builder(
                      itemCount: count,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // index = 0;
                        return Card(
                          child: data[index]["network_status"] != 2
                              ? InkWell(
                                  onTap: () {
                                    if (widget.activeAcc == "seeker") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FreelancerProfileScreen(
                                            activeAcc: widget.activeAcc,
                                            active_imgUrl: widget.active_imgUrl,
                                            active_name: widget.active_name,
                                            search_id: data[index]["user_id"],
                                            active_id: widget.active_id,
                                            freelancer_id: widget.freelancer_id,
                                            email: widget.email,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FreelancerProfileScreen(
                                            activeAcc: widget.activeAcc,
                                            active_imgUrl: widget.active_imgUrl,
                                            active_name: widget.active_name,
                                            search_id: frID,
                                            active_id: widget.active_id,
                                            freelancer_id: widget.freelancer_id,
                                            email: widget.email,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      right: 20,
                                    ),
                                    child: ListTile(
                                      leading: data[index]["image"] == null
                                          ? CircleAvatar(
                                              radius: 60.0,
                                              backgroundColor: Colors.grey[300],
                                            )
                                          : CircleAvatar(
                                              radius: 60.0,
                                              backgroundColor: Colors.grey,
                                              child: ClipOval(
                                                child: Image.network(
                                                  "$baseURLImg${data[index]["image"]}",
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              // backgroundImage: NetworkImage(
                                              //   "${baseURLImg}${data[index]["image"]}",
                                              // ),
                                            ),
                                      title: Text(
                                        "${data[index]["first_name"]} ${data[index]["last_name"]}",
                                      ),
                                      subtitle: RichText(
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: Icon(
                                                Icons.construction,
                                                size: 17,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.catName,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      trailing: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.star,
                                                size: 17,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "4.0",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                        );
                      },
                    )
                  ],
                )
              : const SizedBox(
                  height: 200,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "No Freelancers Found",
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

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    FreelancerModel? item,
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
          leading: item!.avatar != null
              ? CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.grey,
                  child: ClipOval(
                    child: Image.network(
                      "$baseURLImg${item.avatar}",
                      width: 60,
                      height: 60,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : const CircleAvatar(
                  // this does not work - throws 404 error
                  // backgroundImage: NetworkImage(item.avatar ?? ''),
                  radius: 60.0,
                  backgroundColor: Colors.grey,
                ),
          subtitle: RichText(
            text: TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(
                    Icons.construction,
                    size: 17,
                    color: Colors.grey,
                  ),
                ),
                TextSpan(
                  text: item.c,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          trailing: RichText(
            text: const TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.star,
                    size: 17,
                    color: Colors.grey,
                  ),
                ),
                TextSpan(
                  text: "4.0",
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
  }

  Future<List<FreelancerModel>> getData(filter) async {
    String? token = await storage.read(key: "token");
    var response = await Dio().get(
      baseURL + "freelancerByCategory/${widget.catId}",
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
      return FreelancerModel.fromJsonList(data);
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
