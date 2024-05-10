import 'package:flutter/material.dart';
import 'package:sistema_inventario/ui/screens/login_screen.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1,
        controller: controller,
        itemBuilder: (context, index) {
          if (index == 0) {
            return LoginScreen(
              controller: controller,
            );
          }
          return null;
        },
      ),
    );
  }
}
