
import 'package:capstone_dr_rice/models/disease.dart';
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:capstone_dr_rice/widgets/display/rice_divider.dart';
import 'package:flutter/material.dart';
import '../../../utils/date_time_util.dart';

class DiagnosisListItem extends StatelessWidget {
  final Diagnose diagnosis;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;
  final LanguageProvider languageProvider;

  const DiagnosisListItem({
    super.key,
    required this.diagnosis,
    required this.onTap,
    required this.onMoreTap,
    required this.languageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: RiceSpacings.s),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildDiseaseImage(),
                const SizedBox(width: 16),
                Expanded(child: _buildDiseaseInfo(languageProvider)),
              ],
            ),
          ),
        ),
        RiceDivider(),
      ],
    );
  }

  Widget _buildDiseaseImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(RiceSpacings.radius),
      child: Image.asset(
        diagnosis.imagePath,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 64,
            height: 64,
            color: Colors.grey.shade200,
            child: const Icon(Icons.image_not_supported, color: Colors.grey),
          );
        },
      ),
    );
  }

  Widget _buildDiseaseInfo(LanguageProvider languageProvider) {
    String nameKey = diagnosis.disease.name;
    String descKey = "${diagnosis.disease.name.replaceAll(' ', '')}Description";
    String translatedName = languageProvider.translate(nameKey);
    String translatedDesc = languageProvider.translate(descKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Disease Name (translated)
            Expanded(
              child: Text(
                translatedName,
                style: RiceTextStyles.label.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Row(
              children: [
                // Scan Date (not translated, dynamic)
                Text(
                  getRelativeTime(diagnosis.timestamp),
                  style: RiceTextStyles.label.copyWith(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
                SizedBox(width: 1),
                // More Icon
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 16),
                  onPressed: onMoreTap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 2),
        // Disease Description (translated with fallback)
        Text(
          translatedDesc == descKey ? diagnosis.disease.description : translatedDesc,
          style: RiceTextStyles.label.copyWith(
            color: Colors.grey.shade700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}