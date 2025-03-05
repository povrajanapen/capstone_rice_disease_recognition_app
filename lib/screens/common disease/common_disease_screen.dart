import 'package:capstone_dr_rice/dummy_data/dummy_data.dart';
import 'package:capstone_dr_rice/screens/common%20disease/widgets/disease_card.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:capstone_dr_rice/widgets/display/rice_divider.dart';
import 'package:flutter/material.dart';

class CommonDiseasesScreen extends StatelessWidget {
  const CommonDiseasesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Common Rice Diseases',
          style: RiceTextStyles.body.copyWith(color: RiceColors.neutralDark),
        ),
        backgroundColor: RiceColors.backgroundAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: RiceColors.neutralDark),
      ),
      
      body: Container(
        color: RiceColors.backgroundAccent,
        child: Column(
          children: [
            RiceDivider(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: RiceSpacings.m),
                itemCount: diseases.length, // for now Using the dummy data
                itemBuilder: (context, index) {
                  final disease = diseases[index];
                  
                  // Find a matching diagnosis to get the image URL
                  final matchingDiagnosis = recentDiagnoses.firstWhere(
                    (diagnosis) => diagnosis.disease.id == disease.id,
                    orElse: () => recentDiagnoses.first, // - Fallback to the first diagnosis if no match is found
                  );
                  
                  return DiseaseCard(
                    disease: disease,
                    imageUrl: matchingDiagnosis.imageUrl,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}