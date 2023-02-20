import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_task/Models/user_model.dart';
import 'package:firebase_task/Views/Utils/util.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await auth.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
        title: const Text('Users'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: ref.onValue,
        builder: (context, snapshot) {
          var list = <UserModel>[];
          if (snapshot.hasData && snapshot.data!.snapshot.exists) {
            final users = Map<dynamic, dynamic>.from(
                (snapshot.data as DatabaseEvent).snapshot.value
                    as Map<dynamic, dynamic>);
            users.forEach((key, value) {
              final user = Map<String, dynamic>.from(value);
              list.add(UserModel.fromJson(user));
            });
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              list[index].image,
                            ),
                          ),
                          title: Text(list[index].name),
                          subtitle: Text(list[index].designation),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context, "/user_data_view",
                                        arguments: list[index]);
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () async {
                                    await ref.child(list[index].id).remove();
                                    list.remove(list[index]);
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: RepaintBoundary(child: CircularProgressIndicator()),
            );
          } else {
            return const Center(
              child: Text('No user Found'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add user'),
        icon: const Icon(Icons.add),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (_) => UserDataView()));
          Navigator.pushNamed(context, '/user_data_view');
        },
      ),
    );
  }
}
