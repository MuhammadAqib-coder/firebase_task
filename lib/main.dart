import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_task/Views/LandingView/landing_view.dart';
import 'package:firebase_task/Views/Utils/util.dart';
import 'package:firebase_task/Views/loginView/login_view.dart';
import 'package:firebase_task/Views/registerView/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Views/ChatmainView/chat_main_view.dart';
import 'Views/UserDataView/user_data_view.dart';

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
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Firebase Task',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
          ),
          home: child,
          routes: {
            '/register_view': (context) {
              return RegisterView();
            },
            '/login_view': (context) => const LoginView(),
            '/user_data_view': (context) {
              return UserDataView();
            },
            '/chat_main_view': (context) => const ChatMainView()
          },
        );
      },
      child: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LandindView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}
