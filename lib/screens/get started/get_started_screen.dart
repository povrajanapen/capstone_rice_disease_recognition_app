import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../widgets/action/rice_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RiceColors.backgroundAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo in the center
            Image.asset('assets/images/logo.png', height: 230),
            SizedBox(height: RiceSpacings.l),
            // Login button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RiceSpacings.xl),
              child: RiceButton(
                text: 'Login',
                icon: Icons.login,
                onPressed: () {
                  // Handle login button press
                },
              ),
            ),
            SizedBox(height: RiceSpacings.m),
            // Line below the button
            Divider(
              color: RiceColors.neutral,
              thickness: 1,
              indent: RiceSpacings.xl,
              endIndent: RiceSpacings.xl,
            ),
            SizedBox(height: RiceSpacings.s),
            // "Not a member yet?" text and "Create an Account" link
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: RiceSpacings.xl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Not a member yet?',
                        style: RiceTextStyles.body.copyWith(
                          fontSize: 16,
                          color: RiceColors.neutralDark,
                        ),
                      ),
                      SizedBox(height: RiceSpacings.s),
                      GestureDetector(
                        onTap: () {
                          // Handle create account link press
                        },
                        child: Text(
                          'Create an Account',
                          style: RiceTextStyles.body.copyWith(
                            fontSize: 16,
                            color: RiceColors.neutral,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
