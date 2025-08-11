import 'package:app/common_widget/common_widget.dart';
import 'package:flutter/material.dart';

class PincodeLoginScreen extends StatefulWidget {
  const PincodeLoginScreen({super.key});

  @override
  State<PincodeLoginScreen> createState() => _PincodeLoginState();
}

class _PincodeLoginState extends State<PincodeLoginScreen> {


  onSubmitHandler(pincode) {

  }
  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      isLoading: false,
      child: Scaffold(
        appBar: AppBar(title: Text('Pincode'),),
        body: Pincode(
          onSubmitHandler: onSubmitHandler,
        ),
      ),
    );
  }
}