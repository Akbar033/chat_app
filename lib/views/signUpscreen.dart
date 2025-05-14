import 'package:chatapp/viewModel/auth/createUser.dart';
import 'package:chatapp/views/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Chat App"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align children to the left
            children: [
              SizedBox(height: size.height / 40),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_back),
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: size.height / 40),
              Text(
                "Welcome",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Sign in to continue", style: TextStyle(color: Colors.grey)),
              SizedBox(height: size.height * 0.1),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: field(size, "name", Icon(Icons.person), _name),
                ),
              ),
              // Centered Email Field
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: field(
                    size,
                    "Enter your email",
                    Icon(Icons.email),
                    _email,
                  ),
                ),
              ),

              // Centered Password Field
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: field(size, "Your password", Icon(Icons.lock), _pass),
                ),
              ),

              SizedBox(height: size.height * 0.1),

              // Centered Login Button
              Consumer<CreateuserProvider>(
                builder: (context, pdr, child) {
                  return pdr.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : GestureDetector(
                        onTap: () {
                          pdr.CreateAccount(
                            _email.text,
                            _pass.text,
                            _name.text,
                            context,
                          );
                        },
                        child: Center(
                          child: button(size.height * 0.05, size.width * 0.5),
                        ),
                      );
                },
              ),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Loginpage()),
                    );
                  },
                  child: Text(' already account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget field(
  Size size,
  String labelText,
  Icon icon,
  TextEditingController controller,
) {
  return SizedBox(
    height: size.height * 0.06,
    width: size.width * 0.8,
    child: Form(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          icon: icon,
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    ),
  );
}

Widget button(double btnHeight, double btnWidth) {
  return Container(
    alignment: Alignment.center,
    color: Colors.blue,
    height: btnHeight,
    width: btnWidth,
    child: Text(
      "sign up",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
