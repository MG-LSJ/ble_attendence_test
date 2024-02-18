import 'package:attendance_app/pages/student/student_history_page.dart';
import 'package:attendance_app/pages/student/student_settings_page.dart';
import 'package:attendance_app/pages/student/student_timetable_page.dart';
import 'package:go_router/go_router.dart';
import 'package:attendance_app/pages/student/student_home_page.dart';
import 'package:attendance_app/screens/student_dash_screen.dart';

StatefulShellRoute studentRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return StudentDashScreen(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "student_home",
          path: "/student",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: StudentHomePage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "student_timetable",
          path: "/student/timetable",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: StudentTimetablePage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "student_history",
          path: "/student/history",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: StudentHistoryPage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "student_settings",
          path: "/student/settings",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: StudentSettingsPage(),
          ),
        ),
      ],
    ),
  ],
);
