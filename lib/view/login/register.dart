import 'package:app/common_widget/button.dart';
import 'package:app/common_widget/keyboard_dismiss.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Map<String, bool> _hidePassword = {'password': false, 'rePassword': false};
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  void onToggleEye(String field) {
    setState(() {
      _hidePassword[field] = !_hidePassword[field]!;
    });
  }

  void onSubmitHandler() {
    if (_form.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardDismiss(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 64, left: 24, right: 24),
          child: Form(
            key: _form,
            child: Column(
              children: [
                SizedBox(height: 120),
                Row(
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                TextFormField(
                  onChanged: (v) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter your email id';
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Enter Email ID',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () => onToggleEye('password'),
                      icon: Icon(
                        _hidePassword['password']!
                            ? Icons.visibility_off
                            : Icons.remove_red_eye,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Re-Enter Password',
                    prefixIcon: Icon(Icons.replay),
                    suffixIcon: IconButton(
                      onPressed: () => onToggleEye('rePassword'),
                      icon: Icon(
                        _hidePassword['rePassword']!
                            ? Icons.visibility_off
                            : Icons.remove_red_eye,
                      ),
                    ),
                  ),
                ),
                Button(
                  title: 'Sign Up',
                  onTap: onSubmitHandler,
                  margin: const EdgeInsets.only(top: 36, bottom: 24),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account?',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    children: [
                      TextSpan(
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                context.pop();
                              },
                        text: ' Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
