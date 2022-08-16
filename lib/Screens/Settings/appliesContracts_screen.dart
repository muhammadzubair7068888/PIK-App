import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../applyHistory_screen.dart';
import 'packages_screen.dart';
import 'contractHistDrw_screen.dart';
import 'contractHistDrw_screen.dart';

class AppliesContractScreen extends StatefulWidget {
  final String? active_imgUrl;
  final int? freelancer_id;
  final int? active_id;
  final String? activeAcc;
  final String active_name;
  final String email;
  const AppliesContractScreen({
    Key? key,
    required this.freelancer_id,
    required this.email,
    required this.active_imgUrl,
    required this.active_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<AppliesContractScreen> createState() => _AppliesContractScreenState();
}

class _AppliesContractScreenState extends State<AppliesContractScreen> {
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
          centerTitle: true,
          title: Text("Applies & Contracts"),
        ),
        body: widget.activeAcc == 'seeker'
            ? Column(
                children: [
                  ListTile(
                    tileColor: Colors.white,
                    title: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Manage Contracts",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FromDrawer(
                                receiverID: null,
                                chatID: null,
                                active_name: widget.active_name,
                                active_id: widget.active_id,
                                freelancer_id: null,
                                active_imgUrl: widget.active_imgUrl,
                                activeAcc: widget.activeAcc,
                                email: widget.email,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Contracts History",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ContractFormSeekerScreen(),
                          //   ),
                          // );
                        },
                        child: Text(
                          "Contract Form",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    tileColor: Colors.white,
                    title: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Manage Applications",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplyHistory(
                                active_id: widget.active_id,
                                active_imgUrl: widget.active_imgUrl,
                                email: widget.email,
                                active_name: widget.active_name,
                                activeAcc: widget.activeAcc,
                                freelancer_id: widget.active_id,
                                receiverID: null,
                                seekProj_id: null,
                                type: '',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Apply History",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackageScreen(
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
                        child: Text(
                          "Packages",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const ListTile(
                    tileColor: Colors.white,
                    title: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Manage Contracts",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FromDrawer(
                                receiverID: null,
                                chatID: null,
                                email: widget.email,
                                active_name: widget.active_name,
                                active_id: widget.active_id,
                                freelancer_id: null,
                                active_imgUrl: widget.active_imgUrl,
                                activeAcc: widget.activeAcc,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Contracts History",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: TextButton(
                  //       onPressed: () {
                  //         // Navigator.push(
                  //         //   context,
                  //         //   MaterialPageRoute(
                  //         //     builder: (context) => ContractFormSeekerScreen(),
                  //         //   ),
                  //         // );
                  //       },
                  //       child: Text(
                  //         "Contract Form",
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                ],
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
}
