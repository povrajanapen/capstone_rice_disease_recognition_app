import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme.dart';
import '../../widgets/action/rice_button.dart';
import '../../widgets/input/textfield_input.dart';
import '../../service/auth_service.dart';
import '../../provider/language_provider.dart';
import '../signup/signup_screen.dart';

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
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );

    // Check if email or password is empty
    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              languageProvider.translate(
                'Please fill in all fields',
              ), // Using LanguageProvider
            ),
          ),
        );
      }
      return;
    }

    // Check if email is valid
    if (!_isValidEmail(email)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              languageProvider.translate(
                'Please enter a valid email address',
              ), // Using LanguageProvider
            ),
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService().signInWithEmailAndPassword(email, password);
      if (mounted) {
        Navigator.pop(context, 2); // Pass 2 to indicate the desired index
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${languageProvider.translate('Login failed:')} $e', // Using LanguageProvider
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  void _showForgotPasswordDialog() {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Forgot Password',
                  style: RiceTextStyles.body.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: RiceColors.neutralDark,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter your email to reset your password',
                  style: RiceTextStyles.body.copyWith(
                    fontSize: 14,
                    color: RiceColors.neutral,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: RiceTextStyles.button.copyWith(
                          color: RiceColors.neutralDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final email = emailController.text.trim();
                        if (email.isEmpty) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter your email')),
                          );
                          return;
                        }

                        try {
                          await AuthService().sendPasswordResetEmail(email);
                          if (!mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Password reset email sent'),
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to send password reset email. Please try again later.',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RiceColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: RiceTextStyles.button.copyWith(
                          color: RiceColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: RiceColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RiceSpacings.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  padding: const EdgeInsets.only(right: RiceSpacings.xl),
                  icon: Icon(Icons.close, color: RiceColors.neutralDark),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: RiceSpacings.m),
              Center(
                child: Text(
                  languageProvider.translate('Login'),
                  style: RiceTextStyles.body.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: RiceColors.neutralDark,
                  ),
                ),
              ),
              const SizedBox(height: RiceSpacings.xl),
              TextfieldInput(
                label: languageProvider.translate('Email Address'),
                controller: _emailController,
                hint: languageProvider.translate('Enter your email address'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: RiceSpacings.m),
              TextfieldInput(
                label: languageProvider.translate('Password'),
                controller: _passwordController,
                hint: languageProvider.translate('Enter your password'),
                obscureText: true,
              ),
              const SizedBox(height: RiceSpacings.s),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      languageProvider.translate('Create account'),
                      style: RiceTextStyles.label.copyWith(
                        fontSize: 14,
                        color: RiceColors.neutral,
                        decoration: TextDecoration.underline,
                        decorationColor: RiceColors.neutral,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showForgotPasswordDialog();
                    },
                    child: Text(
                      languageProvider.translate('Forgot password?'),
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
              const SizedBox(height: RiceSpacings.xl),
              Center(
                child:
                    _isLoading
                        ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            RiceColors.neutralDark,
                          ),
                        )
                        : RiceButton(
                          text: languageProvider.translate('Login'),
                          icon: Icons.login,
                          type: RiceButtonType.primary,
                          onPressed: _login,
                        ),
              ),
              const SizedBox(height: RiceSpacings.xl),
            ],
          ),
        ),
      ),
    );
  }
}
