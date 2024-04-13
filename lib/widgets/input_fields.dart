// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class InputFields extends StatelessWidget {
  const InputFields({
    super.key,
    required this.controller,
    required this.hint,
    required this.isPassword,
  });

  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Set your desired height
      width: 500, // Set your desired width
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 5, horizontal: 10), // Adjust padding as needed
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
