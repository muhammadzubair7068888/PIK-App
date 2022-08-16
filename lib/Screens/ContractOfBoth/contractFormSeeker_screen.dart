import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:date_field/date_field.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../Seeker/seekerHomePage_screen.dart';
import 'user_model.dart';

class ContractFormSeekerScreen extends StatefulWidget {
  final int? receiverID;
  final String email;
  final int? contract_id;
  final String active_name;
  final int? active_id;
  final int? freelancer_id;
  final String? active_imgUrl;
  final String? activeAcc;
  const ContractFormSeekerScreen({
    Key? key,
    required this.receiverID,
    required this.email,
    required this.contract_id,
    required this.freelancer_id,
    required this.active_id,
    required this.active_name,
    required this.active_imgUrl,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<ContractFormSeekerScreen> createState() =>
      _ContractFormSeekerScreenState();
}

class _ContractFormSeekerScreenState extends State<ContractFormSeekerScreen> {
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  final storage = new FlutterSecureStorage();
  String _singleValue = "0";
  String name = '';
  String _name = '';
  DateTime? _date;
  String _nationality = '';
  String _passport = '';
  String _country = '';
  int? free_id;
  String _city = '';
  String _address = '';
  String _mobile = '';
  String _email = '';
  String _details = '';
  String _amount = '';
  DateTime? _sDate;
  DateTime? _eDate;
  bool firstVal = false;

  Future savePressed() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = Uri.parse(baseURL + 'contract/first-party');
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
    if (widget.contract_id != null) {
      request.fields['contract_id'] = "${widget.contract_id}";
      request.fields['country'] = _country;
      request.fields['full_name'] = _name;
      request.fields['dob'] = _date.toString();
      request.fields['nationality'] = _nationality;
      request.fields['passport_number'] = _passport;
      request.fields['address'] = _address;
      request.fields['mobile'] = _mobile;
      request.fields['email'] = _email;
      request.fields['project_details'] = _details;
      request.fields['project_amount'] = _amount;
      request.fields['start_date'] = _sDate.toString();
      request.fields['end_date'] = _eDate.toString();
      request.fields['seeker_type'] = _singleValue;
      request.fields['city'] = _city;
    } else {
      request.fields['freelancer_id'] = free_id.toString();
      request.fields['country'] = _country;
      request.fields['full_name'] = _name;
      request.fields['name'] = name;
      request.fields['dob'] = _date.toString();
      request.fields['nationality'] = _nationality;
      request.fields['passport_number'] = _passport;
      request.fields['address'] = _address;
      request.fields['mobile'] = _mobile;
      request.fields['email'] = _email;
      request.fields['project_details'] = _details;
      request.fields['project_amount'] = _amount;
      request.fields['start_date'] = _sDate.toString();
      request.fields['end_date'] = _eDate.toString();
      request.fields['seeker_type'] = _singleValue;
      request.fields['city'] = _city;
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          // child: ContractsHistoryScreen(
          //   receiverID: widget.receiverID,
          //   active_name: widget.active_name,
          //   active_id: widget.active_id,
          //   freelancer_id: widget.freelancer_id,
          //   active_imgUrl: widget.active_imgUrl,
          //   activeAcc: widget.activeAcc,
          //   navi: true,
          // ),
          child: SeekerHomePageScreen(),
        ),
        (route) => false,
      );
      _showTopFlash("#60B781", "Contract has been sent successfully");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Contract has been sent successfully",
      //   ),
      // );
    } else if (response.statusCode == 422) {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Fill all the required fields");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Fill all the required fields",
      //   ),
      // );
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Error processing your request. Please try again",
      //   ),
      // );
    }
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "First Party Details :",
                          style: TextStyle(
                            color: HexColor("#60B781"),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    RadioButton(
                      description: "Business",
                      value: "0",
                      groupValue: _singleValue,
                      onChanged: (value) {
                        setState(() {
                          _singleValue = value as String;
                        });
                      },
                      activeColor: HexColor("#60B781"),
                    ),
                    RadioButton(
                      description: "Individual",
                      value: "1",
                      groupValue: _singleValue,
                      onChanged: (value) {
                        setState(() {
                          _singleValue = value as String;
                        });
                      },
                      activeColor: HexColor("#60B781"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: widget.contract_id == null
                          ? DropdownSearch<UserModel>(
                              onChanged: (value) {
                                free_id = value!.id;
                              },
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Select freelancer",
                                hintText: "Select freelancer",
                              )),
                              asyncItems: (String? filter) => getData(filter),
                              popupProps:
                                  PopupPropsMultiSelection.modalBottomSheet(
                                showSelectedItems: true,
                                itemBuilder: _customPopupItemBuilderExample2,
                                showSearchBox: true,
                              ),
                              compareFn: (item, sItem) => item.id == sItem.id,
                            )
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: widget.contract_id == null
                          ? TextField(
                              onChanged: (value) {
                                name = value;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Contract Name',
                              ),
                            )
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        _name = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Full name (as it appears on passport)',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Date of birth',
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
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        _nationality = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nationality',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        _passport = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Passport no',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CountryStateCityPicker(
                      country: country,
                      state: state,
                      city: city,
                      textFieldInputBorder: OutlineInputBorder(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        _address = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Home Address',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        _mobile = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Mobile no',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        _email = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email Address',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        _details = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Project Details',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        _amount = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Project Amount in USD',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Start Date',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) => (e?.day ?? 0) == 1
                          ? 'Please not the first day'
                          : null,
                      onDateSelected: (DateTime value) {
                        _sDate = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'End Date',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) => (e?.day ?? 0) == 1
                          ? 'Please not the first day'
                          : null,
                      onDateSelected: (DateTime value) {
                        _eDate = value;
                      },
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: firstVal,
                          fillColor:
                              MaterialStateProperty.all(HexColor("#60B781")),
                          checkColor: Colors.white,
                          activeColor: HexColor("#60B781"),
                          onChanged: (bool? value) {
                            setState(() {
                              firstVal = value!;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            'I confirm that information above is correct',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Please note that information provided can't be changed in the future",
                      style: TextStyle(
                        color: HexColor("#60B781"),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                      highlightColor:
                          firstVal ? HexColor("#60B781") : Colors.grey[400],
                      color: firstVal ? HexColor("#60B781") : Colors.grey[400],
                      splashColor: Colors.black12,
                      onPressed: firstVal
                          ? () {
                              setState(() {
                                _country = "${country.text}";
                                _city = "${city.text}";
                              });
                              savePressed();
                            }
                          : () {},
                      child: Text(
                        "Start a Contract",
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
        bottomNavigationBar: BottomNavWidgetSeeker(
          active_id: widget.active_id,
          email: widget.email,
          activeAcc: widget.activeAcc,
          active_imgUrl: widget.active_imgUrl,
          active_name: widget.active_name,
          freelancer_id: null,
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

  Widget _customPopupItemBuilderExample2(
    BuildContext context,
    UserModel? item,
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
                  child: ClipOval(
                    child: Image.network(
                      "${baseURLImg}${item.avatar}",
                      width: 60,
                      height: 60,
                      fit: BoxFit.fill,
                    ),
                  ),
                  radius: 60.0,
                  backgroundColor: Colors.grey,
                )
              : CircleAvatar(
                  // this does not work - throws 404 error
                  // backgroundImage: NetworkImage(item.avatar ?? ''),
                  radius: 60.0,
                  backgroundColor: Colors.grey,
                ),
        ),
      ),
    );
  }

  Future<List<UserModel>> getData(filter) async {
    String? token = await storage.read(key: "token");
    var response = await Dio().get(
      baseURL + "freelancer/seeker/all",
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
      return UserModel.fromJsonList(data);
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
