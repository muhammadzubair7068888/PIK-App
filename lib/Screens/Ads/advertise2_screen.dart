import 'dart:io';

import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'advertise3_screen.dart';

class AdvertiseScreen2 extends StatefulWidget {
  final DateTime? sDate;
  final DateTime? eDate;
  final String? boxValue;
  final String? total;
  final String? country;
  final String? city;
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const AdvertiseScreen2({
    Key? key,
    required this.sDate,
    required this.eDate,
    required this.email,
    required this.boxValue,
    required this.total,
    required this.country,
    required this.city,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<AdvertiseScreen2> createState() => _AdvertiseScreen2State();
}

class _AdvertiseScreen2State extends State<AdvertiseScreen2> {
  bool firstVal = false;
  File? singleImage;
  String _secondValue = "0";
  String title = "";
  String description = "";

  final singlePicker = ImagePicker();
  final multiPicker = ImagePicker();
  List<XFile>? images = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (SafeArea(
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
              email: widget.email,
              nav: false,
              notifi: false,
              no: null,
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
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Create Ad",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        Divider(
                          thickness: 1, // thickness of the line
                          indent:
                              20, // empty space to the leading edge of divider.
                          endIndent:
                              20, // empty space to the trailing edge of the divider.
                          color: Colors
                              .black, // The color to use when painting the line.
                          height: 20, // The divider's height extent.
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            "Expose your projects and tell people more about your services.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Upload",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Preview",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Finish",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Column(
                          children: [
                            Text("Upload file"),
                            IconButton(
                              onPressed: () {
                                getSingleImage();
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: HexColor("#60B781"),
                              ),
                              iconSize: 40,
                            ),
                          ],
                        ),
                        SizedBox(
                          child: singleImage != null && widget.boxValue == "0"
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: singleImage == null
                                      ? null
                                      : Image.file(
                                          File(singleImage!.path),
                                          fit: BoxFit.fill,
                                          height: 350,
                                          width: 350,
                                        ),
                                )
                              : singleImage != null && widget.boxValue == "1"
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: singleImage == null
                                          ? null
                                          : Image.file(
                                              File(singleImage!.path),
                                              fit: BoxFit.fill,
                                              height: 200,
                                              width: 350,
                                            ),
                                    )
                                  : null,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          onChanged: (value) {
                            title = value;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Title',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                          onChanged: (value) {
                            description = value;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                            // hintText: 'About',
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RadioButton(
                          description: "Link to your profile",
                          value: "0",
                          groupValue: _secondValue,
                          onChanged: (value) {
                            setState(() {
                              _secondValue = value as String;
                            });
                          },
                          activeColor: HexColor("#60B781"),
                        ),
                        Row(
                          children: [
                            RadioButton(
                              description: "Other",
                              value: "1",
                              groupValue: _secondValue,
                              onChanged: (value) {
                                setState(() {
                                  _secondValue = value as String;
                                });
                              },
                              activeColor: HexColor("#60B781"),
                            ),
                            Flexible(
                              child: SizedBox(
                                height: 30,
                                child: TextField(
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: firstVal,
                              fillColor: MaterialStateProperty.all(
                                  HexColor("#60B781")),
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
                                'I Agree to the terms and conditions',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                              padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                              highlightColor: Colors.grey[400],
                              color: HexColor("#60B781"),
                              splashColor: Colors.black12,
                              onPressed: () {},
                              child: Text(
                                "Back",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            FlatButton(
                              padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                              highlightColor: Colors.grey[400],
                              color: singleImage == null ||
                                      title == "" ||
                                      description == "" ||
                                      firstVal == false
                                  ? Colors.grey
                                  : HexColor("#60B781"),
                              splashColor: Colors.black12,
                              onPressed: singleImage == null ||
                                      title == "" ||
                                      description == "" ||
                                      firstVal == false
                                  ? () {}
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AdvertiseScreen3(
                                            sDate: widget.sDate,
                                            eDate: widget.eDate,
                                            boxValue: widget.boxValue,
                                            total: widget.total,
                                            country: widget.country,
                                            city: widget.city,
                                            active_id: widget.active_id,
                                            active_imgUrl: widget.active_imgUrl,
                                            active_name: widget.active_name,
                                            activeAcc: widget.activeAcc,
                                            freelancer_id: widget.freelancer_id,
                                            description: description,
                                            secondValue: _secondValue,
                                            singleImage: singleImage,
                                            title: title,
                                            email: widget.email,
                                          ),
                                        ),
                                      );
                                    },
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
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
                    active_name: widget.active_name,
                    email: widget.email,
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
          )
        ],
      ),
    ));
  }

  Future getSingleImage() async {
    final pickedImage =
        // ignore: deprecated_member_use
        await singlePicker.getImage(source: (ImageSource.gallery));
    if (this.mounted) {
      setState(() {
        if (pickedImage != null) {
          singleImage = File(pickedImage.path);
        } else {}
      });
    }
  }

  Future getMultiImages() async {
    final List<XFile>? selectedImages = await multiPicker.pickMultiImage();
    if (this.mounted) {
      setState(() {
        if (selectedImages != null) {
          images!.addAll(selectedImages);
        } else {}
      });
    }
  }
}
