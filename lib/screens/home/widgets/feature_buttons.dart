import 'package:capstone_dr_rice/dummy_data/dummy_data.dart';
import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class FeatureButtons extends StatelessWidget {
  final Function(String) onFeaturePressed;

  const FeatureButtons({
    super.key,
    required this.onFeaturePressed,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; 
    double buttonWidth = screenWidth * 0.25;
    double buttonHeight = 25;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: featureButtons.map((button) {
        return Expanded(
          child: GestureDetector(
            onTap: () => onFeaturePressed(button['route']!),
            child: Container(
              width: buttonWidth,
              margin: const EdgeInsets.symmetric(horizontal: RiceSpacings.s / 2),
              padding: const EdgeInsets.symmetric(vertical: RiceSpacings.m / 2),
              decoration: BoxDecoration(
                color: RiceColors.neutralLight,
                borderRadius: BorderRadius.circular(RiceSpacings.radiusLarge),
                border: Border.fromBorderSide(BorderSide(width: 0.5, color: RiceColors.neutral))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    button['icon']!,
                    height: 65,
                  ),
                  const SizedBox(height: RiceSpacings.m),
                  
                 SizedBox(
                    width: buttonWidth,
                    height: buttonHeight, 
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: RiceColors.neutralLighter,
                        borderRadius: BorderRadius.circular(RiceSpacings.radiusLarge),
                        border: Border.fromBorderSide(
                          BorderSide(width: 0.5, color: RiceColors.neutral),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          button['title']!,
                          style: RiceTextStyles.label.copyWith(
                            color: RiceColors.neutralDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

