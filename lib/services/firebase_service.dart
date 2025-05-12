import 'dart:convert';
import 'dart:io';
import 'package:firebase_dart/firebase_dart.dart';
// import 'package:firebase_dart/auth.dart';
// import 'package:firebase_dart/database.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class FirebaseService {
  late FirebaseApp _app;
  late FirebaseAuth _auth;
  late FirebaseDatabase _database;

  FirebaseService();

  Future<void> initialize() async {
    // Set up Firebase Dart with optional persistence storage path
    try {
      FirebaseDart.setup(storagePath: '/home/bob/Documents/udemy/holding_cabinet/firebase_cache');

      // Load Firebase config from a local file
      final configFile = File('/home/pi/firebase/firebase-config.json');
      final configMap = json.decode(await configFile.readAsString());

      // Initialize Firebase app
      _app = await Firebase.initializeApp(
        options: FirebaseOptions.fromMap(configMap),
      );

      // Initialize Auth and Realtime Database
      _auth = FirebaseAuth.instanceFor(app: _app);
      _database = FirebaseDatabase(app: _app);

      // Sign in anonymously
      // await _auth.signInAnonymously();
      // debugPrint('Signed in anonymously as UID: \${_auth.currentUser?.uid}');
      if (_auth.currentUser != null) {
      debugPrint('Signed in as UID: ${_auth.currentUser?.uid}, email: ${_auth.currentUser?.email}');
    } else {
      debugPrint('No user is currently signed in.');
    }

    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
    }
  }

  Future<void> writeData(String path, dynamic value) async {
    final ref = _database.reference().child(path);
    await ref.set(value);
  }

  Future<dynamic> readData(String path) async {
    final ref = _database.reference().child(path);
    final snapshot = await ref.once();
    return snapshot.value;
  }

  String? get currentUserId => _auth.currentUser?.uid;
}
