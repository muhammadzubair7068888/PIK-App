import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flash/flash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect/multiselect.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../Freelancer/freelancerPersonalInfo_screen.dart';
import 'seekerBussinPersonalInfo_screen.dart';
import 'seekerHomePage_screen.dart';

class SeekerIndivPersonalInfoScreen extends StatefulWidget {
  final String email;
  const SeekerIndivPersonalInfoScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _SeekerIndivPersonalInfoScreenState createState() =>
      _SeekerIndivPersonalInfoScreenState();
}

class _SeekerIndivPersonalInfoScreenState
    extends State<SeekerIndivPersonalInfoScreen> {
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  Timer? timer;
  bool f = false;
  bool l = false;
  bool loc = false;
  bool p = false;
  bool g = false;
  bool w = false;
  bool fd = false;
  bool s = false;
  bool lan = false;
  bool ab = false;
  bool btnCheck = false;

  var items = [];
  var specs = [];
  var lang = [];
  List<String> languages = [];
  List<String> selected = [];
  List<String> specialties = [];
  String? selectedValue;
  List gender = ['Male', 'Female', 'Other'];
  File? _image;
  String _firstname = '';
  String _lastname = '';
  String _address = '';
  var pwdWidgets = <Widget>[];
  String _phone = '';
  String _website = '';
  String _about = '';
  final picker = ImagePicker();
  final storage = new FlutterSecureStorage();

  Future choiceImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (this.mounted) {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        setState(() {});
      } else {}
    }
  }

  Future fields() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'fields');
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
      return "success";
    }
  }

  Future Specialities() async {
    var url = Uri.parse(baseURL + 'Specialities');
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
          specs = jsonData["data"];
        });
      }
    } else {
      return "success";
    }
  }

  Future language() async {
    var url = Uri.parse(baseURL + 'language');
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
          lang = jsonData["data"];
        });
      }
      await EasyLoading.dismiss();
    } else {
      return "success";
    }
  }

  Future switchAccount() async {
    var url = Uri.parse(baseURL + 'switch-account');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }

  Future savePressed() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = Uri.parse(baseURL + 'registerSeeker');
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
    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
    }
    String? userid = await storage.read(key: "userId");
    request.fields['user_id'] = userid!;
    request.fields['type'] = "1";
    request.fields['location'] = _address;
    request.fields['first_name'] = _firstname;
    request.fields['last_name'] = _lastname;
    request.fields['phone[]'] = _phone;
    if (selectedValue != null) {
      request.fields['gender'] = selectedValue!;
    }
    request.fields['website'] = _website;
    request.fields['about'] = _about;

    for (String item in selected) {
      request.files.add(http.MultipartFile.fromString('field_id[]', item));
    }
    for (String item in specialties) {
      request.files
          .add(http.MultipartFile.fromString('specialties_id[]', item));
    }
    for (String item in languages) {
      request.files.add(http.MultipartFile.fromString('language_id[]', item));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      await storage.write(
        key: "type",
        value: "seeker",
      );
      // switchAccount();
      await EasyLoading.dismiss();
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: SeekerHomePageScreen(),
        ),
        (route) => false,
      );
      _showTopFlash("#60B781", "Success");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Success",
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
    if (f == true &&
        l == true &&
        country.text != "" &&
        city.text != "" &&
        p == true &&
        g == true &&
        w == true &&
        fd == true &&
        s == true &&
        lan == true &&
        ab == true) {
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
    fields();
    Specialities();
    language();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checking());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // drawer: DrawerWidget(),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.grey[850],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            color: Colors.transparent,
                            child: Text(
                              'Join as freelancer',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[700],
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FreelancerPersonalInfoScreen(
                                    email: widget.email,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            color: Colors.transparent,
                            highlightColor: HexColor("#60B781"),
                            child: Text(
                              'Find a freelancer',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: HexColor("#60B781"),
                              ),
                            ),
                            onPressed: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: _image == null
                        ? <Widget>[
                            CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.grey[300],
                            ),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white70,
                              child: IconButton(
                                onPressed: () {
                                  choiceImage();
                                },
                                icon: Icon(
                                  Icons.photo_camera,
                                  color: HexColor("#60B781"),
                                ),
                              ),
                            ),
                          ]
                        : <Widget>[
                            CircleAvatar(
                              radius: 60.0,
                              child: ClipOval(
                                child: Image.file(
                                  File(_image!.path).absolute,
                                  fit: BoxFit.cover,
                                  width: 120.0,
                                  height: 120.0,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white70,
                              child: IconButton(
                                onPressed: () {
                                  // choiceImage();
                                },
                                icon: Icon(
                                  Icons.photo_camera,
                                  color: HexColor("#60B781"),
                                ),
                              ),
                            ),
                          ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'Finish up your profile to start exploring!',
                    style:
                        TextStyle(color: HexColor("#60B781"), fontSize: 16.5),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    color: Colors.grey[850],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            color: Colors.transparent,
                            child: Text(
                              'Individual',
                              style: TextStyle(
                                color: HexColor("#60B781"),
                              ),
                            ),
                            onPressed: null,
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            color: Colors.transparent,
                            highlightColor: HexColor("#60B781"),
                            child: Text(
                              'Business',
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SeekerBussinPersonalInfoScreen(
                                    email: widget.email,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 40,
                      right: 40,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Personal Information',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                // obscureText: true,
                                onChanged: (value) {
                                  _firstname = value;
                                  setState(() {
                                    f = true;
                                  });
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'Firstname',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: TextField(
                                // obscureText: true,
                                onChanged: (value) {
                                  _lastname = value;
                                  setState(() {
                                    l = true;
                                  });
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  labelText: 'Lastname',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CountryStateCityPicker(
                          country: country,
                          state: state,
                          city: city,
                          textFieldInputBorder: OutlineInputBorder(),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          // obscureText: true,
                          onChanged: (value) {
                            _phone = value;
                            setState(() {
                              p = true;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            labelText: 'Phone',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          // obscureText: true,
                          controller: TextEditingController(text: widget.email),
                          keyboardType: TextInputType.number,
                          enabled: false,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField2(
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                            ),
                            isExpanded: true,
                            hint: Text(
                              'Gender',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: gender.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
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
                                g = true;
                              });
                            },
                            buttonHeight: 40,
                            buttonWidth: 140,
                            itemHeight: 40,
                          ),
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Divider(
                      color: Colors.black54,
                      thickness: 1,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 40,
                      right: 40,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: DropDownMultiSelect(
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            onChanged: (List<String> x) {
                              setState(() {
                                selected = x;
                                fd = true;
                              });
                            },
                            options: (items)
                                .map((e) => e["name"] as String)
                                .toList(),
                            // options: ["hello"],
                            selectedValues: selected,
                            whenEmpty: 'Fields',
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: DropDownMultiSelect(
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            onChanged: (List<String> x) {
                              setState(() {
                                specialties = x;
                                s = true;
                              });
                            },
                            options: (specs)
                                .map((e) => e["name"] as String)
                                .toList(),
                            // options: ["hello"],
                            selectedValues: specialties,
                            whenEmpty: 'Specialties',
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: DropDownMultiSelect(
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            onChanged: (List<String> x) {
                              setState(() {
                                languages = x;
                                lan = true;
                              });
                            },
                            options:
                                (lang).map((e) => e["name"] as String).toList(),
                            // options: ["hello"],
                            selectedValues: languages,
                            whenEmpty: 'Languages',
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextField(
                          onChanged: (value) {
                            _website = value;
                            setState(() {
                              w = true;
                            });
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            labelText: 'Website',
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          onChanged: (value) {
                            _about = value;
                            setState(() {
                              ab = true;
                            });
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 5,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 14),
                            labelText: 'About',
                            alignLabelWithHint: true,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        FlatButton(
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          highlightColor: btnCheck
                              ? HexColor("#60B781")
                              : Color.fromARGB(151, 158, 158, 158),
                          color: btnCheck
                              ? HexColor("#60B781")
                              : Color.fromARGB(151, 158, 158, 158),
                          splashColor: Colors.black12,
                          onPressed: btnCheck
                              ? () {
                                  setState(() {
                                    _address = "${country.text}, ${city.text}";
                                  });
                                  savePressed();
                                }
                              : () {
                                  null;
                                },
                          child: Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
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
