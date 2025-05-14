import 'package:chatapp/views/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutProvider extends ChangeNotifier {
  bool _isLoadin = false;
  bool get isLoading => _isLoadin;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;

  Future<void> logOunt(BuildContext context) async {
    _isLoadin = true;
    notifyListeners();
    await auth.signOut().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'account has been logout! ',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (contect) => Loginpage()),
      );
    });
    _isLoadin = false;
    notifyListeners();
  }
}
