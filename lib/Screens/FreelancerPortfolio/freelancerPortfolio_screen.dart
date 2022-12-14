import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../Seeker/drawerWidgetSeeker.dart';
import '../donePortfolioWidget.dart';
import '../Freelancer/drawerWidgetFreelancer.dart';
import 'freelancerPortfolioDetail_screen.dart';

class FreelancerPortfolioScreen extends StatefulWidget {
  final int? active_id;
  final int? search_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  final String fromUpload;
  final String search_name;
  final String location;
  final String catName;
  final int? forPortfId;
  const FreelancerPortfolioScreen({
    Key? key,
    required this.email,
    required this.active_imgUrl,
    required this.fromUpload,
    required this.forPortfId,
    required this.location,
    required this.active_id,
    required this.freelancer_id,
    required this.search_id,
    required this.active_name,
    required this.search_name,
    required this.catName,
    required this.activeAcc,
  }) : super(key: key);

  @override
  _FreelancerPortfolioScreenState createState() =>
      _FreelancerPortfolioScreenState();
}

class _FreelancerPortfolioScreenState extends State<FreelancerPortfolioScreen> {
  final storage = new FlutterSecureStorage();
  var rows = <Widget>[];
  bool toggle = false;
  int? portId;
  int? res;
  String active_name = "";
  String location = "";
  bool visibility = true;

  Future getFreelancerInfo() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = widget.activeAcc == "seeker"
        ? Uri.parse(baseURL + 'freelancerS/${widget.search_id}')
        : Uri.parse(baseURL + 'freelancer/${widget.active_id}');
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
          active_name = jsonData["data"]["first_name"] +
              " " +
              jsonData["data"]["last_name"];
          location = jsonData["data"]["location"];
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future like(int id) async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = Uri.parse('${baseURL}portfolio/like');
    String? token = await storage.read(key: "token");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.MultipartRequest(
      'POST',
      uri,
    )..headers.addAll(headers);

    request.fields['portfolio_id'] = id.toString();

    var response = await request.send();
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      _showTopFlash("#60B781", "You liked the portfolio");
      setState(() {
        rows = <Widget>[];
      });
      portfolioById();
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  Future portfolioById() async {
    var url = widget.active_id == widget.search_id
        ? Uri.parse('${baseURL}freelancers/${widget.freelancer_id}/portfolios')
        : Uri.parse('${baseURL}freelancers/${widget.forPortfId}/portfolios');
    // var url = widget.activeAcc == "seeker"
    //     ? Uri.parse('${baseURL}freelancers/${widget.search_id}/portfolios')
    //     : Uri.parse('${baseURL}freelancers/${widget.freelancer_id}/portfolios');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    res = response.statusCode;
    if (response.statusCode == 200) {
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      if (mounted) {
        setState(
          () {
            for (var i = 0; i < jsonData["data"].length; i++) {
              rows.add(
                SizedBox(
                  width: 170,
                  height: 120,
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FreelancerPortfolioDetailScreen(
                                portfolio_id: jsonData["data"][i]["id"],
                                activeAcc: widget.activeAcc,
                                active_id: widget.active_id,
                                active_imgUrl: widget.active_imgUrl,
                                active_name: widget.active_name,
                                freelancer_id: widget.freelancer_id,
                                email: widget.email,
                              ),
                            ),
                          );
                        },
                        child: Image(
                          fit: BoxFit.cover,
                          width: 170,
                          height: 100,
                          image: NetworkImage(
                              "$baseURLImg${jsonData["data"][i]["thumbnail"]}"),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          jsonData["data"][i]["project_name"],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed:
                              jsonData["data"][i]["portfolio_liks"].length == 0
                                  ? () {
                                      like(jsonData["data"][i]["id"]);
                                    }
                                  : () {},
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Icon(
                              jsonData["data"][i]["portfolio_liks"].length == 0
                                  ? Icons.favorite_outline
                                  : Icons.favorite_outlined,
                              color: HexColor("#60B781"),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      }
      await EasyLoading.dismiss();
    } else if (response.statusCode == 404) {
      await EasyLoading.dismiss();
      _showTopFlash("#60B781", "No portfolio was found");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "No portfolio was found",
      //   ),
      // );
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  @override
  void initState() {
    super.initState();
    portfolioById();
    getFreelancerInfo();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        //asynchronous delay
        if (mounted) {
          //checks if widget is still active and not disposed
          setState(() {
            //tells the widget builder to rebuild again because ui has updated
            visibility =
                false; //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(
          email: widget.email,
          centerTitle: '',
          leading: true,
          active_id: widget.active_id,
          active_imgUrl: widget.active_imgUrl,
          nav: false,
          active_name: widget.active_name,
          activeAcc: widget.activeAcc,
          freelancer_id: widget.freelancer_id,
          notifi: false,
          no: null,
        ),
        drawer: widget.activeAcc == "seeker"
            ? DrawerWidgetSeeker(
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                email: widget.email,
                active_id: widget.active_id,
                freelancer_id: null,
              )
            : DrawerWidgetFreelancer(
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                active_id: widget.active_id,
                location: '',
                freelancer_id: widget.freelancer_id,
                email: widget.email,
              ),
        body: res == 200
            ? Container(
                child: Center(
                  child: Stack(
                    children: [
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      toggle = !toggle;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: toggle
                                            ? HexColor("#60B781")
                                            : Colors.grey,
                                      ),
                                      Text(
                                        '4.0',
                                        style: TextStyle(
                                          color: toggle
                                              ? HexColor("#60B781")
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            active_name,
                            style: const TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: widget.catName != ""
                                ? null
                                : Text(
                                    widget.catName,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.grey,
                              ),
                              Text(
                                location,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Wrap(
                            spacing: 20.0,
                            runSpacing: 20.0,
                            children: rows,
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          child: widget.fromUpload == 'true'
                              ? Visibility(
                                  visible: visibility,
                                  child: const DonePortfolioWidget(),
                                )
                              : null,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const Center(
                child: Text(
                  "There are no portfolio's",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
        bottomNavigationBar: widget.activeAcc == "seeker"
            ? BottomNavWidgetSeeker(
                email: widget.email,
                active_id: widget.active_id,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                freelancer_id: null,
              )
            : BottomNavWidgetFreelancer(
                email: widget.email,
                active_id: widget.active_id,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                freelancer_id: widget.freelancer_id,
              ),
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
