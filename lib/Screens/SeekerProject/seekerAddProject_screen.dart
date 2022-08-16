import 'dart:convert';

import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:multiselect/multiselect.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../Seeker/drawerWidgetSeeker.dart';
import 'seekerProjectList_screen.dart';

class SeekerAddProjectScreen extends StatefulWidget {
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const SeekerAddProjectScreen({
    Key? key,
    required this.email,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  _SeekerAddProjectScreenState createState() => _SeekerAddProjectScreenState();
}

class _SeekerAddProjectScreenState extends State<SeekerAddProjectScreen> {
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  List<String> skills = [];
  String? selected;
  String? selectedValue;
  String _pname = '';
  DateTime? _date;
  String _location = '';
  String _range = '';
  String _desc = '';

  var items = [];
  var skill = [];
  var linkProj = [];

  final storage = new FlutterSecureStorage();

  Future projects() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'allSeekerProject');
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
          linkProj = jsonData["data"];
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future categories() async {
    var url = Uri.parse(baseURL + 'categories');
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
          items = jsonData["data"];
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future getSkill() async {
    var url = Uri.parse(baseURL + 'skills');
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
          skill = jsonData["data"];
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future addProjectPress() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = Uri.parse(baseURL + 'uploadSeekerProject');
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

    request.fields['location'] = _location;
    request.fields['name'] = _pname;
    request.fields['due_date'] = _date.toString();
    request.fields['budget'] = _range;
    request.fields['description'] = _desc;
    request.fields['category_id'] = selected!;

    if (selectedValue != null) {
      request.fields['sub_project_id'] = selectedValue!;
    }
    for (String item in skills) {
      request.files.add(http.MultipartFile.fromString('skill_id[]', item));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: SeekerProjectListScreen(
            email: widget.email,
            active_id: widget.active_id,
            activeAcc: widget.activeAcc,
            active_imgUrl: widget.active_imgUrl,
            active_name: widget.active_name,
            freelancer_id: widget.freelancer_id,
          ),
        ),
        (route) => false,
      );
      _showTopFlash("#60B781", "Project uploaded successfully");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Project uploaded successfully",
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

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      categories();
      getSkill();
      projects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBarWidget(
          centerTitle: '',
          leading: true,
          active_id: widget.active_id,
          email: widget.email,
          active_imgUrl: widget.active_imgUrl,
          nav: false,
          active_name: widget.active_name,
          activeAcc: widget.activeAcc,
          freelancer_id: widget.freelancer_id,
          notifi: false,
          no: null,
        ),
        drawer: DrawerWidgetSeeker(
          active_imgUrl: widget.active_imgUrl,
          active_name: widget.active_name,
          email: widget.email,
          activeAcc: widget.activeAcc,
          active_id: widget.active_id,
          freelancer_id: null,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(
              10,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Link project (optional)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        items: linkProj.map((i) {
                          return DropdownMenuItem(
                            value: i["name"],
                            child: Text(
                              i["name"],
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: 140,
                        itemHeight: 40,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                        ),
                        isExpanded: true,
                        hint: Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        items: items.map((i) {
                          return DropdownMenuItem(
                            value: i["name"],
                            child: Text(
                              i["name"],
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        value: selected,
                        onChanged: (value) {
                          setState(() {
                            selected = value as String;
                          });
                        },
                        buttonHeight: 40,
                        buttonWidth: 140,
                        itemHeight: 40,
                      ),
                    ),
                    // DropDownMultiSelect(
                    //   decoration: InputDecoration(
                    //       contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                    //   onChanged: (List<String> x) {
                    //     setState(() {
                    //       selected = x;
                    //     });
                    //   },
                    //   options: (items).map((e) => e["name"] as String).toList(),
                    //   // options: ["hello"],
                    //   selectedValues: selected,
                    //   whenEmpty: 'Select Category',
                    // ),
                    DropDownMultiSelect(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      onChanged: (List<String> x) {
                        setState(() {
                          skills = x;
                        });
                      },
                      options: (skill).map((e) => e["name"] as String).toList(),
                      // options: ["hello"],
                      selectedValues: skills,
                      whenEmpty: 'Skills',
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      // obscureText: true,
                      onChanged: (value) {
                        _pname = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Project Name',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Due Date',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) => (e?.day ?? 0) == 1
                          ? 'Please not the first day'
                          : null,
                      onDateSelected: (DateTime value) {
                        _date = value;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CountryStateCityPicker(
                      country: country,
                      state: state,
                      city: city,
                      textFieldInputBorder: OutlineInputBorder(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      // obscureText: true,
                      onChanged: (value) {
                        _range = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Budget Range (USD)',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      onChanged: (value) {
                        _desc = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Project Description',
                        // hintText: 'About',
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
                        setState(() {
                          _location = "${country.text} ${city.text}";
                        });
                        addProjectPress();
                      },
                      child: Text(
                        "Add Project",
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
          ),
        ),
        bottomNavigationBar: widget.activeAcc == "seeker"
            ? BottomNavWidgetSeeker(
                active_id: widget.active_id,
                active_imgUrl: widget.active_imgUrl,
                email: widget.email,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                freelancer_id: widget.freelancer_id,
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
