import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_task/Views/Utils/util.dart';
import 'package:firebase_task/Views/loginView/login_view.dart';
import 'package:firebase_task/Views/registerView/register_view.dart';
import 'package:firebase_task/Views/videosView/video_example.dart';
import 'package:flutter/material.dart';

import 'Views/UserDataView/user_data_view.dart';
import 'Views/homeView/home_view.dart';
import 'Views/videosView/videos_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Task',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeView();
          } else {
            return const LoginView();
          }
        },
      ),
      routes: {
        '/register_view': (context) {
          return RegisterView();
        },
        '/login_view': (context) => const LoginView(),
        '/user_data_view': (context) {
          return UserDataView();
        }
      },
    );
  }
}
