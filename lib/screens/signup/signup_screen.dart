import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_dr_rice/provider/language_provider.dart';
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
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    // Validate inputs
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(languageProvider.translate('Please fill in all fields'))),
        );
      }
      return;
    }

    if (!_isValidEmail(email)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(languageProvider.translate('Please enter a valid email address'))),
        );
      }
      return;
    }

    if (password.length < 8) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(languageProvider.translate('Password must be at least 8 characters'))),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Register user
      final user = await AuthService().registerWithEmailAndPassword(email, password);

      if (user != null) {
        // Update profile
        await user.updateDisplayName(name);
        await user.updatePhotoURL('assets/images/profile_placeholder.png');

        // Reload user to ensure updates are applied
        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;

        if (refreshedUser != null && refreshedUser.displayName == name) {
          if (mounted) {
            // Navigate only if signup and profile update succeed
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
              (route) => false, // Remove all previous routes
            );
          }
        } else {
          throw Exception(languageProvider.translate('Failed to update user profile'));
        }
      } else {
        throw Exception(languageProvider.translate('User registration returned null'));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = languageProvider.translate('The email address is already in use.');
          break;
        case 'invalid-email':
          errorMessage = languageProvider.translate('The email address is not valid.');
          break;
        case 'weak-password':
          errorMessage = languageProvider.translate('The password is too weak.');
          break;
        default:
          errorMessage = languageProvider.translate('An error occurred. Please try again.');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${languageProvider.translate('Signup failed')}: $e')),
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

  // Simple email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent default resize behavior
      backgroundColor: RiceColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RiceSpacings.xl),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    padding: const EdgeInsets.only(right: RiceSpacings.xl),
                    icon: Icon(Icons.close, color: RiceColors.neutralDark),
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                  ),
                ),
                const SizedBox(height: RiceSpacings.m),
                // Title
                Center(
                  child: Text(
                    languageProvider.translate('Create an Account'),
                    style: RiceTextStyles.body.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: RiceColors.neutralDark,
                    ),
                  ),
                ),
                const SizedBox(height: RiceSpacings.xl),
                // Full Name TextField
                TextfieldInput(
                  label: languageProvider.translate('Full Name'),
                  controller: _nameController,
                  hint: languageProvider.translate('Enter your full name'),
                ),
                const SizedBox(height: RiceSpacings.m),
                // Email Address TextField
                TextfieldInput(
                  label: languageProvider.translate('Email Address'),
                  controller: _emailController,
                  hint: languageProvider.translate('Enter your email address'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: RiceSpacings.m),
                // Password TextField
                TextfieldInput(
                  label: languageProvider.translate('Password'),
                  controller: _passwordController,
                  hint: languageProvider.translate('Enter your password'),
                  obscureText: true,
                ),
                const SizedBox(height: RiceSpacings.xl),
                // Create an Account Button
                Center(
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(RiceColors.neutralDark),
                        )
                      : RiceButton(
                          text: languageProvider.translate('Create an Account'),
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
                        languageProvider.translate('Already have an account?'),
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
                          languageProvider.translate('Login'),
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
                const SizedBox(height: RiceSpacings.xl), // Extra padding at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
