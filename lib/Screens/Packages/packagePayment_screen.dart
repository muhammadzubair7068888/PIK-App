import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Freelancer/freelancerHomePage_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../SignUp_SignIn/termConditionWidget.dart';

class PackagePayment extends StatefulWidget {
  final String p_name;
  final String p_price;
  final String? p_textOne;
  final String p_textTwo;
  final String p_id;
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const PackagePayment({
    Key? key,
    required this.email,
    required this.p_id,
    required this.p_name,
    required this.p_price,
    required this.p_textOne,
    required this.p_textTwo,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<PackagePayment> createState() => _PackagePaymentState();
}

class _PackagePaymentState extends State<PackagePayment> {
  final storage = new FlutterSecureStorage();
  bool firstVal = false;
  String total = '';
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future transaction() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = Uri.parse(baseURL + 'transaction/freelancer');
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

    request.fields['amount'] = widget.p_price;
    request.fields['package_id'] = widget.p_id;

    var response = await request.send();
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          child: FreelancerHomePageScreen(),
        ),
        (route) => false,
      );
      _showTopFlash("#60B781", "Successfully buyed applies");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "Successfully buyed applies.",
      //   ),
      // );
    } else if (response.statusCode == 422) {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Fill all the required fields");
    } else {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Server Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return (SafeArea(
      child: Stack(
        children: [
          Image.asset(
            "images/background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBarWidget(
              email: widget.email,
              centerTitle: '',
              leading: true,
              active_id: widget.active_id,
              nav: false,
              active_imgUrl: widget.active_imgUrl,
              active_name: widget.active_name,
              activeAcc: widget.activeAcc,
              freelancer_id: widget.freelancer_id,
              notifi: false,
              no: null,
            ),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          widget.p_name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          child: widget.p_textOne == ""
                              ? Text(
                                  "Finished your applies for this month then found a project you think is a perfect opportunity for you?",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  "${widget.p_textOne}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text.rich(
                          TextSpan(
                            text: '${widget.p_textTwo} ',
                            children: <TextSpan>[
                              TextSpan(
                                text: 'for only \u0024${widget.p_price}',
                                style: TextStyle(
                                  color: HexColor("#60B781"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CheckboxListTile(
                          side: BorderSide(
                            color: Colors.black,
                          ),
                          contentPadding: EdgeInsets.zero,
                          title: Transform.translate(
                            offset: const Offset(-12, 0),
                            child: Row(
                              children: [
                                const Text(
                                  "I Agree to the ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        //  data[index]["check"]
                                        //     ? Colors.white
                                        //     :
                                        Colors.black,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const TermConditionWidget();
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "terms and conditions",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: HexColor("#60B781"),
                          checkColor: Colors.white,
                          value: firstVal,
                          onChanged: (value) {
                            setState(() {
                              firstVal = value!;
                            });
                          },
                        ),
                        Column(
                          children: [
                            CreditCardForm(
                              formKey: formKey,
                              obscureCvv: true,
                              obscureNumber: true,
                              cardNumber: cardNumber,
                              cvvCode: cvvCode,
                              isHolderNameVisible: true,
                              isCardNumberVisible: true,
                              isExpiryDateVisible: true,
                              cardHolderName: cardHolderName,
                              expiryDate: expiryDate,
                              themeColor: Colors.blue,
                              textColor: Colors.black,
                              cardNumberDecoration: InputDecoration(
                                labelText: 'Number',
                                hintText: 'XXXX XXXX XXXX XXXX',
                                hintStyle: const TextStyle(color: Colors.black),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: border,
                                enabledBorder: border,
                              ),
                              expiryDateDecoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.black),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: border,
                                enabledBorder: border,
                                labelText: 'Expired Date',
                                hintText: 'XX/XX',
                              ),
                              cvvCodeDecoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.black),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: border,
                                enabledBorder: border,
                                labelText: 'CVV',
                                hintText: 'XXX',
                              ),
                              cardHolderDecoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.black),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: border,
                                enabledBorder: border,
                                labelText: 'Card Holder',
                              ),
                              onCreditCardModelChange: onCreditCardModelChange,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Row(
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 70,
                                        width: 70,
                                        child: Image.asset(
                                          'images/card1.png',
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: Image.asset(
                                          'images/card2.png',
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Image.asset(
                                          'images/card3.png',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: const <Widget>[
                                      SizedBox(
                                          //   height: 70,
                                          //   width: 70,
                                          // ),
                                          // SizedBox(
                                          //   height: 40,
                                          //   width: 40,
                                          // ),
                                          // SizedBox(
                                          //   height: 50,
                                          //   width: 50,
                                          ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: TextFormField(
                            initialValue: '\u0024 ${widget.p_price}',
                            enabled: false,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              total = value;
                            },
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Total',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FlatButton(
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          highlightColor:
                              firstVal ? HexColor("#60B781") : Colors.grey,
                          color: firstVal ? HexColor("#60B781") : Colors.grey,
                          splashColor: Colors.black12,
                          onPressed: firstVal
                              ? () {
                                  transaction();
                                }
                              : () {},
                          child: Text(
                            "Buy Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Cancel"),
                        ),
                      ],
                    ),
                  ),
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
          )
        ],
      ),
    ));
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
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
