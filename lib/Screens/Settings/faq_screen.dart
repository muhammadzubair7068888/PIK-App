import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';

class FAQScreen extends StatefulWidget {
  final String? active_imgUrl;
  final String? activeAcc;
  final int? active_id;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const FAQScreen({
    Key? key,
    required this.active_imgUrl,
    required this.active_id,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
    required this.email,
  }) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
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
          title: Text("FAQ"),
        ),
        body: Column(
          children: [
            ListTile(
              onTap: () {},
              tileColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Text("How can I block user?"),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Text(
                    " of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin pro.fessor at Hampden-Sydney College in Virginia, loo."),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              onTap: () {},
              tileColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Text("How can I block user?"),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Text(
                    " of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin pro.fessor at Hampden-Sydney College in Virginia, loo."),
              ),
            ),
          ],
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
