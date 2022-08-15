import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import '../Chat/chatList_screen.dart';
import '../ContractOfBoth/contractTermCondition_screen.dart';
import '../SeekerProject/seekerAddProject_screen.dart';
import 'seekerHomePage_screen.dart';

class BottomNavWidgetSeeker extends StatefulWidget {
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final String active_name;
  final String email;
  final int? freelancer_id;
  const BottomNavWidgetSeeker({
    Key? key,
    required this.email,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.activeAcc,
    required this.active_name,
  }) : super(key: key);

  @override
  State<BottomNavWidgetSeeker> createState() => _BottomNavWidgetSeekerState();
}

class _BottomNavWidgetSeekerState extends State<BottomNavWidgetSeeker> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: HexColor("#333232"),
      child: Row(
        children: [
          SizedBox(
            width: 40,
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeekerHomePageScreen(),
                ),
              );
            },
            color: Colors.white,
            iconSize: 30,
          ),
          Spacer(),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.circle),
                color: Colors.white,
                iconSize: 35,
                onPressed: () {
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black.withOpacity(0.6),
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext buildContext,
                          Animation animation, Animation secondaryAnimation) {
                        return Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            padding: EdgeInsets.all(20),
                            // color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Start a Contract',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            // Navigator.of(context).pop();
                                          },
                                          shape: CircleBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.text_snippet_outlined,
                                              color: HexColor("#60B781"),
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Buy a Package',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            // Navigator.of(context).pop();
                                          },
                                          shape: CircleBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons
                                                  .account_balance_wallet_outlined,
                                              color: HexColor("#60B781"),
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Add a Project',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RaisedButton(
                                          highlightColor: HexColor("#60B781"),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeekerAddProjectScreen(
                                                  email: widget.email,
                                                  active_id: widget.active_id,
                                                  activeAcc: widget.activeAcc,
                                                  active_imgUrl:
                                                      widget.active_imgUrl,
                                                  active_name:
                                                      widget.active_name,
                                                  freelancer_id:
                                                      widget.freelancer_id,
                                                ),
                                              ),
                                            );
                                          },
                                          shape: CircleBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.upload_file_outlined,
                                              color: HexColor("#60B781"),
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 60,
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: HexColor("#60B781"),
                iconSize: 35,
                onPressed: () {
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black.withOpacity(0.6),
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext buildContext,
                          Animation animation, Animation secondaryAnimation) {
                        return Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            padding: EdgeInsets.all(20),
                            // color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Start a Contract',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RaisedButton(
                                          highlightColor: HexColor("#60B781"),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    contractTermCondition(
                                                  email: widget.email,
                                                  active_id: widget.active_id,
                                                  activeAcc: widget.activeAcc,
                                                  active_imgUrl:
                                                      widget.active_imgUrl,
                                                  active_name:
                                                      widget.active_name,
                                                  freelancer_id:
                                                      widget.freelancer_id,
                                                  receiverID: null,
                                                ),
                                              ),
                                            );
                                          },
                                          shape: CircleBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.text_snippet_outlined,
                                              color: HexColor("#60B781"),
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Buy a Package',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            // Navigator.of(context).pop();
                                          },
                                          shape: CircleBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons
                                                  .account_balance_wallet_outlined,
                                              color: HexColor("#60B781"),
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Add a Project',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RaisedButton(
                                          highlightColor: HexColor("#60B781"),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SeekerAddProjectScreen(
                                                  active_id: widget.active_id,
                                                  email: widget.email,
                                                  activeAcc: widget.activeAcc,
                                                  active_imgUrl:
                                                      widget.active_imgUrl,
                                                  active_name:
                                                      widget.active_name,
                                                  freelancer_id:
                                                      widget.freelancer_id,
                                                ),
                                              ),
                                            );
                                          },
                                          shape: CircleBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.upload_file_outlined,
                                              color: HexColor("#60B781"),
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 60,
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  child: ChatListScreen(
                    email: widget.email,
                    active_id: widget.active_id,
                    active_imgUrl: widget.active_imgUrl,
                    active_name: widget.active_name,
                    activeAcc: widget.activeAcc,
                    freelancer_id: widget.freelancer_id,
                  ),
                ),
              );
            },
            color: Colors.white,
            iconSize: 28,
          ),
          SizedBox(
            width: 40,
          ),
        ],
      ),
    );
  }
}
