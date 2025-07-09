import 'package:flutter/material.dart';

// TODO: Update this import to the actual path of your reset password screen
// import 'package:shop/src/screens/auth/views/reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, this.email});

  static const String routeName = '/otp-verification';

  // The email is passed from the previous screen to show it to the user.
  final String? email;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement OTP verification logic.
      // Call an API to verify the OTP.
      // On success, navigate to the reset password screen.
      // Navigator.of(context).pushNamed(ResetPasswordScreen.routeName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP Verified: ${_otpController.text}')),
      );
      debugPrint('Navigate to reset password screen.');
    }
  }

  void _resendOtp() {
    // TODO: Implement resend OTP logic.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New OTP sent to ${widget.email}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // In a real app, you would get the email from route arguments
    // final email = ModalRoute.of(context)!.settings.arguments as String;

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
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Verify'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _resendOtp,
                  child: const Text('Didn\'t receive the code? Resend'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
