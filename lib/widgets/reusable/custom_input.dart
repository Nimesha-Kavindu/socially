import 'package:flutter/material.dart';

class ReusableInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obsecureText;
  final String? Function(String?)? validator;

  const ReusableInput({super.key, required this.controller, required this.hintText, required this.icon, required this.obsecureText, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecureText,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white, size: 20),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}