import 'package:chatapp/function/imagePicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  ChatScreen({super.key, required this.userMap, required this.chatRoomId});

  TextEditingController massageController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  // creating function for sending message

  void onSendMessage() async {
    if (massageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'send_by': auth.currentUser!.displayName,
        'message': massageController.text,
        'time': FieldValue.serverTimestamp(),
      };

      await firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);

      massageController.clear();
    } else {
      print('❗ Please enter some text before sending.');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 205, 226, 170),
      appBar: AppBar(
        centerTitle: true,
        title: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection('users').doc(userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(userMap['name']),
                    Text(
                      snapshot.data!['status'],
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        backgroundColor: const Color.fromARGB(31, 93, 84, 143),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  firestore
                      .collection("chatroom")
                      .doc(chatRoomId)
                      .collection('chats')
                      .orderBy('time', descending: false)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("❌ Error loading messages."));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("📭 No messages yet."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final message = doc['message'] ?? '';
                    final sender = doc['send_by'] ?? 'Unknown';
                    final isMe =
                        sender ==
                        FirebaseAuth.instance.currentUser?.displayName;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.white : Colors.blue.shade100,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft:
                                isMe
                                    ? const Radius.circular(12)
                                    : const Radius.circular(0),
                            bottomRight:
                                isMe
                                    ? const Radius.circular(0)
                                    : const Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(message),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.003,
                            ),
                            Text(
                              'from :- $sender',
                              style: TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: massageController,
                    decoration: InputDecoration(
                      suffix: IconButton(
                        onPressed: () {
                          getImage();
                        },
                        icon: Icon(Icons.image),
                      ),
                      labelText: "Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onSendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget cusTextfield(String fldText, TextEditingController fldController) {
  return TextField(
    controller: fldController,
    decoration: InputDecoration(
      //suffixIcon: Icon(Icons.send),
      labelText: fldText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
