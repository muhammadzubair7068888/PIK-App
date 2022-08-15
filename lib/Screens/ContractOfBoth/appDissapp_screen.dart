import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../lockContract_screen.dart';
import 'contractsHistory_screen.dart';

class AppDissappScreen extends StatefulWidget {
  final int? receiverID;
  final int? contract_id;
  final String active_name;
  final String email;
  final int? active_id;
  final int? freelancer_id;
  final String? active_imgUrl;
  final String? activeAcc;

  const AppDissappScreen({
    Key? key,
    required this.email,
    required this.contract_id,
    required this.receiverID,
    required this.freelancer_id,
    required this.active_id,
    required this.active_name,
    required this.active_imgUrl,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<AppDissappScreen> createState() => _AppDissappScreenState();
}

class _AppDissappScreenState extends State<AppDissappScreen> {
  final storage = new FlutterSecureStorage();
  String f_name = "";
  String s_name = "";
  String f_country = "";
  String s_country = "";
  String f_city = "";
  String s_city = "";
  String f_address = "";
  String s_address = "";
  String f_nationality = "";
  String s_nationality = "";
  String f_passport = "";
  String s_passport = "";
  String start_date = "";
  String amount = "";

  Future contractDetail() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'contract/detail/${widget.contract_id}');
    String? token = await storage.read(key: "token");
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      var jsonBody = response.body;
      var jsonData = jsonDecode(jsonBody);
      if (this.mounted) {
        setState(() {
          f_name = jsonData["data"]["contract_first_parties"]["full_name"];
          s_name = jsonData["data"]["contract_second_parties"]["full_name"];
          f_country = jsonData["data"]["contract_first_parties"]["country"];
          s_country = jsonData["data"]["contract_second_parties"]["country"];
          f_city = jsonData["data"]["contract_first_parties"]["city"];
          s_city = jsonData["data"]["contract_second_parties"]["city"];
          f_address = jsonData["data"]["contract_first_parties"]["address"];
          s_address = jsonData["data"]["contract_second_parties"]["address"];
          f_nationality =
              jsonData["data"]["contract_first_parties"]["nationality"];
          s_nationality =
              jsonData["data"]["contract_second_parties"]["nationality"];
          f_passport =
              jsonData["data"]["contract_first_parties"]["passport_number"];
          s_passport =
              jsonData["data"]["contract_second_parties"]["passport_number"];
          start_date = jsonData["data"]["start_date"];
          start_date = start_date.substring(0, start_date.length - 9);
          amount = jsonData["data"]["contract_first_parties"]["project_amount"];
        });
      }
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Server Error",
      //   ),
      // );
    }
  }

  Future agree() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = widget.activeAcc == "seeker"
        ? Uri.parse(baseURL + 'contract/first-party/change/status')
        : Uri.parse(baseURL + 'contract/second-party/change/status');
    String? token = await storage.read(key: "token");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = new http.MultipartRequest(
      'POST',
      uri,
    )..headers.addAll(headers);

    request.fields['contract_id'] = widget.contract_id.toString();
    if (widget.activeAcc == "seeker") {
      request.fields['first_party_approval'] = "1";
    } else if (widget.activeAcc == "freelancer") {
      request.fields['second_party_approval'] = "1";
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: ContractsHistoryScreen(
            receiverID: widget.receiverID,
            active_name: widget.active_name,
            active_id: widget.active_id,
            freelancer_id: widget.freelancer_id,
            active_imgUrl: widget.active_imgUrl,
            email: widget.email,
            activeAcc: widget.activeAcc,
            navi: true,
          ),
        ),
        (route) => false,
      );

      _showTopFlash("#60B781", "Approved");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Approved",
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
  }

  Future disapproved() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = widget.activeAcc == "seeker"
        ? Uri.parse(baseURL + 'contract/first-party/change/status')
        : Uri.parse(baseURL + 'contract/second-party/change/status');
    String? token = await storage.read(key: "token");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = new http.MultipartRequest(
      'POST',
      uri,
    )..headers.addAll(headers);

    request.fields['contract_id'] = widget.contract_id.toString();
    if (widget.activeAcc == "seeker") {
      request.fields['first_party_approval'] = "0";
    } else if (widget.activeAcc == "freelancer") {
      request.fields['second_party_approval'] = "0";
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: ContractsHistoryScreen(
            receiverID: widget.receiverID,
            active_name: widget.active_name,
            active_id: widget.active_id,
            freelancer_id: widget.freelancer_id,
            email: widget.email,
            active_imgUrl: widget.active_imgUrl,
            activeAcc: widget.activeAcc,
            navi: true,
          ),
        ),
        (route) => false,
      );

      _showTopFlash("#60B781", "Disapproved");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Disapproved",
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
  }

  @override
  void initState() {
    super.initState();
    contractDetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
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
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 20,
                            ),
                            child: Text(
                              'Contract Form',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Service Delivery Contract",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "This contract is made, and enters into force on ${start_date}, by and between:",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.stop,
                              color: Colors.black,
                              size: 14,
                            ),
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "The First Party (the service requester),\n Name:  '${f_name}',\n Place of residence:  '${f_country}, ${f_city}',\n Address:  '${f_address}',\n Nationality:  '${f_nationality}',\n Passport Number:  '${f_passport}'",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.stop,
                              color: Colors.black,
                              size: 14,
                            ),
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "The Second Party (the service provider),\n Name:  '${s_name}',\n Place of residence:  '${s_country}, ${s_city}',\n Address:  '${s_address}',\n Nationality:  '${s_nationality}',\n Passport Number:  '${s_passport}'",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Preamble",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Whereas the first party provides its services at the request of the second party via PIK platform, including ${amount} USD, for a sum of money agreed by the two parties and  paid by the second party in accordance with this electronic contract’s terms.",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "This preamble shall be considered as an integral part of this contract, complementary  and supplementary to it, and the use policy agreed by both parties is a supplementary document to this contract.",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article One: Contract Documents",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "This contract consists of the following documents:",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "A- The Master Contract Document",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "B - The use policy agreed by the two parties",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "These documents shall be considered as one integrated unit, and each document shall be an integral part of the contract so that they explain and complete each other. In the event of a contradiction or conflict, the preceding document shall prevail over the following document.",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article two: Executed Works",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Under this contract, the first party shall provide the service requested by the second party, which is 'Hamza Iftikhar'. Services may not be amended without a written agreement of both parties after the conclusion of the contract.",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article Three: Contract Term",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "The two parties have agreed that the contract term shall be starting from the date of 2022/05/25 and ending on the date of 2022/05/30, (or by delivering the works before the expiry date of the contract, with the second party’s consent).",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article Four: Contract Value and Payment",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "The two parties have agreed that the service value is (${amount} USD) and shall be paid by the second party in one of the following methods:",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.stop,
                              color: Colors.black,
                              size: 12,
                            ),
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Bank transfer.",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.stop,
                              color: Colors.black,
                              size: 12,
                            ),
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Visa and MasterCard, providing a payment voucher to the first party.",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article Five: Validity of data and experience",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "The first party represents that all data, qualifications and experience presented in the first party’s approved profile on the platform are correct, which prompted the second party to contract with him to execute the services of this contract.",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article Six: Payment Currency",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "The payment currency shall be (in dollars) or any currency agreed by the two parties. The exchange rate shall not be included in the contract prices.",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article Seven: Delay Penalty",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "The two parties have agreed on a specific delay fine in the event of delay in the provision or delivery of the service by the first party other than what is set out in the third article of this contract, shall be (1%) of the contract value for each day of delay, provided that the total delay penalty shall not exceed (20%) From the contract value, in the event that this occurs, the second party shall have the right to execute the works at the expense of the first party at the prices prevailing on the platform at that time.",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article Eighth: Language",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Arabic shall be the prevailing language to be used in interpreting the terms of this contract. The two parties may select another language for this purpose. All correspondence between the two parties, notices, requests, consents, offers and claims shall be in the agreed language (contract language).",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article Nine: Termination of Contract",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Either party may terminate the contract upon a prior written notice (period to be determined by the two parties). The first party shall be entitled to receive the value of the works actually completed provided that all supporting plans, drawings and invoices are presented to the second party. However, the Platform fee payable under this contract shall not be affected or refunded by the termination of the contract.",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article Ten: Mechanism of Receipt and Delivery",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "The two parties agreed that the mechanism of delivery and receipt of works shall be indicated in the relevant minutes prepared by the First Party as set out in the Platform, or any other mechanism according to the following (   ).",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article Eleven: Dispute Settlement",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Any disputes or disagreements that may arise as a result of this contract shall be settled amicably between the two parties. In the event of failure by the two parties to reach an amicable resolution within 30 days following the date of dispute or disagreement, either party shall have the right to refer it to the competent judicial authority.",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Article Twelve: Governing Law and Jurisdiction",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "This contract shall be subject to and governed by the laws and regulations in force in the jurisdiction to which this platform is subject, and all other applicable international laws.",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "This Contract has been made in three counterparts, one of which for each of the parties to this contract, and one for the Platform.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  agree();
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                                highlightColor: HexColor("#60B781"),
                                child: Text(
                                  'Approve',
                                  style: TextStyle(
                                    color: HexColor("#60B781"),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  disapproved();
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                                highlightColor: Colors.grey,
                                child: Text(
                                  'Disapprove',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: LockContractScreen(),
              ),
            ],
          ),
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
