import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

showSnackbar(context, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

final auth = FirebaseAuth.instance;
FirebaseDatabase database = FirebaseDatabase.instance;
var storage = FirebaseStorage.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref("users");

Future<String> getImage(context) async {
  //File? image;
  String image = '';
  try {
    final pickFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickFile != null) {
      image = pickFile.path;
    }
  } on FirebaseException catch (e) {
    showSnackbar(context, e.toString());
  } catch (e) {
    showSnackbar(context, e.toString());
  }
  return image;
}

Future<String> getVideo(context) async {
  //File? image;
  String image = '';
  try {
    final pickFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (pickFile != null) {
      image = pickFile.path;
    }
  } on FirebaseException catch (e) {
    showSnackbar(context, e.toString());
  } catch (e) {
    showSnackbar(context, e.toString());
  }
  return image;
}
