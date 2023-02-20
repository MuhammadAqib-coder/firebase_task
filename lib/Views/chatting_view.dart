import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_task/Models/message_detail.dart';
import 'package:firebase_task/Views/Widgets/message_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Controller/Repositories/database_service.dart';

class ChattingView extends StatefulWidget {
  const ChattingView({super.key, required this.user1, required this.user2});
  final dynamic user1;
  final dynamic user2;

  @override
  State<ChattingView> createState() => _ChattingViewState();
}

class _ChattingViewState extends State<ChattingView> {
  // Stream? chats;
  String merge = '';
  TextEditingController messageController = TextEditingController();
  String translation = '';
  var isLoad = true;
  var user2Members = Set();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mergeUsersId();
    getUser2Members();
  }

  getUser2Members() {
    var temp = widget.user2['members'];
    for (var i in temp) {
      user2Members.add(i);
    }
  }

  mergeUsersId() async {
    if (widget.user1['id'].toLowerCase().codeUnits[0] >
        widget.user2['id'].toLowerCase().codeUnits[0]) {
      merge = "${widget.user1['id']}${widget.user2['id']}";
    } else {
      merge = "${widget.user2['id']}${widget.user1['id']}";
    }
    setState(() {
      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          centerTitle: true,
          elevation: 0,
          title: Text(
            widget.user2['name'],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 58, 74, 82),
        ),
        body: Column(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                width: MediaQuery.of(context).size.width,
                color: Colors.black87,
                child: Row(children: [
                  Expanded(
                      child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Send a message...",
                      hintStyle:
                          TextStyle(color: Colors.white, fontSize: 16.sp),
                      border: InputBorder.none,
                    ),
                  )),
                  SizedBox(
                    width: 12.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50.h,
                      width: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.send,
                        color: Colors.white,
                      )),
                    ),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  chatMessages() {
    return Expanded(
        child: StreamBuilder(
            stream: FirebaseDatabase.instance
                .ref('chatrooms')
                .child(merge)
                .child('chats')
                .onValue,
            builder: (context, snapshot) {
              var list = <MessageDetail>[];
              if (snapshot.hasData && snapshot.data!.snapshot.exists) {
                final users = Map<dynamic, dynamic>.from(
                    (snapshot.data as DatabaseEvent).snapshot.value
                        as Map<dynamic, dynamic>);
                users.forEach((key, value) {
                  final message = Map<String, dynamic>.from(value);
                  list.add(MessageDetail.fromJson(message));
                  list.sort((a, b) => a.time.compareTo(b.time));
                  list = List.from(list.reversed);
                });
                return ListView.builder(
                    reverse: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return MessageTileWidget(
                          showName: false,
                          message: list[index].message,
                          sender: list[index].sender,
                          sentByMe: widget.user1['name'] == list[index].sender);
                    });
              } else if (snapshot.data != null) {
                return const Center(
                  child: Text("no chatting avialable"),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 58, 74, 82),
                  ),
                );
              }
            }));
  }
  // chatMessages() {
  //   return FirebaseAnimatedList(
  //       query: FirebaseDatabase.instance
  //           .ref('chatroom')
  //           .child(merge)
  //           .child('chats'),
  //           itemBuilder: (context, snap),);
  // }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatExistence(merge, widget.user1, widget.user2);
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text.trim(),
        "sender": widget.user1['name'],
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      await sendMessageToDB(
          merge, chatMessageMap, widget.user1, widget.user2, user2Members);
      // chatList.add(MessageDetail(
      //     message: messageController.text.trim(),
      //     sender: widget.user1['name'],
      //     time: DateTime.now().millisecondsSinceEpoch));
      messageController.clear();
    }
  }
}
