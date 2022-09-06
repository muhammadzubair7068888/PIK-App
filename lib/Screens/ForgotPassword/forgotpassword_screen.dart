import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import '../../Services/globals.dart';
import 'enterVerCode_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final storage = new FlutterSecureStorage();
  String _email = '';

  Future forgotPassword() async {
    if (_email.isNotEmpty) {
      await EasyLoading.show(
        status: 'Processing...',
        maskType: EasyLoadingMaskType.black,
      );
      var uri = Uri.parse(baseURL + 'password/forget');
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      };
      var request = new http.MultipartRequest(
        'POST',
        uri,
      )..headers.addAll(headers);

      request.fields['email'] = _email;

      var response = await request.send();
      if (response.statusCode == 201) {
        var responsed = await http.Response.fromStream(response);
        final responseData = json.decode(responsed.body);
        await EasyLoading.dismiss();
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: EnterVerCode(
              id: responseData["data"]["id"],
            ),
          ),
        );
        _showTopFlash("#60B781", "Verification code sent to your email");
        // showTopSnackBar(
        //   context,
        //   CustomSnackBar.success(
        //     message: "Verification code sent to your email",
        //   ),
        // );
      } else {
        await EasyLoading.dismiss();
        _showTopFlash("#ff3333", "Server Error");
        // showTopSnackBar(
        //   context,
        //   CustomSnackBar.error(
        //     message: "Error processing your request. Please try again",
        //   ),
        // );
      }
    } else {
      _showTopFlash("#ff3333", "Server Error");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Enter email.",
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Image.asset(
            "images/background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  child: Image.asset(
                    'images/pik.png',
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Enter your email here to reset your password",
                  style: TextStyle(
                    color: HexColor("#60B781"),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey[700],
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade700),
                          ),
                        ),
                        onChanged: (value) {
                          _email = value;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                FlatButton(
                  padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  highlightColor: HexColor("#60B781"),
                  color: HexColor("#60B781"),
                  splashColor: Colors.black12,
                  onPressed: () {
                    forgotPassword();
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showTopFlash(String color, String message) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 2),
      // persistent: false,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: HexColor(color),
          brightness: Brightness.light,
          boxShadows: const [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: FlashBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
            progressIndicatorBackgroundColor: Colors.white,
            progressIndicatorValueColor:
                AlwaysStoppedAnimation<Color>(HexColor(color)),
            showProgressIndicator: true,
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child:
                  const Text('DISMISS', style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }
}
