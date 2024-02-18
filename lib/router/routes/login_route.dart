import 'package:attendance_app/router/transitions/slide_transition.dart';
import 'package:go_router/go_router.dart';
import 'package:attendance_app/pages/login/login_page.dart';
import 'package:attendance_app/pages/login/student_login_page.dart';
import 'package:attendance_app/pages/login/teacher_login_page.dart';
import 'package:attendance_app/screens/login_screen.dart';

StatefulShellRoute loginRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return LoginScreen(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "login",
          path: "/login",
          pageBuilder: (context, state) => CustomSlideTransition(
            key: state.pageKey,
            child: const LoginPage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "student_login",
          path: "/login/student",
          pageBuilder: (context, state) => CustomSlideTransition(
            key: state.pageKey,
            child: const StudentLoginPage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "teacher_login",
          path: "/login/teacher",
          pageBuilder: (context, state) => CustomSlideTransition(
            key: state.pageKey,
            child: const TeacherLoginPage(),
          ),
        ),
      ],
    ),
  ],
);
