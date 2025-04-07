import 'dart:io';
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:capstone_dr_rice/widgets/action/rice_button.dart';
import 'package:capstone_dr_rice/widgets/display/rice_divider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:capstone_dr_rice/widgets/input/textfield_input.dart';
import 'package:provider/provider.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userName;
    _emailController.text = widget.userEmail;
    _profileImagePath = widget.userProfileImage;
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

  Future<String?> _uploadImageToFirebase(String userId) async {
    if (_profileImagePath == null || !_profileImagePath!.startsWith('/'))
      return null;

    try {
      final file = File(_profileImagePath!);
      final storageRef = FirebaseStorage.instance.ref().child(
        'profile_images/$userId.jpg',
      );
      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _updateProfile() async {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Validation
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(languageProvider.translate('Name cannot be empty')),
        ),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty ||
        !_isValidEmail(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            languageProvider.translate('Please enter a valid email'),
          ),
        ),
      );
      return;
    }

    if (_newPasswordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(languageProvider.translate('Passwords do not match')),
          ),
        );
        return;
      }
      if (_newPasswordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              languageProvider.translate(
                'Password must be at least 6 characters',
              ),
            ),
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      // Upload image to Firebase Storage if changed
      String? photoUrl = widget.userProfileImage;
      if (_profileImagePath != widget.userProfileImage &&
          _profileImagePath != null) {
        photoUrl = await _uploadImageToFirebase(user.uid);
      }

      // Update Firebase Auth profile
      await user.updateProfile(
        displayName: _nameController.text.trim(),
        photoURL: photoUrl,
      );

      // Update email if changed
      if (_emailController.text.trim() != widget.userEmail) {
        await user.updateEmail(_emailController.text.trim());
      }

      // Update password if provided
      if (_newPasswordController.text.isNotEmpty) {
        await user.updatePassword(_newPasswordController.text);
      }

      // Notify user and return updated data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              languageProvider.translate('Profile updated successfully'),
            ),
          ),
        );
        Navigator.pop(context, {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'photoUrl': photoUrl,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(languageProvider.translate('Update failed:') + ' $e'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: RiceColors.backgroundAccent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          languageProvider.translate('Edit Profile'),
          style: RiceTextStyles.body,
        ),
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
                            ? (_profileImagePath!.startsWith('http')
                                ? NetworkImage(_profileImagePath!)
                                : FileImage(File(_profileImagePath!)))
                            : const AssetImage(
                                  'assets/images/profile_placeholder.jpg',
                                )
                                as ImageProvider,
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
              label: languageProvider.translate('Name'),
              controller: _nameController,
              hint: widget.userName,
            ),
            const SizedBox(height: RiceSpacings.m),
            TextfieldInput(
              label: languageProvider.translate('Email'),
              controller: _emailController,
              hint: widget.userEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: RiceSpacings.xl),
            const RiceDivider(),
            const SizedBox(height: RiceSpacings.xl),
            Text(
              languageProvider.translate('Change Password?'),
              style: RiceTextStyles.body,
            ),
            const SizedBox(height: RiceSpacings.m),
            TextfieldInput(
              label: languageProvider.translate('New Password'),
              controller: _newPasswordController,
              hint: languageProvider.translate('Enter new password'),
              obscureText: true,
            ),
            const SizedBox(height: RiceSpacings.m),
            TextfieldInput(
              label: languageProvider.translate('Confirm Password'),
              controller: _confirmPasswordController,
              hint: languageProvider.translate('Confirm new password'),
              obscureText: true,
            ),
            const SizedBox(height: RiceSpacings.xl),
            const RiceDivider(),
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
                        text: languageProvider.translate('Update'),
                        icon: Icons.edit,
                        type: RiceButtonType.primary,
                        onPressed: () async {
                          final name = _nameController.text.trim();
                          final email = _emailController.text.trim();
                          final newPassword =
                              _newPasswordController.text.trim();
                          final confirmPassword =
                              _confirmPasswordController.text.trim();

                          // Validate input fields
                          if (name.isEmpty || email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  languageProvider.translate(
                                    'Please fill in all fields',
                                  ),
                                ),
                              ),
                            );
                            return;
                          }

                          if (newPassword.isNotEmpty &&
                              newPassword != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  languageProvider.translate(
                                    'Passwords do not match',
                                  ),
                                ),
                              ),
                            );
                            return;
                          }

                          try {
                            final user = FirebaseAuth.instance.currentUser;

                            // Update email
                            if (email != widget.userEmail) {
                              await user?.updateEmail(email);
                            }

                            // Update password
                            if (newPassword.isNotEmpty) {
                              await user?.updatePassword(newPassword);
                            }

                            // Update displayName
                            if (name != widget.userName) {
                              await user?.updateDisplayName(name);
                            }

                            // Return updated name and email to the previous screen
                            Navigator.pop(context, {
                              'name': name,
                              'email': email,
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  languageProvider.translate(
                                    'Profile updated successfully',
                                  ),
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${languageProvider.translate('Failed to update profile')}: $e',
                                ),
                              ),
                            );
                          }
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}