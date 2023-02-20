import 'package:firebase_task/Views/ChatmainView/chat_main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../GroupView/group_main_view.dart';

class LandindView extends StatelessWidget {
  LandindView({super.key});

  var currentIndex = ValueNotifier<int>(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: currentIndex,
        builder: (context, index, _) {
          return BottomNavigationBar(
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(181, 236, 238, 174),
            currentIndex: index,
            onTap: (value) {
              currentIndex.value = value;
            },
            type: BottomNavigationBarType.shifting,
            items: const [
              BottomNavigationBarItem(
                  backgroundColor: Color.fromARGB(255, 58, 74, 82),
                  icon: Icon(Icons.person),
                  label: "Indiviual Chattig"),
              BottomNavigationBarItem(
                  backgroundColor: Color.fromARGB(255, 58, 74, 82),
                  icon: Icon(Icons.group),
                  label: "Group Chattig")
            ],
          );
        },
      ),
      body: ValueListenableBuilder(
        valueListenable: currentIndex,
        builder: (context, index, _) {
          if (index == 0) {
            return ChatMainView();
          } else {
            return GroupMainView();
          }
        },
      ),
    );
  }
}
