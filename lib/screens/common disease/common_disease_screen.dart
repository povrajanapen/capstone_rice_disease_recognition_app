// common_diseases_screen.dart
import 'package:capstone_dr_rice/models/disease.dart';
import 'package:capstone_dr_rice/models/disease_data.dart';
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/screens/common%20disease/widgets/disease_card.dart';
import 'package:capstone_dr_rice/screens/common%20disease/disease_detail_screen.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:capstone_dr_rice/widgets/display/rice_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonDiseasesScreen extends StatelessWidget {
  const CommonDiseasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
        final languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          languageProvider.translate('Common Rice Diseases'),
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
              child: FutureBuilder<List<Disease>>(
                future: DiseaseDataLoader.loadDiseases(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: Text('Error loading disease data'),
                    );
                  }

                  final diseases = snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: RiceSpacings.m),
                    itemCount: diseases.length,
                    itemBuilder: (context, index) {
                      final disease = diseases[index];

                      return DiseaseCard(
                        disease: disease,
                        imageUrl:
                            disease.imageUrl ??
                            'assets/images/disease_thumbnail.jpg',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DiseaseDetailScreen(
                                    disease: disease,
                                    imageUrl:
                                        disease.imageUrl ??
                                        'assets/images/disease_thumbnail.jpg',
                                  ),
                            ),
                          );
                        },
                      );
                    },
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

