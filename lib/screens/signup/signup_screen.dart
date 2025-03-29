import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../widgets/action/rice_button.dart';
import '../../widgets/input/textfield_input.dart';
import '../../service/auth_service.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../login/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await AuthService().registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null) {
        await user.updateDisplayName(_nameController.text.trim());
        await user.updatePhotoURL('assets/images/profile_placeholder.png');
        await user.reload(); // Reload user to reflect changes
      }

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
          (route) => false, // Remove all previous routes
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'The email address is already in use.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else {
        errorMessage = 'An unknown error occurred. Please try again.';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
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
                'Create an Account',
                style: RiceTextStyles.body.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: RiceSpacings.xl),
            // Full Name TextField
            TextfieldInput(
              label: 'Full Name',
              controller: _nameController,
              hint: 'Enter your full name',
            ),
            const SizedBox(height: RiceSpacings.m),
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
            const SizedBox(height: RiceSpacings.xl),
            // Create an Account Button
            Center(
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : RiceButton(
                        text: 'Create an Account',
                        icon: Icons.person_add,
                        type: RiceButtonType.primary,
                        onPressed: _signup,
                      ),
            ),
            const SizedBox(height: RiceSpacings.l),
            // Already have an account? Login
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: RiceTextStyles.label.copyWith(
                      fontSize: 14,
                      color: RiceColors.neutralDark,
                    ),
                  ),
                  const SizedBox(width: RiceSpacings.s / 2),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const LoginScreen(),
                      );
                    },
                    child: Text(
                      'Login',
                      style: RiceTextStyles.label.copyWith(
                        fontSize: 14,
                        color: RiceColors.neutral,
                        decoration: TextDecoration.underline,
                        decorationColor: RiceColors.neutral,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
