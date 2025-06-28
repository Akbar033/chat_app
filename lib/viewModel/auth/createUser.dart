import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/web.dart';

class CreateuserProvider extends ChangeNotifier {
  String? erromassage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var logger = Logger();

  Future<Type> CreateAccount(
    String email,
    String pass,
    String name,
    BuildContext contex,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 3));
      final user = await (auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      ));

      User? userCredential = user.user;
      // if statement can be place after user is created;
      log(user.toString());
      log("user created succesfully");
      logger.d('user created succesfully');

      if (userCredential != null) {
        await userCredential.updateProfile(displayName: name);
      }
      await _firestore.collection("users").doc(auth.currentUser?.uid).set({
        "name": name,
        'email': email,
        'status': "offline",
        'uid': auth.currentUser!.uid,
      });
      log("data saved succesfully");
    } // try ended
    on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        erromassage = 'Email is already in use!';
      } else if (e.code == 'weak-password') {
        erromassage = 'password is too weak';
      } else if (e.code == 'invalid-email') {
        erromassage = 'email format is not valid';
      }

      ScaffoldMessenger.of(
        contex,
      ).showSnackBar(SnackBar(content: Center(child: Text(erromassage ?? ''))));
    }
    _isLoading = false;
    notifyListeners();
    return User;
  }
}
