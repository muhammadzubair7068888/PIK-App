import 'dart:async';
import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../Freelancer/freelancerHomePage_screen.dart';
import '../Seeker/seekerHomePage_screen.dart';
import 'notifications_screen.dart';

class AppBarWidget extends StatefulWidget with PreferredSizeWidget {
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final String active_name;
  final String email;
  final int? freelancer_id;
  final int? no;
  final String centerTitle;
  final bool leading;
  final bool notifi;
  final bool nav;

  const AppBarWidget({
    Key? key,
    required this.email,
    required this.centerTitle,
    required this.no,
    required this.leading,
    required this.notifi,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.activeAcc,
    required this.active_name,
    required this.nav,
  }) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  Timer? timer;
  int _status = 0;
  final storage = new FlutterSecureStorage();
  Future notifyCount() async {
    var url = Uri.parse(baseURL + 'notification/count');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      if (this.mounted) {
        setState(() {
          _status = jsonData["data"];
        });
      }
    } else {
      _showTopFlash("#ff3333", "Server Error");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Server Error",
      //   ),
      // );
    }
  }

  @override
  void initState() {
    // timer = Timer.periodic(Duration(seconds: 2), (Timer t) => notifyCount());
    notifyCount();
    super.initState();
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: HexColor("#333232"),
      leading: widget.leading
          ? IconButton(
              onPressed: widget.nav
                  ? () {
                      widget.activeAcc == "freelancer"
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const FreelancerHomePageScreen(),
                              ),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SeekerHomePageScreen(),
                              ),
                            );
                    }
                  : () {
                      Navigator.pop(context);
                    },
              icon: const Icon(
                Icons.arrow_back_ios,
              ),
            )
          : null,
      title: Text(widget.centerTitle),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            // showSearch(
            //   context: context,
            //   delegate: MySearchDelegate(),
            // );
          },
          icon: Icon(
            Icons.search,
            color: Color.fromARGB(62, 158, 158, 158),
            size: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Stack(
            children: [
              IconButton(
                onPressed: widget.notifi
                    ? () {}
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Notifications(
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
                icon: Icon(
                  Icons.notifications_none_rounded,
                  color: Color.fromARGB(62, 158, 158, 158),
                  size: 30,
                ),
              ),
              Positioned(
                top: 10,
                left: 4,
                child: widget.no == null
                    ? (_status == 0
                        ? Container()
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HexColor("#60B781"),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "${_status}",
                              style: TextStyle(fontSize: 10),
                            ),
                          ))
                    : (widget.no == 0 ? Container() : Container()),
              ),
            ],
          ),
        ),
      ],
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
          boxShadows: [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          child: FlashBar(
            content: Text(message, style: TextStyle(color: Colors.white)),
            progressIndicatorBackgroundColor: Colors.white,
            progressIndicatorValueColor:
                AlwaysStoppedAnimation<Color>(HexColor(color)),
            showProgressIndicator: true,
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child: Text('DISMISS', style: TextStyle(color: Colors.white)),
            ),
          ),
        );
      },
    );
  }
}

// class MySearchDelegate extends SearchDelegate {
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     IconButton(
//       onPressed: () {},
//       icon: Icon(Icons.clear),
//     );
//   }
//   @override
//   Widget? buildLeading(BuildContext context) {
//     IconButton(
//       onPressed: () {},
//       icon: Icon(Icons.arrow_back),
//     );
//   }
//   @override
//   Widget buildResults(BuildContext context) {
//     throw UnimplementedError();
//   }
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     throw UnimplementedError();
//   }
// }
