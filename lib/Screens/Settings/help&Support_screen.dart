import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'contactUs_screen.dart';
import 'faq_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  final String? active_imgUrl;
  final String? activeAcc;
  final int? active_id;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const HelpSupportScreen({
    Key? key,
    required this.active_imgUrl,
    required this.active_id,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
    required this.email,
  }) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
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
          title: Text("Help & Support"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Terms & Conditions",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: widget.activeAcc == "seeker" ? null : 30,
              ),
              SizedBox(
                child: widget.activeAcc == "seeker"
                    ? null
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactUs(
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
                          child: Text(
                            "Contact Us",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FAQScreen(
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
                  child: Text(
                    "FAQ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "About Pik",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
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
