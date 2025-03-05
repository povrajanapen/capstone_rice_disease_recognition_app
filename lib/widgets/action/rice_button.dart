import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';

enum RiceButtonType { primary, secondary }

class RiceButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final RiceButtonType type;

  const RiceButton({
    this.icon,
    required this.onPressed,
    required this.text,
    this.type = RiceButtonType.primary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Define button color
    Color backGroundColor =
        type == RiceButtonType.primary ? RiceColors.primary : RiceColors.red;
    Color textColor = RiceColors.white;
    Color iconColor = RiceColors.white;
    BorderSide border =
        type == RiceButtonType.primary
            ? BorderSide.none
            : BorderSide(color: RiceColors.red, width: 1);

    // build button widget
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: backGroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RiceSpacings.radius),
        ),
        side: border,
        padding: EdgeInsets.symmetric(
          horizontal: RiceSpacings.xl,
          vertical: RiceSpacings.m,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor, size: 20),
            SizedBox(width: RiceSpacings.s),
          ],
          Text(text, style: RiceTextStyles.button.copyWith(color: textColor)),
        ],
      ),
    );
  }
}
