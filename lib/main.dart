import 'package:chatapp/function/searchUer.dart';
import 'package:chatapp/viewModel/auth/createUser.dart';
import 'package:chatapp/viewModel/auth/loginAuthProvider.dart';
import 'package:chatapp/viewModel/auth/logoutAuthprovider.dart';
import 'package:chatapp/views/userSession.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  print("object");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreateuserProvider()),
        ChangeNotifierProvider(create: (context) => Loginauthprovider()),
        ChangeNotifierProvider(create: (context) => LogoutProvider()),
        ChangeNotifierProvider(create: (create) => SearchUser()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Usersession());
  }
}
