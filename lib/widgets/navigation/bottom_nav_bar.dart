
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/screens/home/home_screen.dart';
import 'package:capstone_dr_rice/screens/saved%20diagnosis/saved_diagnosis_screen.dart';
import 'package:capstone_dr_rice/screens/get%20started/get_started_screen.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // Define widget options as a static const list
  static const List<Widget> _widgetOptions = [
    HomeScreen(),
    SaveScreen(),
    GetStartedScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) { // Prevent action if already on the same screen
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
          body: Container(
            color: RiceColors.backgroundAccent,
            child: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: DecoratedIcon(
                  icon: Icon(
                    Icons.home,
                    color: _selectedIndex == 0 ? RiceColors.neutral : RiceColors.textLight,
                    size: 30,
                  ),
                  decoration: const IconDecoration(border: IconBorder()),
                ),
                label: languageProvider.translate('Home'),
                backgroundColor: RiceColors.backgroundAccent,
              ),
              BottomNavigationBarItem(
                icon: DecoratedIcon(
                  icon: Icon(
                    Icons.bookmark,
                    color: _selectedIndex == 1 ? RiceColors.neutral : RiceColors.textLight,
                    size: 30,
                  ),
                  decoration: const IconDecoration(border: IconBorder()),
                ),
                label: languageProvider.translate('Saved'),
                backgroundColor: RiceColors.backgroundAccent,
              ),
              BottomNavigationBarItem(
                icon: DecoratedIcon(
                  icon: Icon(
                    Icons.person,
                    color: _selectedIndex == 2 ? RiceColors.neutral : RiceColors.textLight,
                    size: 30,
                  ),
                  decoration: const IconDecoration(border: IconBorder()),
                ),
                label: languageProvider.translate('Profile'),
                backgroundColor: RiceColors.backgroundAccent,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: RiceColors.neutral,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.shifting,
            unselectedItemColor: RiceColors.textLight,
          ),
        );
      },
    );
  }
}