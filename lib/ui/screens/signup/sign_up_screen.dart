import 'package:flutter/material.dart';
import 'package:gestor_passwords/ui/screens/signup/sign_up_form.dart';


class SignUpScreen extends StatelessWidget {
  static const String id = 'signUp';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: const Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: SignUpForm(),
            ),
          ],
        ),
      ),
    );
  }
}
