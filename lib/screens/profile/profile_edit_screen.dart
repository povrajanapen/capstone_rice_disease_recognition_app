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
                            : AssetImage('assets/images/placeholder.png'),
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
                onPressed: () {
                  // Handle update logic here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
