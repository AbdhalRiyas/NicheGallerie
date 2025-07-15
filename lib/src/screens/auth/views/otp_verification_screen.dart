import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/src/providers/auth_provider.dart';
import 'package:shop/src/utils/result.dart';
import 'package:shop/src/screens/auth/views/reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, this.email});

  static const String routeName = '/otp-verification';

  final String? email;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final Result result =
          await authProvider.verifyOtp(widget.email ?? '', _otpController.text);
      setState(() {
        _isLoading = false;
      });
      if (result.isSuccess && context.mounted) {
        final token = result.data != null && result.data['token'] != null
            ? result.data['token']
            : _otpController.text;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ResetPasswordScreen(email: widget.email ?? '', token: token),
          ),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.message)),
          );
        }
      }
    }
  }

  // void _resendOtp() {
  //   // TODO: Implement resend OTP logic.
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('New OTP sent to ${widget.email}')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  'Enter the 6-digit code sent to your email address${widget.email != null ? ':\n${widget.email}' : '.'}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    labelText: 'OTP Code',
                    hintText: '123456',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Please enter a valid 6-digit OTP';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Verify'),
                ),
                // const SizedBox(height: 16),
                // TextButton(
                //   onPressed: _isLoading ? null : _resendOtp,
                //   child: const Text('Didn\'t receive the code? Resend'),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
