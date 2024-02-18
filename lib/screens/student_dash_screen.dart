import 'package:flutter/services.dart';
import 'package:attendance_app/widgets/student_attendance_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentDashScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const StudentDashScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('StudentDashScreen'));

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
        systemNavigationBarIconBrightness: Theme.of(context).brightness,
      ),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          destinations: const [
            NavigationDestination(
              label: 'Home',
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(
                Icons.home,
              ),
            ),
            NavigationDestination(
              label: 'Time Table',
              icon: Icon(Icons.grid_on_outlined),
              selectedIcon: Icon(
                Icons.grid_on,
              ),
            ),
            NavigationDestination(
              label: 'History',
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(
                Icons.history,
              ),
            ),
            NavigationDestination(
              label: 'Settings',
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(
                Icons.settings,
              ),
            ),
          ],
          onDestinationSelected: _goBranch,
        ),
        floatingActionButton: const StudentAttedenceButtom(),
      ),
    );
  }
}
