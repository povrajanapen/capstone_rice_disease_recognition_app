import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../widgets/action/rice_button.dart';
import '../../widgets/input/textfield_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              child: RiceButton(
                text: 'Login',
                icon: Icons.login,
                type: RiceButtonType.primary,
                onPressed: () {
                  // Handle login logic here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
