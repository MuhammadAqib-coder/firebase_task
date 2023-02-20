import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_task/Controller/Repositories/helper_function.dart';
import 'package:firebase_task/Views/GroupView/group_chatting_view.dart';
import 'package:firebase_task/Views/Utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Controller/Repositories/database_service.dart';

class GroupMainView extends StatefulWidget {
  const GroupMainView({super.key});

  @override
  State<GroupMainView> createState() => _GroupMainViewState();
}

class _GroupMainViewState extends State<GroupMainView> {
  // String userName = "";
  // String email = "";
  // Stream? groups;
  bool _isLoading = true;
  // String groupName = "";
  var checkBoxStatus = false;
  late final DataSnapshot user;
  var tempSet = <dynamic>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (auth.currentUser != null) {
      getUser();
      // chattingMemeber();
    }
  }

  getUser() async {
    user = await getLoginUser();
    var data = user.value as Map<dynamic, dynamic>;
    if (data['groups'] != null) {
      var temp = data['groups'];

      for (var i in temp) {
        tempSet.add(i);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    // await HelperFunction.getUserEmailFromSP().then((value) {
    //   setState(() {
    //     email = value!;
    //   });
    // });
    // await HelperFunction.getUserNameFromSP().then((val) {
    //   setState(() {
    //     userName = val!;
    //   });
    // });
    // getting the list of snapshots in our stream
    // await getUserGroups(FirebaseAuth.instance.currentUser!.uid)
    //     .then((snapshot) {
    //   setState(() {
    //     groups = snapshot;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 58, 74, 82),
          title: const Text(
            'Group Chats',
            style: TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 58, 74, 82),
          onPressed: () {
            showGroupDialog();
          },
          icon: const Icon(Icons.add),
          label: const Text(
            'create group',
            style: TextStyle(),
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : getGroupList(),
      ),
    );
  }

  Future<bool> willPop() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.done,
                  color: Colors.blue,
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
              )
            ],
            title: const Text('Exit App'),
            content: const Text('Do you want to exit?'),
          );
        });
    return Future.value(true);
  }

  getGroupList() {
    return FutureBuilder(
        future: getGroupsChat(tempSet),
        builder: (context, snapshot) {
          if (snapshot.data != null &&
              snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                padding: EdgeInsets.all(10.sp),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        side: BorderSide(
                            color: const Color.fromARGB(255, 58, 74, 82),
                            width: 2.sp)),
                    elevation: 3,
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10.sp),
                      focusColor: Theme.of(context).primaryColor,
                      minVerticalPadding: 0.0,
                      dense: true,
                      leading: CircleAvatar(
                        radius: 20.r,
                        backgroundColor:
                            const Color.fromARGB(181, 236, 238, 174),
                      ),
                      title: Text(
                        snapshot.data[index]['group_name'],
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => GroupChattingView(
                                      group: snapshot.data[index],
                                      user: user.value,
                                    )));
                      },
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  showGroupDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
                color: const Color.fromARGB(255, 58, 74, 82),
                padding: EdgeInsets.all(10.sp),
                height: 400.h,
                child: BoxList()),
          );
        });
  }
}

class BoxList extends StatefulWidget {
  const BoxList({super.key});

  @override
  State<BoxList> createState() => _BoxListState();
}

class _BoxListState extends State<BoxList> {
  var groupIds = [];
  var checkList = [];
  var groupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: groupController,
          decoration: InputDecoration(
              hintText: 'group name',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.r))),
        ),
        SizedBox(
          height: 10.h,
        ),
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
                      return Card(
                        child: ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: checkList[index],
                            onChanged: (value) {
                              if (value!) {
                                groupIds.add(snapshot.data!.snapshot.children
                                    .toList()[index]
                                    .child('id')
                                    .value
                                    .toString());
                                print(groupIds);
                              } else {
                                groupIds.remove(snapshot.data!.snapshot.children
                                    .toList()[index]
                                    .child('id')
                                    .value
                                    .toString());
                                print(groupIds);
                              }
                              setState(() {
                                checkList[index] = value;
                              });
                            },
                          ),
                          title: Text(snapshot.data!.snapshot.children
                              .toList()[index]
                              .child("name")
                              .value
                              .toString()),
                        ),
                      );
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
              if (groupController.text.isNotEmpty) {
                var chatgroupRef =
                    FirebaseDatabase.instance.ref('groupchat').push();
                await chatgroupRef.set({
                  "group_name": groupController.text.trim(),
                  "group_members": groupIds,
                  "group_id": chatgroupRef.key
                });
                for (var id in groupIds) {
                  await ref.child(id).update({
                    'groups': [chatgroupRef.key]
                  });
                }
                Navigator.pop(context);
              } else {
                showSnackbar(context, 'enter group name');
              }
            },
            child: const Text('Done'))
      ],
    );
  }
}
