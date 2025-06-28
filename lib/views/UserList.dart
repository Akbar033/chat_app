import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = auth.currentUser;
    return StreamBuilder(
      stream: firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('no user found  or empty list'));
        }

        // filter out current users
        final users = snapshot.data!.docs;
        /* .where((doc) => doc['uid'] != currentUser!.uid)
                .toList();*/

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(
                user['name'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                user['email'],
                style: TextStyle(
                  color: const Color.fromARGB(255, 161, 154, 154),
                ),
              ),
              trailing: Icon(Icons.chat, color: Colors.greenAccent, size: 30),
            );
          },
        );
      },
    );
  }
}
