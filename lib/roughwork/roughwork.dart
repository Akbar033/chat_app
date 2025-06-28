/*import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class flutterShow extends StatelessWidget {
  const flutterShow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('homepage')),

      body: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final data = snapshot.data as Map<String, dynamic>;
            return Column(
              children: [
                Text(' name :- ${data['name']}'),
                Text('email:- ${data['email']}'),
                Text('age:- ${data['age']}'),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

Future<void> savedUserProfile() async {
  final currentUserUId = auth.currentUser!.uid;
  firestore.collection("users").doc(currentUserUId).set({
    'name': "akbar",
    'email': 'email',
    'age': 'age',
  });
  try {} catch (e) {
    print(e);
  }
}

Future<void> getUserData() async {
  try {
    DocumentSnapshot userData =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();
    print("${userData['name'] + ['email'] + ['age']}");
  } catch (e) {
    print(e);
  }
}

Future<void> updateData() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'name': 'Akbar khan',
    });
  } catch (e) {
    log("Error updating name: $e");
  }
}

Future<void> deleteData() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('users').doc(auth.currentUser?.uid).delete();
    log('deleted use succefully');
  } catch (e) {
    log(e.toString());
  }
}

Future<List<Map<String, dynamic>>> getAllUser() async {
  List<Map<String, dynamic>> userList;
  bool isLoading = false;
  String errorMassge;

  try {
    isLoading = true;
    QuerySnapshot snapshot = await firestore.collection('user').get();
    List<Map<String, dynamic>> user =
        snapshot.docs.map((docX) {
          return (docX).data() as Map<String, dynamic>;
        }).toList();
    if (user.isEmpty) {
      errorMassge = 'no user found';
      return [];
    } else {
      return user;
    }
  } catch (e) {
    ' $e';
    return [];
  }
}

class AddUser extends StatelessWidget {
  AddUser({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _txtfield(nameController, 'enter you name'),
          _txtfield(emailController, 'enter your email'),
          _txtfield(ageController, 'enter your age'),

          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Future.delayed(Duration(seconds: 3));
                addNewUser(
                  nameController.text.trim(),
                  emailController.text,
                  ageController.text.trim(),
                );
              }
            },

            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

Widget _txtfield(TextEditingController controller, String hintText) {
  return TextFormField(
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'field can be empty $hintText';
      }
      return null;
    },
    controller: controller,
    decoration: InputDecoration(labelText: hintText),
  );
}

Future<void> addNewUser(String name, String email, String age) async {
  await firestore.collection('users').add({
    'name': name,
    'email': email,
    ' age': age,
  });
}*/

String chatRoomId(String user1, String user2) {
  if (user1.isEmpty || user2.isEmpty) {
    throw ArgumentError('user cannot be empty');
  }
  int user1Code = user1[0].toLowerCase().codeUnitAt(0);
  int user2Code = user2[0].toLowerCase().codeUnitAt(0);

  if (user1Code > user2Code) {
    return "$user1Code$user2Code";
  } else {
    return "$user2Code$user1Code";
  }
}
