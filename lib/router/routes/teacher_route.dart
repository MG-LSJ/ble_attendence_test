import 'package:attendance_app/pages/teacher/teacher_home_page.dart';
import 'package:attendance_app/pages/teacher/teacher_settings_page.dart';
import 'package:attendance_app/screens/teacher_dash_screen.dart';
import 'package:go_router/go_router.dart';

StatefulShellRoute teacherRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return TeacherDashSCreen(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "teacher_home",
          path: "/teacher",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TeacherHomePage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "teacher_timetable",
          path: "/teacher/timetable",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TeacherHomePage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "teacher_history",
          path: "/teacher/history",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TeacherHomePage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "teacher_settings",
          path: "/teacher/settings",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TeacherSettingsPage(),
          ),
        ),
      ],
    ),
  ],
);
