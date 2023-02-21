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

var userInvolvementGroup = Set();

class _GroupMainViewState extends State<GroupMainView> {
  // String userName = "";
  // String email = "";
  // Stream? groups;
  bool _isLoading = true;
  // String groupName = "";
  var checkBoxStatus = false;
  late final DataSnapshot user;
  dynamic userData;

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
    userData = user.value as Map<dynamic, dynamic>;
    if (userData['groups'] != null) {
      var temp = userData['groups'];

      for (var i in temp) {
        userInvolvementGroup.add(i);
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
            showGroupDialog(userData);
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
            : getGroupStream(),
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

  getGroupStream() {
    return StreamBuilder(
        stream: FirebaseDatabase.instance.ref('groupchat').onValue,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
                padding: EdgeInsets.all(10.sp),
                itemCount: snapshot.data!.snapshot.children.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.snapshot.children.toList()[index];
                  if (userInvolvementGroup
                      .contains(data.child('group_id').value.toString())) {
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
                          data.child('group_name').value.toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => GroupChattingView(
                                        group: data,
                                        user: user.value,
                                      )));
                        },
                      ),
                    );
                  } else {
                    return const SizedBox(
                      width: 0,
                      height: 0,
                    );
                  }
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  getGroupList() {
    return FutureBuilder(
        future: getGroupsChat(userInvolvementGroup),
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

  showGroupDialog(userData) {
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
                  userData: userData,
                )),
          );
        });
  }
}

class BoxList extends StatefulWidget {
  const BoxList({super.key, required this.userData});
  final dynamic userData;
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
              if (groupController.text.isNotEmpty && groupIds.isNotEmpty) {
                // var userGroup = widget.userData['groups'];
                var chatgroupRef =
                    FirebaseDatabase.instance.ref('groupchat').push();
                userInvolvementGroup.add(chatgroupRef.key);

                await chatgroupRef.set({
                  "group_name": groupController.text.trim(),
                  "group_members": groupIds,
                  "group_id": chatgroupRef.key
                });

                for (var id in groupIds) {
                  var group = await ref.child(id).child('groups').get();
                  dynamic userGroup = group.value;

                  var newList = List.from(userGroup)..add(chatgroupRef.key);
                  await ref.child(id).update({'groups': newList});
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
