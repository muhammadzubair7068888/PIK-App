import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:hexcolor/hexcolor.dart';

import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'advertise2_screen.dart';

class AdvertiseScreen1 extends StatefulWidget {
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const AdvertiseScreen1({
    Key? key,
    required this.email,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<AdvertiseScreen1> createState() => _AdvertiseScreen1State();
}

class _AdvertiseScreen1State extends State<AdvertiseScreen1> {
  DateTime? _sDate;
  DateTime? _eDate;
  String boxValue = "2";
  String _total = "";
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Image.asset(
            "images/background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBarWidget(
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
              email: widget.email,
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
                        const Text(
                          "Create Ad",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const Divider(
                          thickness: 1, // thickness of the line
                          indent:
                              20, // empty space to the leading edge of divider.
                          endIndent:
                              20, // empty space to the trailing edge of the divider.
                          color: Colors
                              .black, // The color to use when painting the line.
                          height: 20, // The divider's height extent.
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            "Expose your projects and tell people more about your services.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Choose your AD box",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "350 (H) x 80% (W)",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                RadioButton(
                                  description: "",
                                  value: "0",
                                  groupValue: boxValue,
                                  onChanged: (value) {
                                    setState(() {
                                      boxValue = value as String;
                                    });
                                  },
                                  activeColor: HexColor("#60B781"),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 75,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "200 (H) x 80% (W)",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                RadioButton(
                                  description: "",
                                  value: "1",
                                  groupValue: boxValue,
                                  onChanged: (value) {
                                    setState(() {
                                      boxValue = value as String;
                                    });
                                  },
                                  activeColor: HexColor("#60B781"),
                                ),
                              ],
                            ),
                          ],
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
                            labelText: 'Select Start Date and Time',
                          ),
                          autovalidateMode: AutovalidateMode.always,
                          validator: (DateTime? e) => (e?.day ?? 0) == 1
                              ? 'Please not the first day'
                              : null,
                          onDateSelected: (DateTime value) {
                            _sDate = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DateTimeFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.event_note),
                            labelText: 'Select End Date and Time',
                          ),
                          autovalidateMode: AutovalidateMode.always,
                          validator: (DateTime? e) => (e?.day ?? 0) == 1
                              ? 'Please not the first day'
                              : null,
                          onDateSelected: (DateTime value) {
                            _eDate = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Target Audience",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CountryStateCityPicker(
                          country: country,
                          state: state,
                          city: city,
                          textFieldInputBorder: OutlineInputBorder(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          onChanged: (value) {
                            _total = value;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Total in USD',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FlatButton(
                          padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          highlightColor: Colors.grey[400],
                          color: _sDate == null ||
                                  _eDate == null ||
                                  country.text.isEmpty ||
                                  city.text.isEmpty ||
                                  state.text.isEmpty ||
                                  _total == '' ||
                                  boxValue == "2"
                              ? Colors.grey
                              : HexColor("#60B781"),
                          splashColor: Colors.black12,
                          onPressed: _sDate == null ||
                                  _eDate == null ||
                                  country.text.isEmpty ||
                                  city.text.isEmpty ||
                                  state.text.isEmpty ||
                                  _total == '' ||
                                  boxValue == "2"
                              ? () {}
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdvertiseScreen2(
                                        sDate: _sDate,
                                        eDate: _eDate,
                                        boxValue: boxValue,
                                        total: _total,
                                        country: country.text,
                                        city: city.text,
                                        active_id: widget.active_id,
                                        active_imgUrl: widget.active_imgUrl,
                                        active_name: widget.active_name,
                                        activeAcc: widget.activeAcc,
                                        freelancer_id: widget.freelancer_id,
                                        email: widget.email,
                                      ),
                                    ),
                                  );
                                },
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: HexColor("#60B781"),
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
        ],
      ),
    );
  }
}
