import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/providers/auth_provider.dart';
import 'package:shop/src/route/route_constants.dart';
import 'package:shop/src/utils/show_loader.dart';

import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.switchPageHandler});

  final Function switchPageHandler;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/signUp_dark.webp",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Log in",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Please login to your account",
                  ),
                  const SizedBox(height: defaultPadding),
                  LogInForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text("Forgot Password?"),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, passwordRecoveryScreenRoute);
                      },
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showLoader(context, message: 'Logging in...');

                        final success = await authProvider.login(
                            _emailController.text, _passwordController.text);

                        if (context.mounted) {
                          hideLoader(context);
                        }

                        if (success && context.mounted) {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        }
                        // Navigator.pushNamedAndRemoveUntil(
                        //     context,
                        //     entryPointScreenRoute,
                        //     ModalRoute.withName(logInScreenRoute));
                      }
                    },
                    child: Text("Log in".toUpperCase()),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: defaultPadding,
                ),
                const Text("Don't have an account?"),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () => widget.switchPageHandler('signup'),
                  child: const Text("Sign up"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
