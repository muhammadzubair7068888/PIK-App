import 'dart:convert';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Services/globals.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  final int? active_id;
  final String? active_imgUrl;
  final String? activeAcc;
  final String active_name;
  final String email;
  final int? freelancer_id;
  const ChatListScreen({
    required this.email,
    required this.active_id,
    required this.active_imgUrl,
    required this.freelancer_id,
    required this.activeAcc,
    required this.active_name,
    Key? key,
  }) : super(key: key);
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final storage = new FlutterSecureStorage();
  int? receiverID;
  int? chatID;
  var data;
  int count = 0;
  int chId = 0;

  Future getChatLists() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = Uri.parse(baseURL + 'chats/list');
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
          if (jsonData["data"] != null) {
            count = jsonData["data"][0].length;
          }
          if (jsonData["data"] != null) {
            data = jsonData["data"][0];
          } else {
            data = null;
          }
        });
      }
      await EasyLoading.dismiss();
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
    getChatLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
              ),
            ),
          ],
        ),
        body: data == null
            ? Center(
                child: Text(
                  "There are no chat's",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: count,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Slidable(
                    key: const ValueKey(0),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(
                        onDismissed: () {
                          Future delChat() async {
                            await EasyLoading.show(
                              status: 'Loading...',
                              maskType: EasyLoadingMaskType.black,
                            );
                            var url = Uri.parse(
                                baseURL + 'chat/${data[index]["id"]}/delete');
                            String? token = await storage.read(key: "token");
                            http.Response response =
                                await http.get(url, headers: {
                              'Content-Type': 'application/json',
                              'Accept': 'application/json',
                              'Authorization': 'Bearer $token',
                            });
                            if (response.statusCode == 200) {
                              await EasyLoading.dismiss();
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

                          delChat();
                        },
                      ),
                      children: const [
                        SlidableAction(
                          onPressed: doNothing,
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              receiverID: data[index]["value"][0]["user_id"],
                              active_imgUrl: widget.active_imgUrl,
                              active_name: widget.active_name,
                              activeAcc: widget.activeAcc,
                              active_id: widget.active_id,
                              freelancer_id: widget.freelancer_id,
                              chatID: data[index]["id"],
                              email: widget.email,
                            ),
                          ),
                        );
                      },
                      leading: Container(
                        // ignore: unnecessary_null_comparison
                        child: data[index]["value"][0]["user"]["avatar"] == null
                            ? CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.grey[300],
                              )
                            : CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    "${baseURLImg}${data[index]["value"][0]["user"]["avatar"]}"),
                              ),
                      ),
                      title: Text(
                        data[index]["value"][0]["user"]["username"],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        data[index]["value"][0]["last_message"],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text("18:04"),
                    ),
                  );
                },
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

void doNothing(BuildContext context) {}
