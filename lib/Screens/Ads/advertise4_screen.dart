import 'package:flash/flash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Freelancer/freelancerHomePage_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../Seeker/seekerHomePage_screen.dart';

class AdvertiseScreen4 extends StatefulWidget {
  final DateTime? sDate;
  final DateTime? eDate;
  final String? total;
  final String? country;
  final String? city;
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  final String id;
  const AdvertiseScreen4({
    Key? key,
    required this.email,
    required this.id,
    required this.sDate,
    required this.eDate,
    required this.total,
    required this.country,
    required this.city,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<AdvertiseScreen4> createState() => _AdvertiseScreen4State();
}

class _AdvertiseScreen4State extends State<AdvertiseScreen4> {
  final storage = new FlutterSecureStorage();
  bool firstVal = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isCvvFocused = false;
  String cvvCode = '';
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;

  Future transation() async {
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var uri = Uri.parse(baseURL + 'transaction');
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

    request.fields['amount'] = widget.total!;
    request.fields['ad_id'] = widget.id;

    var response = await request.send();
    // var responseS = await http.Response.fromStream(response);
    // final result = jsonDecode(responseS.body);
    if (response.statusCode == 200) {
      await EasyLoading.dismiss();
      if (widget.activeAcc == "freelancer") {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: FreelancerHomePageScreen(),
          ),
          (route) => false,
        );
      } else if (widget.activeAcc == "seeker") {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: SeekerHomePageScreen(),
          ),
          (route) => false,
        );
      }
      _showTopFlash("#60B781", "Success");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.success(
      //     message: "success",
      //   ),
      // );
    } else if (response.statusCode == 422) {
      await EasyLoading.dismiss();
      _showTopFlash("#ff3333", "Fill all the required fields");
      // showTopSnackBar(
      //   context,
      //   CustomSnackBar.error(
      //     message: "Fill all the required fields",
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
              centerTitle: '',
              leading: true,
              active_id: widget.active_id,
              active_imgUrl: widget.active_imgUrl,
              email: widget.email,
              active_name: widget.active_name,
              activeAcc: widget.activeAcc,
              freelancer_id: widget.freelancer_id,
              nav: false,
              notifi: false,
              no: null,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Create Ad",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        Divider(
                          thickness: 1, // thickness of the line
                          indent:
                              20, // empty space to the leading edge of divider.
                          endIndent:
                              20, // empty space to the trailing edge of the divider.
                          color: Colors
                              .black, // The color to use when painting the line.
                          height: 20, // The divider's height extent.
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            "Expose your projects and tell people more about your services.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Upload",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Preview",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Finish",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Divider(
                          thickness: 1, // thickness of the line
                          indent:
                              20, // empty space to the leading edge of divider.
                          endIndent:
                              20, // empty space to the trailing edge of the divider.
                          color: Colors
                              .black, // The color to use when painting the line.
                          height: 20, // The divider's height extent.
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            "Your ad will start on ${widget.sDate.toString().substring(0, 16)} and end on ${widget.eDate.toString().substring(0, 16)} in ${widget.country}, ${widget.city}.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Total Price ${widget.total} USD",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: firstVal,
                                fillColor: MaterialStateProperty.all(
                                    HexColor("#60B781")),
                                checkColor: Colors.white,
                                activeColor: HexColor("#60B781"),
                                onChanged: (bool? value) {
                                  setState(() {
                                    firstVal = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  'I Agree to the terms and conditions',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Please fill in payment info',
                          style: TextStyle(
                            color: Colors.red,
                          ),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                              padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                              highlightColor: Colors.grey[400],
                              color: cardNumber == "" ||
                                      expiryDate == "" ||
                                      cardHolderName == "" ||
                                      cvvCode == "" ||
                                      firstVal == false
                                  ? Colors.grey
                                  : HexColor("#60B781"),
                              splashColor: Colors.black12,
                              onPressed: () {
                                transation();
                              },
                              child: Text(
                                "Buy Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: HexColor("#60B781"),
                                ),
                              ),
                            ),
                          ],
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
                    active_id: widget.active_id,
                    active_imgUrl: widget.active_imgUrl,
                    active_name: widget.active_name,
                    activeAcc: widget.activeAcc,
                    freelancer_id: widget.freelancer_id,
                    email: widget.email,
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
