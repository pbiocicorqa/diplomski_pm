import 'package:flutter/material.dart';
import 'package:pm_alat/screens/login_register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    child: const Text("Prijava"),
                    onPressed: () =>
                        Navigator.pushNamed(context, LoginRegisterScreen.id, arguments: true),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    child: const Text("Registracija"),
                    onPressed: () =>
                        Navigator.pushNamed(context, LoginRegisterScreen.id, arguments: false),
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
