import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../widgets/action/rice_button.dart';
import '../../widgets/input/textfield_input.dart';
import '../login/login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RiceColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(RiceSpacings.radiusLarge),
        ),
      ),
      child: Padding(
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
                  Navigator.pop(context);
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
              controller: TextEditingController(),
              hint: 'Enter your full name',
            ),
            const SizedBox(height: RiceSpacings.m),
            // Email Address TextField
            TextfieldInput(
              label: 'Email Address',
              controller: TextEditingController(),
              hint: 'Enter your email address',
            ),
            const SizedBox(height: RiceSpacings.m),
            // Password TextField
            TextfieldInput(
              label: 'Password',
              controller: TextEditingController(),
              hint: 'Enter your password',
            ),
            const SizedBox(height: RiceSpacings.xl),
            // Create an Account Button
            Center(
              child: RiceButton(
                text: 'Create an Account',
                icon: Icons.person_add,
                type: RiceButtonType.primary,
                onPressed: () {
                  // Handle create account logic here
                },
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
