import 'package:app/view/root/root.dart';
import 'package:go_router/go_router.dart';
import 'package:app/view/login/login.dart';
import 'package:app/router/arguments.dart';
import 'package:app/view/login/register.dart';
import 'package:app/view/note/manage_note.dart';
import 'package:app/view/login/pincode_login.dart';
import 'package:app/view/root/home/info/info.dart';
import 'package:app/view/login/register_setpin.dart';
import 'package:app/view/root/home/info/camera/camera.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // --- root ---
      GoRoute(
        path: '/root',
        builder: (context, state) => RootScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'info',
            builder: (context, state) => InfoScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: 'camera',
                builder: (context, state) => CameraScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'manageNote',
            builder: (context, state) {
              final args = state.extra as ManageNoteArguments;
              return ManageNodeScreen(method: args.method, data: args.data);
            },
          ),
        ],
      ),
      //  --- login ---
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'register',
            builder: (context, state) => RegisterScreen(),
            routes: <RouteBase>[
              GoRoute(
                name: 'registerSetpin',
                path: 'register-setpin',
                builder: (context, state) {
                  final args = state.extra as Map<String, dynamic>;
                  return RegisterSetpinScreen(username: args['username']);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/pincode-login',
        builder: (context, state) => PincodeLoginScreen(),
      ),
      // GoRoute(path: '/', builder: (context, state) => ),
    ],
  );
}
