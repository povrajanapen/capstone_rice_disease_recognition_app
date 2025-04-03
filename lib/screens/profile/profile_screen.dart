
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/screens/report/your_reports_screen.dart';
import 'package:capstone_dr_rice/widgets/action/rice_button.dart';
import 'package:capstone_dr_rice/widgets/display/rice_divider.dart';
import 'package:capstone_dr_rice/widgets/navigation/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import '../../service/auth_service.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userEmail;
  String? userPhotoURL;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      setState(() {
        userName = user.displayName ?? 'No Name';
        userEmail = user.email ?? 'No Email';
        userPhotoURL = user.photoURL;
      });
    }
  }

  Future<void> _logout() async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavBar(initialIndex: 0), // Set to Home tab (index 0)
        ),
      );
    }
  }

  void _showLanguageDialog(BuildContext context, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: RiceColors.backgroundAccent,
        title: Text(
          languageProvider.translate('Select Language'),
          style: RiceTextStyles.body.copyWith(
            color: RiceColors.neutralDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RiceButton(
              text: 'English',
              type: RiceButtonType.primary,
              onPressed: () {
                languageProvider.setLanguage('en');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: RiceSpacings.m),
            RiceButton(
              text: 'ភាសាខ្មែរ',
              type: RiceButtonType.primary,
              onPressed: () {
                languageProvider.setLanguage('kh');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              languageProvider.translate('Close'),
              style: RiceTextStyles.button.copyWith(color: RiceColors.neutralDark),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: RiceColors.backgroundAccent,
      appBar: AppBar(
        title: Text(languageProvider.translate('Profile'), style: RiceTextStyles.body),
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
                  userPhotoURL != null && userPhotoURL!.startsWith('http')
                      ? NetworkImage(userPhotoURL!)
                      : const AssetImage('assets/images/profile_placeholder.jpg') as ImageProvider,
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
                title: Text(languageProvider.translate('Edit Profile'), style: RiceTextStyles.button),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileEditScreen(
                        userName: userName ?? 'No Name',
                        userEmail: userEmail ?? 'No Email',
                        userProfileImage: userPhotoURL,
                      ),
                    ),
                  );

                  if (result != null && mounted) {
                    setState(() {
                      userName = result['name'];
                      userEmail = result['email'];
                      userPhotoURL = result['photoUrl']; // Update photo URL
                    });
                  }
                },
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
                title: Text(
                  languageProvider.translate('Language'),
                  style: RiceTextStyles.button,
                ),
                onTap: () => _showLanguageDialog(context, languageProvider),
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
                title: Text(languageProvider.translate('Your reports'), style: RiceTextStyles.button),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const YourReportsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: RiceSpacings.xl),
            const RiceDivider(),
            const SizedBox(height: RiceSpacings.xl),
            RiceButton(
              text: languageProvider.translate('Logout'),
              icon: Icons.logout,
              type: RiceButtonType.secondary,
              onPressed: _logout,
            ),
          ],
        ),
      ),
    );
  }
}