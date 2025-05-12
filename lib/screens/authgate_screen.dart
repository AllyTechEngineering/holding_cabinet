import 'package:flutter/material.dart';
import 'package:firebase_dart/firebase_dart.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user != null) {
        debugPrint("User is logged in: ${user.email}");
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        debugPrint("User is not logged in");
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
