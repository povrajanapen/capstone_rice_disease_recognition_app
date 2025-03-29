import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:capstone_dr_rice/widgets/action/rice_button.dart';
import 'package:capstone_dr_rice/widgets/display/rice_divider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:capstone_dr_rice/widgets/input/textfield_input.dart';

class ProfileEditScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? userProfileImage;

  const ProfileEditScreen({
    required this.userName,
    required this.userEmail,
    this.userProfileImage,
    super.key,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _emailController.text = widget.userEmail;
    _profileImagePath = widget.userProfileImage;
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      }
      return;
    }

    try {
      // Update name
      if (_nameController.text.trim().isNotEmpty &&
          _nameController.text.trim() != widget.userName) {
        await user.updateDisplayName(_nameController.text.trim());
      }

      // Update email
      if (_emailController.text.trim().isNotEmpty &&
          _emailController.text.trim() != widget.userEmail) {
        await user.verifyBeforeUpdateEmail(_emailController.text.trim());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Verification email sent. Please verify your new email.',
              ),
            ),
          );
        }
      }

      // Update password
      if (_newPasswordController.text.trim().isNotEmpty &&
          _newPasswordController.text.trim() ==
              _confirmPasswordController.text.trim()) {
        await user.updatePassword(_newPasswordController.text.trim());
      } else if (_newPasswordController.text.trim() !=
          _confirmPasswordController.text.trim()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
        }
        return;
      }

      // Reload user to reflect changes
      await user.reload();

      // Navigate back to ProfileScreen
      if (mounted) {
        Navigator.pop(context, {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
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
      } else if (e.code == 'requires-recent-login') {
        errorMessage =
            'This operation is sensitive and requires recent authentication. Please log in again.';
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
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RiceColors.backgroundAccent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Profile', style: RiceTextStyles.body),
        centerTitle: true,
        backgroundColor: RiceColors.backgroundAccent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: RiceColors.neutralLight, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(RiceSpacings.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _profileImagePath != null
                            ? AssetImage(_profileImagePath!)
                            : const AssetImage(
                              'assets/images/profile_placeholder.png',
                            ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: RiceColors.neutralDark,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: RiceSpacings.xl),
            const RiceDivider(),
            const SizedBox(height: RiceSpacings.xl),
            TextfieldInput(
              label: 'Name',
              controller: _nameController,
              hint: widget.userName,
            ),
            const SizedBox(height: RiceSpacings.m),
            TextfieldInput(
              label: 'Email',
              controller: _emailController,
              hint: widget.userEmail,
            ),
            const SizedBox(height: RiceSpacings.xl),
            const RiceDivider(),
            const SizedBox(height: RiceSpacings.xl),
            Text('Change Password?', style: RiceTextStyles.body),
            const SizedBox(height: RiceSpacings.m),
            TextfieldInput(
              label: 'New Password',
              controller: _newPasswordController,
              hint: 'Password',
            ),
            const SizedBox(height: RiceSpacings.m),
            TextfieldInput(
              label: 'Confirm Password',
              controller: _confirmPasswordController,
              hint: 'Password',
            ),
            const SizedBox(height: RiceSpacings.xl),
            const RiceDivider(),
            const SizedBox(height: RiceSpacings.xl),
            Center(
              child: RiceButton(
                text: 'Update',
                icon: Icons.edit,
                type: RiceButtonType.primary,
                onPressed: _updateProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
