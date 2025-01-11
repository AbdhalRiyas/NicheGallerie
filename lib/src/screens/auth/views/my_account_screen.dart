import 'package:flutter/material.dart';
import 'package:shop/src/route/screen_export.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  String _currentIndex = 'login';

  void _changePage(String page) {
    setState(() {
      _currentIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account".toUpperCase()),
      ),
      body: _currentIndex.contains('login')
          ? LoginScreen(
              switchPageHandler: _changePage,
            )
          : _currentIndex.contains('signup')
              ? SignUpScreen(
                  switchPageHandler: _changePage,
                )
              : PasswordRecoveryScreen(
                  switchPageHandler: _changePage,
                ),
    );
  }
}
