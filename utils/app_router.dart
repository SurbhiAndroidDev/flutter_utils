import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sleekit/auth/screen/otp_verification_code.dart';
import 'package:sleekit/splash_screen.dart';
import '../auth/screen/forgot_screen.dart';
import '../auth/screen/login_screen.dart';
import 'navigarion_services.dart';
import 'common/no_found_view.dart';

class AppRouter {
  static const String root = '/';
  static const String login = '/login';
  static const String forgot = '/forgot';
  static const String otp = '/otp';


  static Widget _errorWidget(BuildContext context, GoRouterState state) =>
      const NotFoundView();

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    navigatorKey: NavigationService.navigatorKey,
    routes: [
      GoRoute(
        path: root,
        pageBuilder: (context, state) {
          return getPage(child: const SplashScreen(), state: state);
        },
      ),
      GoRoute(
        path: login,
        pageBuilder: (context, state) {
          return getPage(child: const LoginScreen(), state: state);
        },
      ),
      GoRoute(
        path: otp,
        pageBuilder: (context, state) {
          return getPage(child: const VerifyOtpView(), state: state);
        },
      ),
   GoRoute(
        path: forgot,
        pageBuilder: (context, state) {
          return getPage(child: const ForgetPasswordView(), state: state);
        },
      ),


    ],
    errorBuilder: _errorWidget,
  );

  static GoRouter get router => _router;

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }
}
