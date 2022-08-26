import 'package:flutter/material.dart';

class DonePortfolioWidget extends StatefulWidget {
  const DonePortfolioWidget({Key? key}) : super(key: key);

  @override
  State<DonePortfolioWidget> createState() => _DonePortfolioWidgetState();
}

class _DonePortfolioWidgetState extends State<DonePortfolioWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(206, 0, 0, 0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: Container(
        margin: const EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        height: 350.0,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Done!',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
            Row(
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
            SizedBox(
              height: 40.0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                "This project is now added to your Portfolio.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
