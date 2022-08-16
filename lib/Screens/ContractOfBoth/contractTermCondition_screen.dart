import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../Services/globals.dart';
import '../AppBar&Notification/appBarWidget.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import 'contractFormFreelancer_screen.dart';
import 'contractFormSeeker_screen.dart';

class contractTermCondition extends StatefulWidget {
  final int? receiverID;
  final String active_name;
  final String email;
  final int? active_id;
  final int? freelancer_id;
  final String? active_imgUrl;
  final String? activeAcc;

  const contractTermCondition({
    Key? key,
    required this.email,
    required this.receiverID,
    required this.freelancer_id,
    required this.active_id,
    required this.active_name,
    required this.active_imgUrl,
    required this.activeAcc,
  }) : super(key: key);

  @override
  _contractTermConditionState createState() => _contractTermConditionState();
}

class _contractTermConditionState extends State<contractTermCondition> {
  final storage = new FlutterSecureStorage();
  String? data = "";

  List<Widget> freelancer = <Widget>[
    Text(
      // data!,
      "Electronic Platform Use Terms and Conditions",
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(
      height: 20,
    ),
    Text(
      // data!,
      "These terms and conditions constitute a formal agreement (contract) between the electronic Platform “PIK” and its users.",
      style: TextStyle(
        color: Colors.black,
        fontSize: 13,
      ),
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform: is an interface electronic Platform (PIK) between the service provider and the service requester.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "Service Provider User: means any natural or legal person who benefits from the services provided by the electronic Platform where registration is required.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user's access to and use of this Platform shall be subject to the terms and conditions set out in this document.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user's access to and use of the Platform shall be an unconditional agreement to these terms and conditions.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user name, password and e-mail address of the user are very important and must be protected. If forgotten or hacked, the user must follow the procedures of the Platform so that their information and services are not abused or changed by others.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user represents that any information it provides through the Platform is complete, accurate, correct and up-to-date, and it shall be responsible for the content of any information or document submitted through the Platform.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform shall have the right to charge a registration fee in the future.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform charges fees for any services provided to customers through the Platform. Service providers shall refer to the percentage and rates table. (Annex 1)",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "Any fees payable by the user for providing services through the Platform shall be due for immediate payment through electronic transfer, Visa or MasterCard.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform may review the fees for any services provided at any time and without prior consent of the service provider. The fees may vary according to the services provided.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user shall always be honest in relation to the value and nature of the services. If any fraud, manipulation or abuse, is detected, the services will be suspended immediately without prior notice.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "In case of violation of any provision of the terms and conditions, the Platform shall have the right to terminate or suspend the user's access without prior notice and to sue it if the Platform incurs any damage as a result thereof.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user agrees to log in and use the Platform only for legal purposes. The user shall be solely responsible for posting or sharing any illegal content, including content that includes racial discrimination, libel, harassment, slander, insult, obscene or immoral act, or any other content that is related religion or Politics.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user shall observe decency in dealing with other users of the Platform.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform may have access to the private conversations between users for control and protection purposes.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The logo and identity of the Platform are registered trademark and copyright protected under the laws and regulations of the United Arab Emirates. In the event of a violation of its property by the users of the service, the Platform shall have the right to sue them.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "Service providers must not reuse or reproduce the services or imitate any trademarks or trade names that appear in the services by the Platform users.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform and all its content and the content of service providers, including - but not limited to - images, graphics, shapes, models, designs, etc. shall be protected by law. Therefore no Platform user may use, copy, quote, transfer or benefit therefrom, in whole or in part.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform disclaims any responsibility for any uncontrollable damage that may be caused by any viruses or any operational disruption. The Platform will maintain the validity of information and update its contents. However, the Platform does not guarantee that it will be free of errors, defects, malware or viruses, any of which will be addressed immediately.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "Any agreement between the user requesting the service and the service provider shall be an electronic contract between them (the contracting parties).",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform is a tool or means to link (the contracting parties); the service provider user with the other party requesting the service, therefore the Platform is not a party to the contractual relationship that arises between the user and the other party providing the service through the Platform from the moment the user requested the service. Hence, the Platform shall not bear any liability whatsoever, whether direct, indirect, incidental or consequential. The Platform disclaims any liability in connection with the service provided and the dealing between the contractors, any rights, obligations or responsibilities that may result therefrom. The liability shall rest with the contractors.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform acts as an interface between the contractors; the service provider user and the service requester, therefore the Platform does not guarantee in any way any material or moral damage that may be caused to the user as a result of a transaction, action, procedure, delay, error, omission, negligence, act, or what may be issued by the other contracting party through the Platform.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "In the event of a dispute, conflict, problem, misunderstanding, claim or lawsuit between the two contractors (the service provider and the service requester), neither of them shall have the right to ask the Platform to interfere or hand over information, data or documents related to the other party, in this case they must go to the competent authorities or courts.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "Selection of the service and its provider is a personal responsibility of the user solely. Therefore, the Platform does not however guarantee the user that none of the potential risks will occur, including, but not limited to, fraud, manipulation, defect, cheating, omission, procrastination, deficiency or any damage for any reason.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  ];

  List<Widget> seeker = <Widget>[
    Text(
      // data!,
      "Electronic Platform Use Terms and Conditions",
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(
      height: 20,
    ),
    Text(
      // data!,
      "These terms and conditions constitute a formal agreement (contract) between the electronic Platform “PIK” and its users.",
      style: TextStyle(
        color: Colors.black,
        fontSize: 13,
      ),
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform: is an interface electronic Platform (PIK) between the service provider and the service requester.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "Service Provider User: means any natural or legal person who benefits from the services provided by the electronic Platform where registration is required.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user's access to and use of this Platform shall be subject to the terms and conditions set out in this document.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user's access to and use of the Platform shall be an unconditional agreement to these terms and conditions.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform shall have the right to charge a registration fee in the future.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The platform may charge fees for benefiting from the services provided by the service providers and by the platform in the future.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user name, password and e-mail address of the user are very important and must be protected. If forgotten or hacked, the user must follow the procedures of the Platform so that their information and services are not abused or changed by others.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user represents that any information it provides through the Platform is complete, accurate, correct and up-to-date, and it shall be responsible for the content of any information or document submitted through the Platform.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "In case of violation of any provision of the terms and conditions, the Platform shall have the right to terminate or suspend the user's access without prior notice and to sue it if the Platform incurs any damage as a result thereof.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user agrees to log in and use the Platform only for legal purposes. The user shall be solely responsible for posting or sharing any illegal content, including content that includes racial discrimination, libel, harassment, slander, insult, obscene or immoral act, or any other content that is related religion or Politics.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The user shall observe decency in dealing with other users of the Platform.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform may have access to the private conversations between users for control and protection purposes.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The logo and identity of the Platform are registered trademark and copyright protected under the laws and regulations of the United Arab Emirates. In the event of a violation of its property by the users of the service, the Platform shall have the right to sue them.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "Service providers must not reuse or reproduce the services or imitate any trademarks or trade names that appear in the services by the Platform users.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform and all its content and the content of service providers, including - but not limited to - images, graphics, shapes, models, designs, etc. shall be protected by law. Therefore no Platform user may use, copy, quote, transfer or benefit therefrom, in whole or in part.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform disclaims any responsibility for any uncontrollable damage that may be caused by any viruses or any operational disruption. The Platform will maintain the validity of information and update its contents. However, the Platform does not guarantee that it will be free of errors, defects, malware or viruses, any of which will be addressed immediately.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "Any agreement between the user requesting the service and the service provider shall be an electronic contract between them (the contracting parties).",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform is a tool or means to link (the contracting parties); the service provider user with the other party requesting the service, therefore the Platform is not a party to the contractual relationship that arises between the user and the other party providing the service through the Platform from the moment the user requested the service. Hence, the Platform shall not bear any liability whatsoever, whether direct, indirect, incidental or consequential. The Platform disclaims any liability in connection with the service provided and the dealing between the contractors, any rights, obligations or responsibilities that may result therefrom. The liability shall rest with the contractors.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "The Platform acts as an interface between the contractors; the service provider user and the service requester, therefore the Platform does not guarantee in any way any material or moral damage that may be caused to the user as a result of a transaction, action, procedure, delay, error, omission, negligence, act, or what may be issued by the other contracting party through the Platform.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "In the event of a dispute, conflict, problem, misunderstanding, claim or lawsuit between the two contractors (the service provider and the service requester), neither of them shall have the right to ask the Platform to interfere or hand over information, data or documents related to the other party, in this case they must go to the competent authorities or courts.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 7,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            // data!,
            "Selection of the service and its provider is a personal responsibility of the user solely. Therefore, the Platform does not however guarantee the user that none of the potential risks will occur, including, but not limited to, fraud, manipulation, defect, cheating, omission, procrastination, deficiency or any damage for any reason.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  ];

  Future termCondition() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'contract/terms-and-conditions');
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
      if (jsonData["data"] == null) {
        if (this.mounted) {
          setState(() {
            data = "Terms & Conditions";
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            data = jsonData["data"]["contract_terms_conditions"];
          });
        }
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

  @override
  void initState() {
    termCondition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBarWidget(
          centerTitle: '',
          leading: true,
          active_id: widget.active_id,
          email: widget.email,
          active_imgUrl: widget.active_imgUrl,
          active_name: widget.active_name,
          activeAcc: widget.activeAcc,
          freelancer_id: widget.freelancer_id,
          nav: false,
          notifi: false,
          no: null,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 20,
                        ),
                        child: Text(
                          'Terms And Conditions',
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
                    Column(
                      children: widget.activeAcc == "freelancer"
                          ? freelancer
                          : seeker,
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: FlatButton(
                              onPressed: widget.activeAcc == 'seeker'
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ContractFormSeekerScreen(
                                            receiverID: widget.receiverID,
                                            active_imgUrl: widget.active_imgUrl,
                                            active_name: widget.active_name,
                                            activeAcc: widget.activeAcc,
                                            active_id: widget.active_id,
                                            freelancer_id: widget.freelancer_id,
                                            contract_id: null,
                                            email: widget.email,
                                          ),
                                        ),
                                      );
                                    }
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ContractFormFreelancerScreen(
                                            receiverID: widget.receiverID,
                                            active_imgUrl: widget.active_imgUrl,
                                            active_name: widget.active_name,
                                            email: widget.email,
                                            activeAcc: widget.activeAcc,
                                            active_id: widget.active_id,
                                            freelancer_id: widget.freelancer_id,
                                            contract_id: null,
                                          ),
                                        ),
                                      );
                                    },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              highlightColor: HexColor("#60B781"),
                              child: Text(
                                'Agree',
                                style: TextStyle(
                                  color: HexColor("#60B781"),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            highlightColor: Colors.grey,
                            child: Text(
                              'Disagree',
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
        ),
        bottomNavigationBar: widget.activeAcc == "seeker"
            ? BottomNavWidgetSeeker(
                active_id: widget.active_id,
                email: widget.email,
                activeAcc: widget.activeAcc,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
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
