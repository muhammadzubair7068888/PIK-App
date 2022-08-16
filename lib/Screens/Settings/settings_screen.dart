import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'accountSettings_screen.dart';
import 'adSettings_screen.dart';
import 'appliesContracts_screen.dart';
import 'help&Support_screen.dart';
import 'notificationSettings_screen.dart';
import 'privacy&Security_screen.dart';

class SettingScreen extends StatefulWidget {
  final String? active_imgUrl;
  final int? active_id;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const SettingScreen({
    Key? key,
    required this.email,
    required this.freelancer_id,
    required this.active_imgUrl,
    required this.active_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
          centerTitle: true,
          title: Text("Settings"),
        ),
        body: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountSettingScreen(
                      active_id: widget.active_id,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      activeAcc: widget.activeAcc,
                      email: widget.email,
                      freelancer_id: widget.freelancer_id,
                    ),
                  ),
                );
              },
              tileColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppliesContractScreen(
                      email: widget.email,
                      active_id: widget.active_id,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      activeAcc: widget.activeAcc,
                      freelancer_id: widget.freelancer_id,
                    ),
                  ),
                );
              },
              tileColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Applies & Contracts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationSettingScreen(
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
              tileColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Notifications",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacySecurityScreen(
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
              tileColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Privacy & Security",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpSupportScreen(
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
              tileColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Help & Support",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ADSettingScreen(
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
              tileColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "AD Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
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
