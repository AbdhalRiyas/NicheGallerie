import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart' show snackBar;
import 'package:provider/provider.dart';
import 'package:shop/src/error/app_exception.dart';
import 'package:shop/src/providers/auth_provider.dart';
import 'package:shop/src/screens/auth/views/components/sign_up_form.dart';
import 'package:shop/src/utils/result.dart';
import 'package:shop/src/utils/show_loader.dart';

import '../../../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.switchPageHandler});

  final Function switchPageHandler;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

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
                    "Register Account",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Enter Details to register new account.",
                  ),
                  const SizedBox(height: defaultPadding),
                  SignUpForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    emailError: _emailError,
                    passwordError: _passwordError,
                  ),
                  const SizedBox(height: defaultPadding),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        showLoader(context, message: 'Registering...');

                        final Result result = await authProvider.register(
                          _emailController.text,
                          _passwordController.text,
                        );

                        if (context.mounted) {
                          hideLoader(context);
                        }

                        if (result.isSuccess && context.mounted) {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        } else {
                          if (context.mounted) {
                            snackBar(context, title: result.message);
                          }
                        }
                      }
                    },
                    child: const Text("Continue"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do you have an account?"),
                      TextButton(
                        onPressed: () => widget.switchPageHandler('login'),
                        child: const Text("Log in"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
