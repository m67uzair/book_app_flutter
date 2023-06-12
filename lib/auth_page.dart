import 'package:e_book/views/login_screen.dart';
import 'package:e_book/views/sign_up_screen.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginScreen(
    onClickLogin: toggle,
  )
      : SignUpScreen(
    onClickRegister: toggle,
  );

  void toggle() => setState(() => isLogin = !isLogin);
}
