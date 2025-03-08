import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../theme/theme.dart';

class FilePickerWidget extends StatefulWidget {
  final Function(String?) onFileSelected;

  const FilePickerWidget({super.key, required this.onFileSelected});

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  String? filePath;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        filePath = result.files.single.path!;
      });
      widget.onFileSelected(filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickFile,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(RiceSpacings.s),
        decoration: BoxDecoration(
          color: RiceColors.neutral,
          border: Border.all(color: RiceColors.primary),
          borderRadius: BorderRadius.circular(RiceSpacings.radius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, color: RiceColors.white, size: 40),
            SizedBox(height: RiceSpacings.s),
            Text(
              filePath != null ? "File Selected" : "Select file",
              style: RiceTextStyles.body.copyWith(
                fontSize: 16,
                color: RiceColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
