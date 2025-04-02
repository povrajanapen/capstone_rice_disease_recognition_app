import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/screens/home/home_screen.dart';
import 'package:capstone_dr_rice/screens/saved%20diagnosis/saved_diagnosis_screen.dart';
import 'package:capstone_dr_rice/screens/get%20started/get_started_screen.dart';
import 'package:capstone_dr_rice/screens/profile/profile_screen.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex; // Added optional initialIndex parameter
  const BottomNavBar({super.key, this.initialIndex = 0}); // Default to Home (0)

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Set initial index from widget
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final widgetOptions = [
                const HomeScreen(),
                const SaveScreen(),
                snapshot.data == null ? const GetStartedScreen() : const ProfileScreen(),
              ];

              return Container(
                color: RiceColors.backgroundAccent,
                child: IndexedStack(
                  index: _selectedIndex,
                  children: widgetOptions,
                ),
              );
            },
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: RiceColors.backgroundAccent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      size: 30,
                      color: _selectedIndex == 0 ? RiceColors.neutralDark : RiceColors.neutralLightest,
                    ),
                    activeIcon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home, size: 30, color: RiceColors.neutralDark),
                        const SizedBox(height: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: RiceColors.neutralDark,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    label: languageProvider.translate('Home'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.bookmark,
                      size: 30,
                      color: _selectedIndex == 1 ? RiceColors.primary : RiceColors.neutralLightest,
                    ),
                    activeIcon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bookmark, size: 30, color: RiceColors.neutralDark),
                        const SizedBox(height: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration:  BoxDecoration(
                            color: RiceColors.neutralDark,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    label: languageProvider.translate('Saved'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      size: 30,
                      color: _selectedIndex == 2 ? RiceColors.neutralDark : RiceColors.neutralLightest,
                    ),
                    activeIcon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person, size: 30, color: RiceColors.neutralDark),
                        const SizedBox(height: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration:  BoxDecoration(
                            color: RiceColors.neutralDark,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    label: languageProvider.translate('Profile'),
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                backgroundColor: RiceColors.backgroundAccent,
                selectedItemColor: RiceColors.neutralDark,
                unselectedItemColor: RiceColors.neutralLightest,
                showUnselectedLabels: true,
                elevation: 0,
                selectedLabelStyle: RiceTextStyles.label.copyWith(
                  fontWeight: FontWeight.w600,
                  color: RiceColors.neutralDark,
                ),
                unselectedLabelStyle: RiceTextStyles.label.copyWith(
                  color: RiceColors.neutralLightest,
                ),
                enableFeedback: false,
              ),
            ),
          ),
        );
      },
    );
  }
}