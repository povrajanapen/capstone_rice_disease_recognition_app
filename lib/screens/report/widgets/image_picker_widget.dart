import 'dart:io';

import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(String?) onImageSelected;

  const ImagePickerWidget({super.key, required this.onImageSelected});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String? imagePath;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null && image.path.isNotEmpty) {
      setState(() {
        imagePath = image.path;
      });
      widget.onImageSelected(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);
    return GestureDetector(
      onTap: pickImage,
      child: DottedBorder(
        color: Colors.black,
        strokeWidth: 0.5,
        dashPattern: [8, 4],
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        padding: EdgeInsets.all(RiceSpacings.s),
        child: Container(
         width: double.infinity,
         padding: EdgeInsets.all(RiceSpacings.s),
         decoration: BoxDecoration(
          color: RiceColors.greyLight,
          border: Border.all(color: Colors.grey, width: 0.25),
          borderRadius: BorderRadius.circular(RiceSpacings.radius),
        ),
          child: imagePath != null
              ? Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, color: Colors.grey, size: 30),
                    SizedBox(width: RiceSpacings.s),
                    Text(
                      languageProvider.translate("Select image"),
                      style: RiceTextStyles.label.copyWith(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
