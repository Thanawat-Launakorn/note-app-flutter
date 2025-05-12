import 'package:app/view/login/register.dart';
import 'package:app/view/root/home/info/camera/camera.dart';
import 'package:app/view/root/home/info/info.dart';
import 'package:app/view/root/root.dart';
import 'package:app/view/login/login.dart';
import 'package:go_router/go_router.dart';
import '../main.dart' as main;

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
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
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'register',
            builder: (context, state) => RegisterScreen(),
          ),
        ],
      ),
      // GoRoute(path: '/', builder: (context, state) => ),
    ],
  );
}
