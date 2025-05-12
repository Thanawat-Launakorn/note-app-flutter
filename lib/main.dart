import 'package:flutter/material.dart';
import 'package:app/router/route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/cubit/login/login_cubit.dart';

Future<void> main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => LoginCubit())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router),
    );
  }
}
