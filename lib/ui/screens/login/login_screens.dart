import 'package:flutter/material.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: const Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}
