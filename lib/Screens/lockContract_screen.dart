import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LockContractScreen extends StatefulWidget {
  const LockContractScreen({Key? key}) : super(key: key);

  @override
  State<LockContractScreen> createState() => _LockContractScreenState();
}

class _LockContractScreenState extends State<LockContractScreen> {
  bool visibility = true;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibility,
      child: AlertDialog(
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
                'Please note that your contract will be locked once approved',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Icon(
                Icons.lock,
                color: Colors.grey,
                size: 200.0,
                textDirection: TextDirection.ltr,
                semanticLabel:
                    'Icon', // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
              ),
              SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    visibility = false;
                  });
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: HexColor("#60B781"),
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
