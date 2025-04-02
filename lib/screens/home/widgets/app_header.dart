
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/screens/home/widgets/call_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
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
                  CallButton(phoneNumber: "017889223"),
                  const SizedBox(width: RiceSpacings.s / 2),

                  // Language Dropdown
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: RiceSpacings.m),
                    decoration: BoxDecoration(
                      color: RiceColors.neutralLighter, // Button background
                      borderRadius: BorderRadius.circular(25), // More rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: RiceColors.neutral, // Subtle border
                        width: 0.5,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: languageProvider.languageCode,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            languageProvider.setLanguage(newValue);
                          }
                        },
                        icon: Icon(
                          Icons.expand_more, // More elegant icon
                          size: 20,
                          color: RiceColors.neutralDark,
                        ),
                        dropdownColor: RiceColors.neutralLighter, // Menu background
                        borderRadius: BorderRadius.circular(15), // Rounded menu corners
                        elevation: 4, // Subtle shadow for menu
                        style: RiceTextStyles.button.copyWith(
                          fontSize: 14,
                          color: RiceColors.neutralDark,
                        ),
                        itemHeight: 50, // Taller items for better touch area
                        items: [
                          DropdownMenuItem(
                            value: 'en',
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    'assets/images/uk.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                const SizedBox(width: RiceSpacings.s),
                                Text(
                                  "English",
                                  style: RiceTextStyles.button.copyWith(
                                    fontSize: 14,
                                    color: RiceColors.neutralDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'kh',
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    'assets/images/khm.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                const SizedBox(width: RiceSpacings.s),
                                Text(
                                  "ភាសាខ្មែរ",
                                  style: RiceTextStyles.button.copyWith(
                                    fontSize: 14,
                                    color: RiceColors.neutralDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}