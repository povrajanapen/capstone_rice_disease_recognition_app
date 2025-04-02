import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../../widgets/action/rice_button.dart';
import '../login/login_screen.dart';
import '../signup/signup_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RiceColors.backgroundAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: RiceColors.neutralDark),
      ),
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
                text: languageProvider.translate('Login'),
                icon: Icons.login,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const LoginScreen(),
                  );
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
                        languageProvider.translate('Not a member yet?'),
                        style: RiceTextStyles.body.copyWith(
                          fontSize: 16,
                          color: RiceColors.neutralDark,
                        ),
                      ),
                      SizedBox(height: RiceSpacings.s),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const SignupScreen(),
                          );
                        },
                        child: Text(
                          languageProvider.translate('Create an Account'),
                          style: RiceTextStyles.body.copyWith(
                            fontSize: 16,
                            color: RiceColors.neutral,
                            decoration: TextDecoration.underline,
                            decorationColor: RiceColors.neutral,
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
