import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import '../Chat/chatList_screen.dart';
import '../ContractOfBoth/contractTermCondition_screen.dart';
import '../FreelancerPortfolio/freelancerSelectPortfolioPic_screen.dart';
import '../Packages/selectPackage_screen.dart';
import 'freelancerHomePage_screen.dart';

class BottomNavWidgetFreelancer extends StatefulWidget {
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final int? freelancer_id;
  final String active_name;
  final String email;
  const BottomNavWidgetFreelancer({
    Key? key,
    required this.email,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.active_name,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<BottomNavWidgetFreelancer> createState() =>
      _BottomNavWidgetFreelancerState();
}

class _BottomNavWidgetFreelancerState extends State<BottomNavWidgetFreelancer> {
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
                PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  child: FreelancerHomePageScreen(),
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
                onPressed: () {},
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
                                                  active_id: widget.active_id,
                                                  activeAcc: widget.activeAcc,
                                                  active_imgUrl:
                                                      widget.active_imgUrl,
                                                  active_name:
                                                      widget.active_name,
                                                  freelancer_id:
                                                      widget.freelancer_id,
                                                  receiverID: null,
                                                  email: widget.email,
                                                ),
                                              ),
                                            );
                                          },
                                          shape: const CircleBorder(),
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
                                        const Text(
                                          'Buy a Package',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        RaisedButton(
                                          highlightColor: HexColor("#60B781"),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SelectPackage(
                                                  active_id: widget.active_id,
                                                  active_imgUrl:
                                                      widget.active_imgUrl,
                                                  active_name:
                                                      widget.active_name,
                                                  activeAcc: widget.activeAcc,
                                                  freelancer_id:
                                                      widget.freelancer_id,
                                                  email: widget.email,
                                                ),
                                              ),
                                            );
                                          },
                                          shape: const CircleBorder(),
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
                                        const SizedBox(
                                          height: 40,
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text(
                                          'Upload Portfolio',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        RaisedButton(
                                          highlightColor: HexColor("#60B781"),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FreelancerSelectPortfolioPicScreen(
                                                  active_id: widget.active_id,
                                                  active_imgUrl:
                                                      widget.active_imgUrl,
                                                  active_name:
                                                      widget.active_name,
                                                  activeAcc: widget.activeAcc,
                                                  freelancer_id:
                                                      widget.freelancer_id,
                                                  email: widget.email,
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
