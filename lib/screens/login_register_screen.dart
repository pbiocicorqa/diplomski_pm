import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pm_alat/screens/projects_screen.dart';

class LoginRegisterScreen extends StatefulWidget {
  static const String id = 'login_register_screen';
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLogin = ModalRoute.of(context)!.settings.arguments as bool;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "E-pošta",
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  controller: _controllerPassword,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Lozinka",
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      isLogin
                          ? FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                              email: _controllerEmail.text,
                              password: _controllerPassword.text,
                            )
                              .then((value) {
                              Navigator.pushNamed(context, ProjectsScreen.id);
                            }).onError((error, stackTrace) {
                              print(error.toString());
                            })
                          : FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email: _controllerEmail.text,
                              password: _controllerPassword.text,
                            )
                              .then((value) {
                              Navigator.pushNamed(context, ProjectsScreen.id);
                            }).onError((error, stackTrace) {
                              print(error.toString());
                            });
                    },
                    child: Text(isLogin ? "Prijavi se" : "Registriraj se"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
