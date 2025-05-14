import 'package:flutter/material.dart';

class Customfield extends StatelessWidget {
  final String text;
  final BorderRadius? cusBorderRaduis;
  final TextEditingController? cusController;

  const Customfield({
    super.key,
    required this.text,
    this.cusBorderRaduis,
    this.cusController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        decoration: InputDecoration(
          hintStyle: TextStyle(color: const Color.fromARGB(255, 230, 225, 225)),
          hintText: text,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        controller: cusController,
        style: TextStyle(color: const Color.fromARGB(202, 255, 255, 255)),
      ),
    );
  }
}
