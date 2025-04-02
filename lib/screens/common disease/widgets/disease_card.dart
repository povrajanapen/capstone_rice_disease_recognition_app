

import 'package:capstone_dr_rice/models/disease.dart' show Disease, DiseasePart;
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiseaseCard extends StatelessWidget {
  final Disease disease;
  final String? imageUrl;
  final VoidCallback? onTap;

  const DiseaseCard({
    super.key,
    required this.disease,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    // Translation keys
    String nameKey = disease.name;
    String descKey = "${disease.name.replaceAll(' ', '')}Description";
    String translatedName = languageProvider.translate(nameKey);
    String translatedDesc = languageProvider.translate(descKey);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: RiceSpacings.s, horizontal: RiceSpacings.m),
        decoration: BoxDecoration(
          color: RiceColors.neutralLighter,
          borderRadius: BorderRadius.circular(RiceSpacings.radiusLarge),
          border: Border.fromBorderSide(BorderSide(color: RiceColors.neutral, width: 0.5)),
        ),
        child: Padding(
          padding: EdgeInsets.all(RiceSpacings.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disease image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(RiceSpacings.radius),
                    child: Image.asset(
                      imageUrl ?? 'assets/images/disease_thumbnail.jpg',
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: RiceSpacings.m),

                  // Disease details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Disease name (translated)
                        Text(
                          translatedName,
                          style: RiceTextStyles.button.copyWith(
                            color: RiceColors.neutralDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Affected Part
                        SizedBox(height: 5),
                        if (disease.affectedPart != null)
                          Row(
                            children: [
                              Text(
                                languageProvider.translate('Part of Disease'),
                                style: RiceTextStyles.label.copyWith(
                                  color: RiceColors.neutral,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ": ${languageProvider.translate(disease.affectedPart!.name)}",
                                style: RiceTextStyles.label.copyWith(
                                  color: RiceColors.neutral,
                                ),
                              ),
                            ],
                          ),

                        // Description (translated with fallback)
                        SizedBox(height: RiceSpacings.s),
                        Text(
                          translatedDesc == descKey ? disease.description : translatedDesc,
                          style: RiceTextStyles.label.copyWith(
                            color: RiceColors.textNormal,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}