import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class RiceDivider extends StatelessWidget {
  const RiceDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: RiceColors.greyLight,
    );
  }
}
