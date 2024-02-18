import 'package:attendance_app/utils/constants.dart';
import 'package:attendance_app/utils/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherLoginPage extends StatefulWidget {
  const TeacherLoginPage({super.key});

  @override
  State<TeacherLoginPage> createState() => _TeacherLoginPageState();
}

class _TeacherLoginPageState extends State<TeacherLoginPage> {
  final TextEditingController _teacherIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _teacherLoginFormKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _isLoading = false;
  // reponse status
  bool _userNotFound = false;
  bool _wrongPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faculty Login"),
      ),
      body: Center(
        child: Stack(
          children: [
            Form(
              key: _teacherLoginFormKey,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome back 👋",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      "Faculty",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Hello there, login to continue",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: _teacherIdController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Faculty ID",
                        hintText: "Enter your faculty ID",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Faculty ID is required";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your password",
                        prefixIcon: const Icon(
                          Icons.password,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            // context.goNamed('forgot_password');
                          },
                          child: const Text("Forgot Password?"),
                        ),
                        ElevatedButton(
                          onPressed: _login,
                          child: const Text("Login"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // trim
    _teacherIdController.text = _teacherIdController.text.trim();
    _passwordController.text = _passwordController.text.trim();

    if (_teacherLoginFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Fake Validation for test
      var sharedpref = await SharedPreferences.getInstance();
      sharedpref.setString(KEY_USER_TYPE, "teacher");
      sharedpref.setInt(KEY_USER_ID, int.parse(_teacherIdController.text));
      sharedpref.setString(KEY_USER_NAME, "Mr. X");
      sharedpref.setBool(KEY_LOGIN, true);

      USER = Teacher(
        id: int.parse(_teacherIdController.text),
        name: "Mr. X",
      );

      // sleep
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
      context.goNamed("teacher_home");
    }
  }
}
