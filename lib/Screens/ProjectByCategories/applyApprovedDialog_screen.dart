import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../Chat/chat_screen.dart';
import '../Seeker/seekerHomePage_screen.dart';

class ApplyApprovedDialog extends StatefulWidget {
  final String? active_imgUrl;
  final int? active_id;
  final int? chatID;
  final int? freelancer_id;
  final int? receiverID;
  final String? activeAcc;
  final String active_name;
  final String email;
  final String free_name;
  const ApplyApprovedDialog({
    Key? key,
    required this.email,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.chatID,
    required this.receiverID,
    required this.active_id,
    required this.free_name,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<ApplyApprovedDialog> createState() => _ApplyApprovedDialogState();
}

class _ApplyApprovedDialogState extends State<ApplyApprovedDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(206, 0, 0, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Container(
        margin: EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        height: 400.0,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              'Apply Approved!',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: Image.asset(
                      'images/Group 533.png',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Image.asset(
                      'images/checkcircle.png',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Image.asset(
                      'images/Group 533.png',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      email: widget.email,
                      receiverID: widget.receiverID,
                      active_imgUrl: widget.active_imgUrl,
                      active_name: widget.active_name,
                      activeAcc: widget.activeAcc,
                      active_id: widget.active_id,
                      freelancer_id: widget.freelancer_id,
                      chatID: null,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.chat_bubble),
              label: Text('Start a chat with ${widget.free_name}'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: SeekerHomePageScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                "Close",
                style: TextStyle(color: Colors.grey[400]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
