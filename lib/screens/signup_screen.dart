import 'package:flutter/material.dart';
import 'package:firebase_dart/firebase_dart.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? error;

  void _signup() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Sign up the user
      final auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Add user to Realtime Database
      final uid = auth.currentUser!.uid;
      final db = FirebaseDatabase(app: auth.app);
      await db.reference().child('users/$uid').set({
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      });

      final localContext = context;
      if (localContext.mounted) {
        Navigator.pushReplacementNamed(localContext, '/home');
      }
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Sign Up', style: TextStyle(color: Colors.black))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                helperStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(color: Colors.black),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black)),
              style: TextStyle(color: Colors.black),
            ),
            TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  helperStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.black),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black)),
                style: TextStyle(color: Colors.black)),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: _signup,
                child: const Text('Create Account',
                    style: TextStyle(color: Colors.black))),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Already have an account? Log in',
                  style: TextStyle(color: Colors.black)),
            ),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
