import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';

class ContactUs extends StatefulWidget {
  final String? active_imgUrl;
  final int? active_id;
  final String? activeAcc;
  final String active_name;
  final int? freelancer_id;
  final String email;
  const ContactUs({
    Key? key,
    required this.email,
    required this.freelancer_id,
    required this.active_imgUrl,
    required this.active_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          title: Text("Get in Touch"),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: FaIcon(FontAwesomeIcons.twitter),
                    //   color: HexColor("#60B781"),
                    // ),
                    // SizedBox(
                    //   width: 30,
                    // ),
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.facebookF),
                      color: HexColor("#60B781"),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.instagram),
                      color: HexColor("#60B781"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Send Us a Message",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  onChanged: (value) {
                    // _address = value;
                  },
                  decoration: InputDecoration(
                    fillColor: HexColor("#60B781"),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#60B781"),
                      ),
                    ),
                    labelText: 'Name',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  onChanged: (value) {
                    // _address = value;
                  },
                  decoration: InputDecoration(
                    fillColor: HexColor("#60B781"),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#60B781"),
                      ),
                    ),
                    labelText: 'Email',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  onChanged: (value) {
                    // _address = value;
                  },
                  decoration: InputDecoration(
                    fillColor: HexColor("#60B781"),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#60B781"),
                      ),
                    ),
                    labelText: 'Phone',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  onChanged: (value) {
                    // _address = value;
                  },
                  decoration: InputDecoration(
                    fillColor: HexColor("#60B781"),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: HexColor("#60B781"),
                      ),
                    ),
                    labelText: 'Subject',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  onChanged: (value) {
                    // _about = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your Message',
                    // hintText: 'About',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                FlatButton(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  highlightColor: HexColor("#60B781"),
                  color: HexColor("#60B781"),
                  splashColor: Colors.black12,
                  onPressed: () {},
                  child: const Text(
                    "Send",
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
        bottomNavigationBar: widget.activeAcc == "seeker"
            ? BottomNavWidgetSeeker(
                active_id: widget.active_id,
                email: widget.email,
                activeAcc: widget.activeAcc,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
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
}
