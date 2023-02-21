import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_task/Views/Utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Controller/Repositories/database_service.dart';
import '../../Models/message_detail.dart';
import '../Widgets/message_tile_widget.dart';

class GroupChattingView extends StatefulWidget {
  const GroupChattingView({super.key, required this.group, required this.user});
  final dynamic group;
  final dynamic user;

  @override
  State<GroupChattingView> createState() => _GroupChattingViewState();
}

class _GroupChattingViewState extends State<GroupChattingView> {
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            actions: [
              // IconButton(
              //     onPressed: () {
              //       showMenu(
              //           context: context,
              //           position: RelativeRect.fromLTRB(10.sp, 10.sp, 0, 0),
              //           items: [
              //             PopupMenuItem(
              //                 onTap: () {
              //                 },
              //                 value: '1',
              //                 child: Text('Group info')),
              //             PopupMenuItem(
              //                 onTap: () {},
              //                 value: '2',
              //                 child: Text('Add user +'))
              //           ]);
              //     },
              //     icon: const Icon(
              //       Icons.more_vert,
              //       color: Colors.white,
              //     )),
              TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: () {
                    showAddUserDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('user'))
            ],
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
              widget.group.child('group_name').value.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 58, 74, 82),
          ),
          body: Column(children: [
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
            ),
          ]),
        ));
  }

  showAddUserDialog() async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
                color: const Color.fromARGB(255, 58, 74, 82),
                padding: EdgeInsets.all(10.sp),
                height: 400.h,
                child: BoxList(
                  group: widget.group,
                )),
          );
        });
  }

  chatMessages() {
    return Expanded(
        child: StreamBuilder(
            stream: FirebaseDatabase.instance
                .ref('groupchat')
                .child(widget.group.child('group_id').value.toString())
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
                          showName: true,
                          message: list[index].message,
                          sender: list[index].sender,
                          sentByMe: widget.user['name'] == list[index].sender);
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

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text.trim(),
        "sender": widget.user['name'],
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      await sendGroupMessage(widget.group['group_id'], chatMessageMap);
      // chatList.add(MessageDetail(
      //     message: messageController.text.trim(),
      //     sender: widget.user1['name'],
      //     time: DateTime.now().millisecondsSinceEpoch));
      messageController.clear();
    }
  }
}

class BoxList extends StatefulWidget {
  const BoxList({super.key, required this.group});
  final dynamic group;

  @override
  State<BoxList> createState() => _BoxListState();
}

class _BoxListState extends State<BoxList> {
  var groupIds = [];
  var checkList = [];
  DataSnapshot? groupMembers;
  var actualMembers;
  int checkUser = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    remainGroupMembers();
  }

  remainGroupMembers() async {
    groupMembers =
        await getGroupMembers(widget.group.child('group_id').value.toString());
    actualMembers = groupMembers!.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: FirebaseDatabase.instance.ref('users').onValue,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (checkList.isEmpty) {
                  checkList = List.generate(
                      snapshot.data!.snapshot.children.length,
                      (index) => false);
                }
                return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, index) {
                      var data =
                          snapshot.data!.snapshot.children.toList()[index];
                      if (!(actualMembers
                          .contains(data.child('id').value.toString()))) {
                        return Card(
                          child: ListTile(
                            dense: true,
                            leading: Checkbox(
                              value: checkList[index],
                              onChanged: (value) {
                                if (value!) {
                                  groupIds
                                      .add(data.child('id').value.toString());
                                  print(groupIds);
                                } else {
                                  groupIds.remove(
                                      data.child('id').value.toString());
                                  print(groupIds);
                                }
                                setState(() {
                                  checkList[index] = value;
                                });
                              },
                            ),
                            title: Text(data.child("name").value.toString()),
                          ),
                        );
                      } else {
                        checkUser++;
                        if (checkUser ==
                            snapshot.data!.snapshot.children.length) {
                          return const Center(
                            child: Text(
                              'No user avalilable',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: 0.0,
                            width: 0.w,
                          );
                        }
                        // checkList.removeAt(index);

                      }
                    });
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (snapshot.hasError) {
                return const Text("something went wrong");
              } else {
                return const Text('no users');
              }
            },
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              if (checkList.contains(true)) {
                var newList = List.from(groupIds)..addAll(actualMembers);
                // groupMembers = List.from(newList);
                await FirebaseDatabase.instance
                    .ref('groupchat')
                    .child(widget.group['group_id'])
                    .update({'group_members': newList});
                for (var id in groupIds) {
                  var group = await ref.child(id).child('groups').get();
                  dynamic userGroup = group.value;
                  var newGroupList = List.from(userGroup)
                    ..add(widget.group['group_id']);
                  await ref.child(id).update({'groups': newGroupList});
                }
              }
              Navigator.pop(context);
            },
            child: const Text('Add'))
      ],
    );
  }
}
