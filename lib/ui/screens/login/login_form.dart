import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../style/brand_color.dart';
import '../../../util/strings.dart';
import '../../widget/textfield_email.dart';
import '../forgot_password_screen.dart';
import '../pincode_screen.dart';
import '../signup/sign_up_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _visibility = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      if (credential.user != null) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const PinCodeScreen()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showMessage('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showMessage('Wrong password provided for that user.');
      }
    }
  }

  Future<void> _loginWithGoogle() async {

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
    );

    UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);

    print(user.user?.displayName);
    FirebaseAuth.instance.signInWithCredential(credential);
  }

  showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18.0),
        const SizedBox(height: 80.0),
        TextFieldEmail(emailController: _emailController),
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
              Icons.key,
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
        const SizedBox(height: 18.0),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: _loginWithGoogle,
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
                          Strings.login,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: _login,
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
                          Strings.loginWithGoogle,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen()));
              },
              child: const Text(
                Strings.forgoPassword,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpScreen())),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: const TextSpan(
                  text: Strings.notAccount,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' ${Strings.register}',
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
