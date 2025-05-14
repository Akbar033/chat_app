import 'package:chatapp/Utils/customfield.dart';
import 'package:chatapp/viewModel/auth/logoutAuthprovider.dart';
import 'package:chatapp/views/ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  final TextEditingController search = TextEditingController();
  bool _isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  void onSearch() async {
    setState(() => _isLoading = true);

    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection('users')
        .where("email", isEqualTo: search.text.trim())
        .get()
        .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            // snapshot.docs[0].data() is a Map<String, dynamic>
            setState(() {
              userMap = snapshot.docs[0].data();
              _isLoading = false;
            });
            print("Full user data: $userMap");
          } else {
            setState(() => _isLoading = false);
            print("No user found");
          }
        });
  }

  String chatRoomId(String user1, String user2) {
    if (user1.isEmpty || user2.isEmpty) {
      throw ArgumentError("Usernames cannot be empty");
    }

    // Ensure comparison is case-insensitive and safe
    int user1Code = user1[0].toLowerCase().codeUnitAt(0);
    int user2Code = user2[0].toLowerCase().codeUnitAt(0);

    if (user1Code > user2Code) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }
  //init function

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus('online');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online user
      setStatus('online');
    } else {
      // offline user
      setStatus('offline');
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void setStatus(String status) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LogoutProvider>(context, listen: false);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Homepage',
          style: TextStyle(
            color: Color.fromRGBO(28, 52, 71, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.logOunt(context);
            },
            child: Text("logout"),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 39, 75, 104),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.01),
                  Center(
                    child: Text(
                      "Find User!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Customfield(
                    text: 'search',
                    cusBorderRaduis: BorderRadius.circular(20),
                    cusController: search,
                  ),

                  SizedBox(height: size.height * 0.02),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Center(
                        child: TextButton(
                          onPressed: () {
                            onSearch();
                          },
                          child: Text(
                            'Search',
                            style: TextStyle(
                              color: const Color.fromARGB(209, 238, 234, 234),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                  SizedBox(height: size.height * 0.03),

                  userMap != null
                      ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListTile(
                          leading: Icon(
                            Icons.person_2_rounded,
                            size: size.aspectRatio * 80,
                            color: const Color.fromARGB(255, 236, 234, 234),
                          ),
                          title: Text(
                            "${userMap?["name"]}",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 221, 213, 213),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${userMap?['email']}",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 189, 185, 185),
                            ),
                          ),
                          trailing: InkWell(
                            onTap: () {
                              // here we are going to create room id
                              String roomId = chatRoomId(
                                auth.currentUser!.displayName ?? '',
                                userMap!['name'],
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ChatScreen(
                                        chatRoomId: roomId,
                                        userMap: userMap!,
                                      ),
                                ),
                              );
                              print("navigated succesfully ");
                            },
                            child: Icon(
                              Icons.message_rounded,
                              size: size.aspectRatio * 70,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      )
                      : Container(
                        child: Text(
                          "use user found",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 228, 226, 226),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
