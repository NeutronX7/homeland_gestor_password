import 'package:flutter/material.dart';
import 'package:gestor_passwords/style/brand_color.dart';

import 'pincode/pincode_form.dart';

class PinCodeScreen extends StatelessWidget {
  static const String id = 'pincode';
  const PinCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: const Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: PinCodeForm(),
            ),
          ],
        ),
      ),
    );
  }
}
