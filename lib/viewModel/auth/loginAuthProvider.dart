import 'package:chatapp/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Loginauthprovider extends ChangeNotifier {
  String? errormassage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Type> loginUser(
    String email,
    String pass,
    BuildContext ctx,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      print("user logged in");
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Center(child: Text("login succesfull "))),
      );
      await Navigator.push(ctx, MaterialPageRoute(builder: (_) => Homepage()));
    } // try ended
    catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Center(child: Text("$e"))));
    }
    _isLoading = false;
    notifyListeners();
    return User;
  }
}
