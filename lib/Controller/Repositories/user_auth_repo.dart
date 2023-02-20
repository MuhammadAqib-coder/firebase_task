import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_task/Views/Utils/util.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuthRepo {
  static login(context, email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      showSnackbar(context, 'successfully login');
    } on SocketException catch (e) {
      showSnackbar(context, e.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar(context, 'user not found');
      } else if (e.code == 'wrong-password') {
        showSnackbar(context, 'wrong password');
      } else if (e.code == 'invalid-email') {
        showSnackbar(context, 'invalid email');
      } else {
        showSnackbar(context, 'something went wrong');
      }
    }
  }

  static register(context, email, password, name, userName) async {
    try {
      await ref.get().then((snapshot) async {
        if (snapshot.exists) {
          Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
          data.forEach((key, value) {
            if (value['user_name'] == userName) {
              showSnackbar(context, 'username already exist');
              return;
            }
          });
        }

        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        var userRef = ref.push();
        await ref.child(auth.currentUser!.uid).set({
          "name": name,
          "email": email,
          "user_name": userName,
          "password": password,
          "id": userRef.key
        });
        await auth.signOut();
        showSnackbar(context, 'user registered sucessfully');
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbar(context, 'weak password');
      } else if (e.code == 'email-already-in-use') {
        showSnackbar(context, 'user already registered');
      } else if (e.code == 'invalid-email') {
        throw showSnackbar(context, 'invalid email');
      } else {
        showSnackbar(context, 'something went wrong');
      }
    } on SocketException {
      showSnackbar(context, 'no internet connection');
    }
  }

  static googleAuth(context) async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser;
    try {
      googleUser = await googleSignIn.signIn();
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        showSnackbar(context, 'sign in canceled');
      } else if (e.code == 'sign_in_failed') {
        showSnackbar(context, 'Sign in failed');
      } else {
        showSnackbar(context, 'something went wrong');
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
    if (googleUser == null) return;
    final googleAuthentication = await googleUser.authentication;
    final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken);
    try {
      await auth.signInWithCredential(googleCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exist-with-different-credential') {
        showSnackbar(
            context, 'account already exist with different credential');
      } else if (e.code == 'invalid-credential') {
        showSnackbar(
            context, 'Error occurred while accessing credentials. Try again.');
      } else {
        showSnackbar(
            context, 'Error occurred using Google Sign In. Try again.');
      }
    }
  }
}
