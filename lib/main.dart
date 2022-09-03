import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pro/src/app_root.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

bool shouldUseFirebaseEmulator = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (shouldUseFirebaseEmulator) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AppRoot());
}
