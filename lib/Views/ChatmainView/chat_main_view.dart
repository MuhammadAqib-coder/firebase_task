import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_task/Controller/Repositories/database_service.dart';
import 'package:firebase_task/Views/Utils/util.dart';
import 'package:firebase_task/Views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../chatting_view.dart';

var members = Set();
// var chattingUser = [];

class ChatMainView extends StatefulWidget {
  const ChatMainView({super.key});

  @override
  State<ChatMainView> createState() => _ChatMainViewState();
}

class _ChatMainViewState extends State<ChatMainView> {
  late final DataSnapshot user;
  dynamic data;

  bool istrue = true;
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
    data = user.value as Map<dynamic, dynamic>;
    var tempList = data['members'];
    members.clear();
    if (tempList != null) {
      for (var i in tempList) {
        members.add(i);
      }
      // await getChatUser(members);
    }

    setState(() {
      istrue = false;
    });
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
          actions: [],
          title: const Text(
            'Chats',
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: drawer(),
        body: istrue
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(181, 236, 238, 174),
                ),
              )
            : getListOfChatUser(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 58, 74, 82),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SearchView(
                          user: user,
                        ))).then((value) {
              if (mounted) {
                setState(() {});
              }
            });
          },
          child: Icon(
            Icons.search,
            size: 30.sp,
          ),
        ),
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

  getListOfChatUser() {
    return FutureBuilder(
        future: getChatUser(members),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("something went wrong"),
            );
          } else if (snapshot.hasData &&
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
                      focusColor: Theme.of(context).primaryColor,
                      minVerticalPadding: 0.0,
                      dense: true,
                      leading: CircleAvatar(
                        radius: 20.r,
                        backgroundColor:
                            const Color.fromARGB(181, 236, 238, 174),
                      ),
                      title: Text(snapshot.data[index]['name']),
                      subtitle: Text(snapshot.data[index]['user_name']),
                      onTap: () async {
                        final user1 = user.value;
                        final user2 = snapshot.data[index];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ChattingView(
                                      user1: user1,
                                      user2: user2,
                                    )));
                      },
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 58, 74, 82),
              ),
            );
          }
        });
  }

  drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Column(
            children: [
              Expanded(
                child: Icon(
                  Icons.account_circle,
                  size: 80.sp,
                  color: Colors.grey[700],
                ),
              ),
              istrue
                  ? Container(
                      height: 0,
                      width: 0,
                    )
                  : Text(
                      data['name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    )
            ],
          )),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20.w,
                  ),
                  IconButton(
                      onPressed: () async {
                        await auth.signOut();
                        Navigator.of(context).pop();
                        // Navigator.pushAndRemoveUntil(
                        //     context, MaterialPage, (route) => false);
                      },
                      icon: const Icon(
                        Icons.logout,
                      )),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    'Logout',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
