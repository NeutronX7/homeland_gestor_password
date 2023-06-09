import 'package:flutter/material.dart';
import 'package:gestor_passwords/ui/screens/home_screen.dart';
import 'package:gestor_passwords/util/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../style/brand_color.dart';

class PinCodeForm extends StatefulWidget {
  const PinCodeForm({Key? key}) : super(key: key);

  @override
  State<PinCodeForm> createState() => _PinCodeFormState();
}

class _PinCodeFormState extends State<PinCodeForm> {
  late TextEditingController _controller;
  bool visibility = true;
  bool _hasPin = false;

  @override
  void initState() {
    _controller = TextEditingController();
    checkPin();
    super.initState();
  }

  Future<void> checkPin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? pinCode = prefs.getString('pin');
    if (pinCode != null) {
      setState(() {
        _hasPin = true;
      });
    }
  }

  showMessage(String text, [isError = false]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(
            color: isError ? Colors.black : BrandColor.dark, fontSize: 18.0),
      ),
      backgroundColor: isError ? BrandColor.red : BrandColor.purple,
    ));
  }

  Future<void> makePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('pin', pin);
      goHome();
    } catch (e) {

    }
  }

  void goHome() {
    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
  }

  void checkCorrectPIN(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final String? pinCode = prefs.getString('pin');
    if (pinCode != null) {
      if (pinCode == pin) {
        goHome();
      } else {
        showMessage(Strings.incorrectPin, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _hasPin ? Strings.typePin : Strings.createPin,
          style: const TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 18.0),
        const SizedBox(height: 80.0),
        TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.black),
          obscureText: visibility,
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
            labelText: Strings.pin,
            prefixIcon: const Icon(
              Icons.password,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              onPressed: (() => setState(() {
                    visibility = !visibility;
                  })),
              icon: Icon(
                visibility ? Icons.visibility : Icons.visibility_off,
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
                onPressed: () => _hasPin
                    ? checkCorrectPIN(_controller.text.trim())
                    : makePin(_controller.text.trim()),
                style: ElevatedButton.styleFrom(
                    backgroundColor: BrandColor.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0))),
                child: Ink(
                  child: Container(
                    // width: 300,
                    height: 50.0,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        _hasPin ? Strings.next : Strings.create,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
