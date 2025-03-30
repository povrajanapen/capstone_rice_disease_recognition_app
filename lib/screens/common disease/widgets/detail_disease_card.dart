import 'package:capstone_dr_rice/widgets/display/rice_divider.dart';
import 'package:flutter/material.dart';
import 'package:capstone_dr_rice/models/disease.dart' show Disease, DiseasePart;
import '../../../theme/theme.dart';

class DetailDiseaseCard extends StatelessWidget {
  final Disease disease;
  const DetailDiseaseCard({super.key, required this.disease});
  String _getAffectedPartText(DiseasePart? part) {
    return part != null ? part.name : 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          disease.name,
          style: RiceTextStyles.body.copyWith(
            color: RiceColors.neutralDark,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: RiceColors.backgroundAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(RiceSpacings.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Disease Image
            ClipRRect(
              borderRadius: BorderRadius.circular(RiceSpacings.radius),
              child: Image.network(
                disease.imagePath ?? 'https://via.placeholder.com/85',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(height: RiceSpacings.m),

            //Disease Name
            Text(
              disease.name,
              style: RiceTextStyles.heading.copyWith(
                color: RiceColors.neutralDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: RiceSpacings.s),
            
            //Disease Part
            Row(
              children: [
                Icon(Icons.eco, color: RiceColors.neutral, size: 16),
                SizedBox(width: RiceSpacings.s / 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Part of Disease: ",
                        style: RiceTextStyles.label.copyWith(
                          fontSize: 14,
                          color: RiceColors.neutral,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: _getAffectedPartText(disease.affectedPart),
                        style: RiceTextStyles.label.copyWith(
                          fontSize: 14,
                          color: RiceColors.neutral,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        
            SizedBox(height: RiceSpacings.m),
            RiceDivider(),
            SizedBox(height: RiceSpacings.s),

            // Disease Description
            Text(
              "Description",
              style: RiceTextStyles.body.copyWith(color: RiceColors.neutralDark),
            ),
            SizedBox(height: RiceSpacings.s),
            Text(
              disease.description,
              style: RiceTextStyles.label.copyWith(color: RiceColors.textNormal),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
