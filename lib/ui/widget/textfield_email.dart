import 'package:flutter/material.dart';

class TextFieldEmail extends StatelessWidget {
  const TextFieldEmail({
    Key? key,
    required TextEditingController emailController,
  })  : _emailController = emailController,
        super(key: key);

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _emailController,
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(
        labelStyle: TextStyle(color: Colors.black),
        floatingLabelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        labelText: 'Email',
        prefixIcon: Icon(
          Icons.email,
          color: Colors.black,
        ),
      ),
    );
  }
}
