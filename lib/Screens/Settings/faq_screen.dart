import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

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
      ),
    );
  }
}
