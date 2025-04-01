import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../widgets/action/rice_button.dart';
import '../../widgets/input/textfield_input.dart';
import '../../service/auth_service.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService().signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false, // Remove all previous routes
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RiceColors.white,
      body: Padding(
        padding: const EdgeInsets.all(RiceSpacings.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context); // Close the modal
                },
              ),
            ),
            const SizedBox(height: RiceSpacings.m),
            // Title
            Center(
              child: Text(
                'Login',
                style: RiceTextStyles.body.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: RiceSpacings.xl),
            // Email Address TextField
            TextfieldInput(
              label: 'Email Address',
              controller: _emailController,
              hint: 'Enter your email address',
            ),
            const SizedBox(height: RiceSpacings.m),
            // Password TextField
            TextfieldInput(
              label: 'Password',
              controller: _passwordController,
              hint: 'Enter your password',
            ),
            const SizedBox(height: RiceSpacings.s),
            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  // Handle forgot password logic here
                },
                child: Text(
                  'Forgot password?',
                  style: RiceTextStyles.label.copyWith(
                    fontSize: 14,
                    color: RiceColors.neutral,
                    decoration: TextDecoration.underline,
                    decorationColor: RiceColors.neutral,
                  ),
                ),
              ),
            ),
            const SizedBox(height: RiceSpacings.xl),
            // Login Button
            Center(
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : RiceButton(
                        text: 'Login',
                        icon: Icons.login,
                        type: RiceButtonType.primary,
                        onPressed: _login,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
