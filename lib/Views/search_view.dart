import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_task/Views/Utils/util.dart';
import 'package:firebase_task/Views/chatting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key, required this.user});
  final DataSnapshot user;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final List<dynamic> _allpeople = [];
  TextEditingController searchController = TextEditingController();
  // late final DataSnapshot map;
  String searchValue = '';
  dynamic user1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(() {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    user1 = widget.user.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 58, 74, 82),
        title: Text(
          "Search",
          style: TextStyle(
              fontSize: 27.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 58, 74, 82),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    cursorColor: Colors.white,
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search with @",
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                    onChanged: (value) {
                      searchValue = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .ref('users')
                  // .equalTo(searchController.text.trim(), key: 'name')
                  // .equalTo(searchController.text.trim(), key: 'user_name')
                  // .equalTo(searchValue)
                  .onValue,
              // .where('user_name',
              //     isGreaterThanOrEqualTo:
              //         searchController.text.trim(),
              //     isLessThan: '${searchController.text.trim()}z')
              // .snapshots(),
              builder: (context, snapshot) {
                List<Map<String, dynamic>> list = [];
                if (snapshot.hasData && snapshot.data!.snapshot.exists) {
                  final users = Map<dynamic, dynamic>.from(
                      (snapshot.data as DatabaseEvent).snapshot.value
                          as Map<dynamic, dynamic>);
                  users.forEach((key, value) {
                    final user = Map<String, dynamic>.from(value);
                    list.add(user);
                  });
                  return ListView.builder(
                      padding: EdgeInsets.all(10.sp),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        var username = list[index]['user_name'];
                        return list[index]['id'] == user1['id']
                            ? Container(
                                height: 0,
                                width: 0,
                              )
                            : searchController.text.isEmpty
                                ? Card(
                                    shape: const StadiumBorder(
                                        side: BorderSide(
                                            color:
                                                Color.fromARGB(255, 58, 74, 82),
                                            width: 2)),
                                    elevation: 3,
                                    margin: EdgeInsets.only(bottom: 10.h),
                                    child: ListTile(
                                      minVerticalPadding: 0.0,
                                      dense: true,
                                      leading: CircleAvatar(
                                        radius: 20.r,
                                        backgroundColor: const Color.fromARGB(
                                            255, 47, 47, 40),
                                      ),
                                      title: Text(list[index]['name']),
                                      subtitle: Text(list[index]['user_name']),
                                      onTap: () async {
                                        // final user1 = widget.user.value;
                                        final user2 = list[index];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ChattingView(
                                                    user1: user1,
                                                    user2: user2)));
                                        //             .then(
                                        //     (value) {
                                        //   if (mounted) {
                                        //     setState(() {});
                                        //   }
                                        // });
                                      },
                                    ),
                                  )
                                : username.toLowerCase().contains(
                                        searchController.text
                                            .trim()
                                            .toLowerCase())
                                    ? Card(
                                        shape: const StadiumBorder(
                                            side: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 58, 74, 82),
                                                width: 2)),
                                        elevation: 3,
                                        margin: EdgeInsets.only(bottom: 10.h),
                                        child: ListTile(
                                          minVerticalPadding: 0.0,
                                          dense: true,
                                          leading: CircleAvatar(
                                            radius: 20.r,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 47, 47, 40),
                                          ),
                                          title: Text(list[index]['name']),
                                          subtitle:
                                              Text(list[index]['user_name']),
                                          onTap: () async {
                                            // final user1 = widget.user.value;
                                            final user2 = list[index];
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        ChattingView(
                                                            user1: user1,
                                                            user2: user2)));
                                            //     .then((value) {
                                            //   if (mounted) {
                                            //     setState(() {});
                                            //   }
                                            // });
                                          },
                                        ),
                                      )
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      );
                      });
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
