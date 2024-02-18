import 'package:attendance_app/router/routes/login_route.dart';
import 'package:attendance_app/router/routes/student_route.dart';
import 'package:attendance_app/router/routes/teacher_route.dart';
import 'package:attendance_app/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  debugLogDiagnostics: false,
  routes: <RouteBase>[
    GoRoute(
      name: 'splash',
      path: '/splash',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SplashScreen(),
      ),
    ),
    loginRoute,
    studentRoute,
    teacherRoute,
  ],
);
