import 'package:app/cubit/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:app/router/route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/cubit/login/login_cubit.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [
      BlocProvider(create: (_) => LoginCubit()),
      BlocProvider(create: (_) => RegisterCubit())
      ];

    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
