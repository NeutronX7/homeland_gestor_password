import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../style/brand_color.dart';
import '../../../util/show_message_helper.dart';
import '../../../util/strings.dart';
import '../login/login_screens.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmController;
  bool _visibility = true;
  bool _visibilityConf = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ShowMessageHelper.showMessage(context: context, text: Strings.checkEmail);
      return;
    } else if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 8) {
      ShowMessageHelper.showMessage(
          context: context,
          text: Strings.checkPassword);
      return;
    } else if (_passwordController.text != _passwordConfirmController.text) {
      ShowMessageHelper.showMessage(
          context: context,
          text: Strings.passwordNotMatch);
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      //if you need sign up
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (credential.user != null) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const RootScreen()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ShowMessageHelper.showMessage(
            context: context, text: Strings.weakPassword);
      } else if (e.code == 'email-already-in-use') {
        ShowMessageHelper.showMessage(
            context: context, text: Strings.emailAlreadyInUse);
      }
    } catch (e) {
      ShowMessageHelper.showMessage(context: context, text: 'Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18.0),
        const SizedBox(height: 80.0),
        TextField(
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
            labelText: Strings.email,
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _passwordController,
          obscureText: _visibility,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            labelText: Strings.password,
            prefixIcon: const Icon(
              Icons.password,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                _visibility = !_visibility;
              }),
              icon: Icon(
                _visibility ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _passwordConfirmController,
          obscureText: _visibilityConf,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.black),
            floatingLabelStyle: const TextStyle(color: Colors.black),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            labelText: Strings.confirmPassword,
            prefixIcon: const Icon(
              Icons.password,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                _visibilityConf = !_visibilityConf;
              }),
              icon: Icon(
                _visibility ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18.0),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: BrandColor.pink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0))),
                  child: Ink(
                    child: Container(
                      height: 50.0,
                      alignment: Alignment.center,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          Strings.register,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ),
        const SizedBox(height: 18.0),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: const TextSpan(
                  text: '${Strings.alreadyAccount} ',
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  children: <TextSpan>[
                    TextSpan(
                        text: Strings.login,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
