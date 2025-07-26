import 'package:app/common_widget/alert_error_dialog.dart';
import 'package:app/cubit/register/register_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/common_widget/button.dart';
import 'package:app/common_widget/keyboard_dismiss.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Map<String, bool> _hidePassword = {
    'password': false,
    'rePassword': false,
  };
  final Map<String, dynamic> _fieldForm = {
    'username': {'controller': TextEditingController(), 'focus': FocusNode()},
    'password': {'controller': TextEditingController(), 'focus': FocusNode()},
    'cpassword': {'controller': TextEditingController(), 'focus': FocusNode()},
  };
  bool isLoadingAPI = false;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  void onToggleEye(String field) {
    setState(() {
      _hidePassword[field] = !_hidePassword[field]!;
    });
  }

  void onSubmitHandler() {
    if (_form.currentState!.validate()) {
      final username = _fieldForm['username']['controller'].text;
      final password = _fieldForm['password']['controller'].text;
      final cpassword = _fieldForm['cpassword']['controller'].text;

      if (password == cpassword) {
        setState(() {
          isLoadingAPI = true;
        });
        final endpoint = '';
        final body = {
          'email': _fieldForm['username']['controller'].text,
          'password': _fieldForm['password']['controller'].text,
        };

        context.read<RegisterCubit>().postRegister(
          endpoint: endpoint,
          body: body,
        );
      } else {}
    }
  }

  Form _formUI() {
    return Form(
      key: _form,
      child: Column(
        children: [
          SizedBox(height: 120),
          Row(
            children: [
              Text(
                'Sign Up',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20),

          TextFormField(
            controller: _fieldForm['username']['controller'],
            focusNode: _fieldForm['username']['focus'],
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(
                context,
              ).requestFocus(_fieldForm['password']['focus']);
            },
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
            controller: _fieldForm['password']['controller'],
            focusNode: _fieldForm['password']['focus'],
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              FocusScope.of(
                context,
              ).requestFocus(_fieldForm['cpassword']['focus']);
            },
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
            focusNode: _fieldForm['cpassword']['focus'],
            textInputAction: TextInputAction.done,
            controller: _fieldForm['cpassword']['controller'],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardDismiss(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 64, left: 24, right: 24),
          child: _formUI(),
        ),
      ),
    );
  }
}
