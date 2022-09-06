import 'dart:convert';
import 'package:flash/flash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import '../../Services/globals.dart';
import '../../controller/chat_controller.dart';
import '../../model/message.dart';
import '../ContractOfBoth/contractTermCondition_screen.dart';
import '../Freelancer/bottomNavWidgetFreelancer_screen.dart';
import '../Freelancer/freelancerProfile_screen.dart';
import '../Seeker/bottomNavWidgetSeeker.dart';
import '../Seeker/seekerProfile_screen.dart';

class ChatScreen extends StatefulWidget {
  final int? receiverID;
  final int? chatID;
  final String active_name;
  final String email;
  final int? active_id;
  final int? freelancer_id;
  final String? active_imgUrl;
  final String? activeAcc;
  const ChatScreen({
    Key? key,
    required this.email,
    required this.receiverID,
    required this.chatID,
    required this.freelancer_id,
    required this.active_id,
    required this.active_name,
    required this.active_imgUrl,
    required this.activeAcc,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgInputController = TextEditingController();
  late IO.Socket socket;
  ChatController chatController = ChatController();
  String? imgUrl;
  int? id;
  int? pId;
  String? name;
  String? lname;
  String? data;
  final storage = const FlutterSecureStorage();
  // ignore: prefer_typing_uninitialized_variables
  var _chatID;
  String? _message;
  final ScrollController _controller = ScrollController();
  // ignore: prefer_typing_uninitialized_variables
  var mess;

  Future getReceiverInfo() async {
    await EasyLoading.show(
      status: 'Loading...',
      maskType: EasyLoadingMaskType.black,
    );
    var url = widget.activeAcc == "seeker"
        ? Uri.parse('${baseURL}freelancerforchat/${widget.receiverID}')
        : Uri.parse('${baseURL}seekerforchat/${widget.receiverID}');
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
      print(jsonData);
      if (mounted) {
        setState(() {
          // data = jsonData["data"]["image"];
          if (jsonData["data"]["image"] != null) {
            imgUrl = jsonData["data"]["image"];
          } else {
            imgUrl = null;
          }
          if (jsonData["data"]["first_name"] == null &&
              jsonData["data"]["last_name"] == null) {
            name = jsonData["data"]["business_name"];
          } else {
            name = jsonData["data"]["first_name"] +
                " " +
                jsonData["data"]["last_name"];
          }
          id = jsonData["data"]["id"];
          pId = jsonData["data"]["user_id"];
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

  Future getMess() async {
    var uri = Uri.parse(baseURL + 'chat/messages');
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
    if (widget.chatID != null) {
      request.fields['chat_id'] = widget.chatID.toString();
    }
    if (widget.activeAcc == 'seeker') {
      request.fields['user_type'] = 'freelancer';
    } else {
      request.fields['user_type'] = 'seeker';
    }
    if (widget.receiverID != null) {
      request.fields['user_id'] = widget.receiverID.toString();
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);
      if (this.mounted) {
        setState(() {
          _chatID = responseData["0"];
          for (var i = 0; i < responseData["messages"].length; i++) {
            if (widget.activeAcc == 'seeker' &&
                responseData["messages"][i]["chat_user"]["user_type"] ==
                    'seeker') {
              var messageJson = {
                'message': responseData["messages"][i]["message"],
                'sentByMe': widget.active_id,
              };
              chatController.chatMessages.add(Message.fromJson(messageJson));
            } else if (widget.activeAcc == 'freelancer' &&
                responseData["messages"][i]["chat_user"]["user_type"] ==
                    'freelancer') {
              var messageJson = {
                'message': responseData["messages"][i]["message"],
                'sentByMe': widget.active_id,
              };
              chatController.chatMessages.add(Message.fromJson(messageJson));
            } else {
              var messageJson = {
                'message': responseData["messages"][i]["message"],
                'sentByMe': widget.receiverID,
              };
              chatController.chatMessages.add(Message.fromJson(messageJson));
            }
          }
        });
      }
    }
  }

  Future sendMess() async {
    var uri = Uri.parse(baseURL + 'chat/message/send');
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
    if (widget.chatID == null) {
      if (_chatID != null) {
        request.fields['chat_id'] = _chatID.toString();
      }
      if (widget.activeAcc == 'seeker') {
        request.fields['user_type'] = 'freelancer';
      } else {
        request.fields['user_type'] = 'seeker';
      }
      request.fields['user_id'] = widget.receiverID.toString();
      request.fields['message'] = _message!;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responsed = await http.Response.fromStream(response);
        final responseData = json.decode(responsed.body);
        _chatID = responseData["data"]["chat_id"];
      }
    } else {
      request.fields['chat_id'] = widget.chatID.toString();
      if (widget.activeAcc == 'seeker') {
        request.fields['user_type'] = 'freelancer';
      } else {
        request.fields['user_type'] = 'seeker';
      }
      request.fields['user_id'] = widget.receiverID.toString();
      request.fields['message'] = _message!;

      // ignore: unused_local_variable
      var response = await request.send();
    }
  }

  @override
  void initState() {
    socket = IO.io(
        chatURL,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    setUpSocketListener();
    getReceiverInfo();
    getMess();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          toolbarHeight: 70.0,
          backgroundColor: HexColor("#333232"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Row(
            children: [
              Container(
                child: imgUrl != null
                    ? InkWell(
                        onTap: () {
                          widget.activeAcc == "freelancer"
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SeekerProfileScreen(
                                      activeAcc: widget.activeAcc,
                                      active_id: widget.active_id,
                                      active_imgUrl: widget.active_imgUrl,
                                      active_name: widget.active_name,
                                      search_id: id,
                                      freelancer_id: widget.freelancer_id,
                                      email: widget.email,
                                    ),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FreelancerProfileScreen(
                                      activeAcc: widget.activeAcc,
                                      active_id: widget.active_id,
                                      active_imgUrl: widget.active_imgUrl,
                                      active_name: widget.active_name,
                                      search_id: id,
                                      freelancer_id: widget.freelancer_id,
                                      email: widget.email,
                                      forPortfId: id,
                                    ),
                                  ),
                                );
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          child: ClipOval(
                            child: Image.network(
                              "$baseURLImg2$imgUrl",
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          widget.activeAcc == "freelancer"
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SeekerProfileScreen(
                                      activeAcc: widget.activeAcc,
                                      active_id: widget.active_id,
                                      active_imgUrl: widget.active_imgUrl,
                                      active_name: widget.active_name,
                                      search_id: id,
                                      freelancer_id: widget.freelancer_id,
                                      email: widget.email,
                                    ),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FreelancerProfileScreen(
                                      activeAcc: widget.activeAcc,
                                      active_id: widget.active_id,
                                      active_imgUrl: widget.active_imgUrl,
                                      active_name: widget.active_name,
                                      search_id: id,
                                      freelancer_id: widget.freelancer_id,
                                      email: widget.email,
                                      forPortfId: id,
                                    ),
                                  ),
                                );
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Text(
                  "${name}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(
                Icons.online_prediction,
                color: Colors.green,
              )
            ],
          ),
        ),
        endDrawer: Drawer(
          backgroundColor: Colors.black,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => contractTermCondition(
                          receiverID: widget.receiverID,
                          active_imgUrl: widget.active_imgUrl,
                          email: widget.email,
                          active_name: widget.active_name,
                          activeAcc: widget.activeAcc,
                          active_id: widget.active_id,
                          freelancer_id: widget.freelancer_id,
                        ),
                      ),
                    );
                  },
                  title: const Text(
                    'Start a Contract',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  leading: const Icon(
                    Icons.pages,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                Container(
                  child: widget.activeAcc == 'seeker'
                      ? ListTile(
                          onTap: () {},
                          title: const Text(
                            'Add People',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          leading: const Icon(
                            Icons.people,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        )
                      : ListTile(
                          onTap: () {},
                          title: const Text(
                            'Add People',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          leading: const Icon(
                            Icons.people,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                ),
                ListTile(
                  onTap: () {},
                  title: const Text(
                    'Archive',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  leading: const Icon(
                    Icons.archive,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: const Text(
                    'Report',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  leading: const Icon(
                    Icons.report,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: const Text(
                    'Block',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  leading: const Icon(
                    Icons.block,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: chatController.chatMessages.length,
                    // reverse: true,
                    shrinkWrap: true,
                    controller: _controller,
                    itemBuilder: (context, index) {
                      var currentItem = chatController.chatMessages[index];
                      return MessageItem(
                        sentByMe: currentItem.sentByMe == widget.active_id,
                        message: currentItem.message,
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    controller: msgInputController,
                    onChanged: (value) {
                      _message = value;
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Type message here',
                        suffixIcon: Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: HexColor("#60B781"),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _controller.animateTo(
                                  _controller.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                              sendMessage(msgInputController.text);
                              msgInputController.text = '';
                              sendMess();
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.activeAcc == "seeker"
            ? BottomNavWidgetSeeker(
                active_id: widget.active_id,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                email: widget.email,
                activeAcc: widget.activeAcc,
                freelancer_id: widget.freelancer_id,
              )
            : BottomNavWidgetFreelancer(
                active_id: widget.active_id,
                active_imgUrl: widget.active_imgUrl,
                active_name: widget.active_name,
                activeAcc: widget.activeAcc,
                email: widget.email,
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

  void sendMessage(String text) {
    var messageJson = {
      'message': text,
      'sentByMe': widget.active_id,
      'receiverID': widget.receiverID,
    };
    socket.emit('message', messageJson);
    chatController.chatMessages.add(Message.fromJson(messageJson));
  }

  void setUpSocketListener() {
    socket.on('message-received', (data) {
      chatController.chatMessages.add(Message.fromJson(data));
    });
    socket.on('connected-user', (data) {
      chatController.connectedUser.value = data;
    });
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({Key? key, required this.sentByMe, required this.message})
      : super(key: key);
  final bool sentByMe;
  final String message;
  @override
  Widget build(BuildContext context) {
    var now = DateFormat('hh:mm').format(DateTime.now());
    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: sentByMe ? Colors.white : Colors.black,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 50, 20),
                child: Text(
                  message,
                  style: TextStyle(
                    color: sentByMe ? Colors.black : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  now,
                  style: TextStyle(
                    color: sentByMe ? Colors.black : Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
