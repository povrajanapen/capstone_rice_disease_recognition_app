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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: featureButtons.map((button) {
        return Expanded(
          child: GestureDetector(
            onTap: () => onFeaturePressed(button['route']!),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: RiceSpacings.s / 2),
              padding: const EdgeInsets.all(RiceSpacings.m),
              decoration: BoxDecoration(
                color: RiceColors.neutralLighter,
                borderRadius: BorderRadius.circular(RiceSpacings.radius),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    button['icon']!,
                    height: 32,
                    color: RiceColors.neutral,
                  ),
                  const SizedBox(height: RiceSpacings.s),
                  Text(
                    button['title']!,
                    style: RiceTextStyles.label.copyWith(
                      color: RiceColors.textNormal,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
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

