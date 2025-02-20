import 'package:flutter/material.dart';
import 'package:shop/src/screens/address/views/components/form_field_svg_icon.dart';

import '../../../../constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailError,
    required this.passwordError,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? emailError;
  final String? passwordError;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (email) {
              // Save email logic
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'The email field is required.';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email address",
              prefixIcon:
                  FormFieldSvgIcon(iconPath: "assets/icons/Message.svg"),
              errorText: widget.emailError,
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            onSaved: (pass) {
              // Save password logic
            },
            controller: widget.passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'The password field is required.';
              }
              return null;
            },
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: FormFieldSvgIcon(iconPath: "assets/icons/Lock.svg"),
              errorText: widget.passwordError,
            ),
          ),
        ],
      ),
    );
  }
}
