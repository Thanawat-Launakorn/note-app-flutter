import 'package:app/common_widget/common_widget.dart';
import 'package:app/cubit/setpin/setpin_cubit.dart';
import 'package:app/helpers/response_api.dart';
import 'package:app/shared/path.dart';
import 'package:flutter/material.dart';
import 'package:app/common_widget/pincode.dart' as pincode;
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterSetpinScreen extends StatefulWidget {
  final String username;
  const RegisterSetpinScreen({required this.username, super.key});

  @override
  State<RegisterSetpinScreen> createState() => _RegisterSetpinScreenState();
}

class _RegisterSetpinScreenState extends State<RegisterSetpinScreen> {
  bool isLoadingAPI = false;

  onSubmitHandler(String pincode) {
    setState(() {
      isLoadingAPI = true;
    });
    final endpoint = '$localpath/pincode/set-pin';
    final body = {'username': 'test01', 'pincode': pincode};
    final request = {endpoint: endpoint, body: body} as FetchAPI;
    context.read<SetpinCubit>().postSetPin(request);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SetpinCubit, SetpinState>(
      listener: (context, state) {
        if (state is ResponseDataSetPin) {
        } else if (state is ResponseErrorSetPin) {
          final payload = state.payload;
          setState(() {
            isLoadingAPI = false;
          });
          AlertErrorDialog.show(context, payload);
        }
      },
      child: LoadingScreen(
        isLoading: isLoadingAPI,
        child: Scaffold(
          body: pincode.Pincode(
            onSubmitHandler: (pincode) => onSubmitHandler(pincode),
            action: pincode.Action.setpin,
          ),
        ),
      ),
    );
  }
}
