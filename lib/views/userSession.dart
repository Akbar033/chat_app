import 'package:chatapp/views/homepage.dart';
import 'package:chatapp/views/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Usersession extends StatelessWidget {
  const Usersession({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Firebase is still checking the auth state
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          // User is logged in
          return Homepage();
        } else {
          // User is not logged in
          return Loginpage();
        }
      },
    );
  }
}
