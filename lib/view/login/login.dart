import 'package:app/cubit/login/login_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app/common_widget/button.dart';
import 'package:app/helpers/shared_preference.dart';
import 'package:app/common_widget/loading_screen.dart';
import 'package:app/common_widget/keyboard_dismiss.dart';
import 'package:app/common_widget/alert_error_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Map<String, dynamic> _fieldForm = {
    'username': {'controller': TextEditingController(), 'focus': FocusNode()},
    'password': {'controller': TextEditingController(), 'focus': FocusNode()},
  };
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _hidePassword = false;
  bool _rememberMe = false;
  bool isLoadingAPI = false;

  @override
  void initState() {
    checkRemember();
    super.initState();
  }

  @override
  void dispose() {
    _fieldForm.forEach((key, value) {
      value['controller'].dispose();
      value['focus'].dispose();
    });
    super.dispose();
  }

  checkRemember() async {
    final isRemember = await SharedPreferencesHelpers.getPrefs('remember');
    if (isRemember != null && isRemember == 'true') {
      setState(() {
        _rememberMe = true;
      });

      final username = await SharedPreferencesHelpers.getPrefs('username');
      final password = await SharedPreferencesHelpers.getPrefs('password');

      _fieldForm['username']['controller'].text = username;
      _fieldForm['password']['controller'].text = password;

      onSubmitHandler(context);
    }
  }

  isLoading(bool isLoading) {
    setState(() {
      isLoadingAPI = isLoading;
    });
  }

  void onSubmitHandler(BuildContext context) {
    isLoading(true);

    final username =
        (_fieldForm['username']['controller'] as TextEditingController).text;
    final password =
        (_fieldForm['password']['controller'] as TextEditingController).text;

    if (username.isNotEmpty && password.isNotEmpty) {
      final String endpoint = 'http://localhost:3000/users/fill-in-username';
      final Map<dynamic, dynamic> body = {
        'username': username,
        'password': password,
      };
      context.read<LoginCubit>().postLogin(endpoint: endpoint, body: body);
    } else {
      isLoading(false);
      AlertErrorDialog.show(context, '400', 'wrong username wrong password');
    }

    // if success go to root
    // context.go('/root');
  }

  void onToggleEye() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  void onRemember(bool? v) async {
    setState(() {
      _rememberMe = v!;
    });

    if (_rememberMe) {
      await SharedPreferencesHelpers.setPrefs(
        'username',
        _fieldForm['username']['controller'].text,
      );
      await SharedPreferencesHelpers.setPrefs(
        'password',
        _fieldForm['password']['controller'].text,
      );

      await SharedPreferencesHelpers.setPrefs('remember', 'true');
    } else {
      await SharedPreferencesHelpers.removePrefs('username');
      await SharedPreferencesHelpers.removePrefs('password');

      await SharedPreferencesHelpers.removePrefs('remember');
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = _fieldForm['username'];
    final password = _fieldForm['password'];

    Form buildForm() {
      return Form(
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
                  controller: username['controller'],
                  focusNode: username['focus'],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(password['focus']);
                  },
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Username',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: password['controller'],
                  focusNode: password['focus'],
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                Button(title: 'Login', onTap: () => onSubmitHandler(context)),
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
      );
    }

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {},
      child: LoadingScreen(
        isLoading: isLoadingAPI,
        child: Scaffold(
          body: KeyboardDismiss(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 64, right: 24, left: 24),
              child: buildForm(),
            ),
          ),
        ),
      ),
    );
  }
}
