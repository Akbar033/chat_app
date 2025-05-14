import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchUser extends ChangeNotifier {
  Map<String, dynamic>? userMap;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void search() async {
    _isLoading = true;
    notifyListeners();
    try {
      await firestore
          .collection('users')
          .where("email", isEqualTo: searchController.text)
          .get()
          .then((myValue) {
            userMap = myValue.docs[0].data();
          });
    } catch (e) {}
  }
}
