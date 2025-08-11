import 'package:app/helpers/response_api.dart';
import 'package:app/shared/path.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/common_widget/common_widget.dart';
import 'package:app/cubit/register/register_cubit.dart';

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

  void onSubmitHandler(BuildContext context) {
    if (_form.currentState!.validate()) {
      setState(() {
        isLoadingAPI = true;
      });
      final String username = _fieldForm['username']['controller'].text;
      final String password = _fieldForm['password']['controller'].text;
      final String cpassword = _fieldForm['cpassword']['controller'].text;

      if (password == cpassword) {
        debugPrint('password is match');
        final endpoint = '$localpath/users/fill-in-registration';
        final body = {'username': username, 'password': password};
        final request = { endpoint: endpoint, body: body} as FetchAPI;
        context.read<RegisterCubit>().postRegister(request);
      } else if (password != cpassword) {
        final payload = {'message_en': 'password not match!'};
        setState(() {
          isLoadingAPI = false;
        });
        debugPrint('password not match');
        AlertErrorDialog.show(context, payload);
      } else {
        setState(() {
          isLoadingAPI = false;
        });
      }
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
                return 'enter your username';
              } else {
                return null;
              }
            },
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              hintText: 'Enter Username',
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'enter your password';
              } else {
                return null;
              }
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
            validator: (v) {
              if (v!.isEmpty) {
                return 'enter you re-enter password';
              } else {
                return null;
              }
            },
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
            onTap: () => onSubmitHandler(context),
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
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is responseData) {
          return context.go('/root');
        } else if (state is responseError) {
          final payload = state.payload;
          setState(() {
            isLoadingAPI = false;
          });

          AlertErrorDialog.show(context, payload);
        }
      },
      child: LoadingScreen(
        isLoading: isLoadingAPI,
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is responseData) {
              context.go('/root');
            } else if (state is responseError) {
              setState(() {
                isLoadingAPI = false;
              });
              final payload = state.payload;
              AlertErrorDialog.show(context, payload);
            }
          },
          child: Scaffold(
            body: KeyboardDismiss(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 64, left: 24, right: 24),
                child: _formUI(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
