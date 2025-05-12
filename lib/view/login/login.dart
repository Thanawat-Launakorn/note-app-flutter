import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app/common_widget/button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/cubit/login/login_cubit.dart';
import 'package:app/common_widget/loading_screen.dart';
import 'package:app/common_widget/keyboard_dismiss.dart';
import 'package:app/common_widget/alert_error_dialog.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _hidePassword = false;
  bool _rememberMe = false;
  void onSubmitHandler(BuildContext context) {
    final String endpoint = 'http://localhost:3000/api/auth/login';
    final Map<dynamic, dynamic> body = {
      'username': _username.text,
      'password': _password.text,
    };
    context.read<LoginCubit>().postLogin(endpoint: endpoint, body: body);

    // if success go to root
    // context.go('/root');
  }

  void onToggleEye() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  void onRemember(bool? v) {
    setState(() {
      _rememberMe = v!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is LoginSuccess) {
          context.go('/root');
        } else if (state is LoginError) {
          final message = state.payload['message_en'];
          final responseStatus = state.payload['status'];
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertErrorDialog(
                context: context,
                message: message,
                responseStatus: responseStatus,
              );
            },
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return LoadingScreen(
          isLoading: isLoading,
          child: Scaffold(
            body: KeyboardDismiss(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 64, right: 24, left: 24),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Note app', style: TextStyle(fontSize: 64)),
                      SizedBox(height: 120),
                      Column(
                        children: [
                          TextFormField(
                            controller: _username,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Email ID',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _password,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            obscureText: _hidePassword,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: onToggleEye,
                                icon: Icon(
                                  _hidePassword
                                      ? Icons.visibility_off
                                      : Icons.remove_red_eye,
                                ),
                              ),
                              hintText: 'Password',
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rememberMe = !_rememberMe;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: Colors.blue,
                                      checkColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: _rememberMe,
                                      onChanged: (v) => onRemember(v),
                                    ),
                                    Text('remember me'),
                                  ],
                                ),
                              ),
                              Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Button(
                            title: 'Login',
                            onTap: () => onSubmitHandler(context),
                          ),
                          const SizedBox(height: 24),
                          RichText(
                            text: TextSpan(
                              text: 'Dont have an account?',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                              children: [
                                TextSpan(
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          context.go('/login/register');
                                        },
                                  text: ' Sign up',
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
