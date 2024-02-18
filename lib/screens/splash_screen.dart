import 'dart:io';

import 'package:attendance_app/utils/constants.dart';
import 'package:attendance_app/utils/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).colorScheme.surface,
          systemNavigationBarIconBrightness: Theme.of(context).brightness));
    }

    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            width: 250,
            height: 250,
          ),
        ),
      ),
    );
  }

  void _whereToGo() async {
    var sharedpref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedpref.getBool(KEY_LOGIN) ?? false;

    await Future.delayed(const Duration(seconds: 1));

    if (isLoggedIn) {
      var userType = sharedpref.getString(KEY_USER_TYPE);
      var userId = sharedpref.getInt(KEY_USER_ID);
      var userName = sharedpref.getString(KEY_USER_NAME);
      if (userId != null && userName != null && userType != null) {
        switch (userType) {
          case "student":
            USER = Student(id: userId, name: userName);
            context.goNamed("student_home");
            break;
          case "teacher":
            USER = Teacher(id: userId, name: userName);
            context.goNamed("teacher_home");
            break;
          default:
        }
      }
    } else {
      context.goNamed("login");
    }
  }
}
