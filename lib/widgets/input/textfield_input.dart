import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';

class TextfieldInput extends StatelessWidget {
   final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  
  const TextfieldInput({
    super.key, required this.label, required this.controller, this.maxLines = 1, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: RiceTextStyles.label.copyWith(fontSize: 14)),
        SizedBox(height: RiceSpacings.s/2),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: RiceColors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RiceSpacings.radius),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 0.75),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(RiceSpacings.radius),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}