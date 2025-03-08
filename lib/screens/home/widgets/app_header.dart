import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 3,
        right: 3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'assets/images/logo.png',
            height: 75,
          ),

          // Right side buttons
          Row(
            children: [
              // Call Expert Button
              Container(
                height: 38,
                width: 60,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: RiceColors.neutral,
                  borderRadius: BorderRadius.circular(
                    20,
                  ), 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone_in_talk,
                      color: RiceColors.white,
                      size: 20, 
                    ),
                  ],
                ),
              ),
              const SizedBox(width: RiceSpacings.s / 2),

              // Language Dropdown
              Container(
                height: 40, 
                padding: const EdgeInsets.symmetric(horizontal: RiceSpacings.s),
                decoration: BoxDecoration(
                  color: RiceColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: RiceColors.neutralLight),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'en',
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      size: 18,
                    ), 
                    items: [
                      DropdownMenuItem(
                        value: 'en',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/uk.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: RiceSpacings.s / 2),
                            const Text(
                              "English",
                              style: TextStyle(
                                fontSize: 14,
                              ), 
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'kh',
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/khm.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: RiceSpacings.s / 2),
                            const Text(
                              "ភាសាខ្មែរ",
                              style: TextStyle(
                                fontSize: 14,
                              ), 
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (String? value) {
                      // Handle language change logic here
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
