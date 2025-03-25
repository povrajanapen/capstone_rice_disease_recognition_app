import 'package:capstone_dr_rice/widgets/action/rice_button.dart';
import 'package:capstone_dr_rice/widgets/display/rice_divider.dart';
import 'package:flutter/material.dart';
import 'package:capstone_dr_rice/theme/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName; // This will be updated based on user login
  String? userEmail; // This will be updated based on user login
  String? userProfileImage; // This will be updated based on user login

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RiceColors.backgroundAccent,
      appBar: AppBar(
        title: Text('Profile', style: RiceTextStyles.body),
        centerTitle: true,
        backgroundColor: RiceColors.backgroundAccent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: RiceColors.neutralLight, height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(RiceSpacings.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  userProfileImage != null
                      ? AssetImage(userProfileImage!)
                      : AssetImage('assets/images/placeholder.png'),
            ),
            const SizedBox(height: RiceSpacings.m),
            Text(
              userName ?? 'No Name',
              style: RiceTextStyles.body.copyWith(
                color: RiceColors.neutralDark,
              ),
            ),
            Text(
              userEmail ?? 'No Email',
              style: RiceTextStyles.label.copyWith(color: RiceColors.neutral),
            ),
            const SizedBox(height: RiceSpacings.xl),
            Container(
              decoration: BoxDecoration(
                color: RiceColors.neutralLight,
                borderRadius: BorderRadius.circular(RiceSpacings.radius),
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.black),
                title: Text('Edit Profile', style: RiceTextStyles.button),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () {},
              ),
            ),
            const SizedBox(height: RiceSpacings.m),
            Container(
              decoration: BoxDecoration(
                color: RiceColors.neutralLight,
                borderRadius: BorderRadius.circular(RiceSpacings.radius),
              ),
              child: ListTile(
                leading: const Icon(Icons.language, color: Colors.black),
                title: Text('Language', style: RiceTextStyles.button),
                onTap: () {},
              ),
            ),
            const SizedBox(height: RiceSpacings.m),
            Container(
              decoration: BoxDecoration(
                color: RiceColors.neutralLight,
                borderRadius: BorderRadius.circular(RiceSpacings.radius),
              ),
              child: ListTile(
                leading: const Icon(Icons.campaign, color: Colors.black),
                title: Text('Your reports', style: RiceTextStyles.button),
                onTap: () {},
              ),
            ),
            const SizedBox(height: RiceSpacings.xl),
            const RiceDivider(),
            const SizedBox(height: RiceSpacings.xl),
            RiceButton(
              text: 'Logout',
              icon: Icons.logout,
              type: RiceButtonType.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
