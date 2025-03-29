import 'package:capstone_dr_rice/screens/home/home_screen.dart';
// import 'package:capstone_dr_rice/screens/profile/profile_screen.dart';
import 'package:capstone_dr_rice/screens/saved%20diagnosis/saved_diagnosis_screen.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:icon_decoration/icon_decoration.dart';

import '../../screens/get started/get_started_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // Declare widget options without initializing them directly
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      const HomeScreen(),
      const SaveScreen(),
      // const ProfileScreen(),
      const GetStartedScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: RiceColors.backgroundAccent,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: DecoratedIcon(
              icon: Icon(
                Icons.home,
                color:
                    _selectedIndex == 0
                        ? RiceColors.neutral
                        : RiceColors.textLight,
                size: 30,
              ),
              decoration: const IconDecoration(border: IconBorder()),
            ),
            label: 'Home',
            backgroundColor: RiceColors.backgroundAccent,
          ),
          BottomNavigationBarItem(
            icon: DecoratedIcon(
              icon: Icon(
                Icons.bookmark,
                color:
                    _selectedIndex == 1
                        ? RiceColors.neutral
                        : RiceColors.textLight,
                size: 30,
              ),
              decoration: const IconDecoration(border: IconBorder()),
            ),
            label: 'Saved',
            backgroundColor: RiceColors.backgroundAccent,
          ),
          BottomNavigationBarItem(
            icon: DecoratedIcon(
              icon: Icon(
                Icons.person,
                color:
                    _selectedIndex == 2
                        ? RiceColors.neutral
                        : RiceColors.textLight,
                size: 30,
              ),
              decoration: const IconDecoration(border: IconBorder()),
            ),
            label: 'Profile',
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
  }
}
