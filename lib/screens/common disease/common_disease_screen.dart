import 'package:capstone_dr_rice/screens/common%20disease/widgets/detail_disease_card.dart';
import 'package:capstone_dr_rice/screens/common%20disease/widgets/disease_card.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:capstone_dr_rice/widgets/display/rice_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/diseases_provider.dart';

class CommonDiseasesScreen extends StatefulWidget {
  const CommonDiseasesScreen({super.key});

  @override
  State<CommonDiseasesScreen> createState() => _CommonDiseasesScreenState();
}

class _CommonDiseasesScreenState extends State<CommonDiseasesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<DiseaseProvider>(context, listen: false).fetchDiseases();
  }

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

      body: Column(
        children: [
          RiceDivider(),
          Expanded(
            child: Consumer<DiseaseProvider>(
              builder: (context, diseaseProvider, child) {
                if (diseaseProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (diseaseProvider.diseases.isEmpty) {
                  return Center(
                    child: Text(
                      'No diseases found.',
                      style: RiceTextStyles.body.copyWith(
                        color: RiceColors.neutralDark,
                      ),
                    ),
                  );
                }

                return
                //  Container(
                //   color: RiceColors.backgroundAccent,
                //   child: Column(
                //     children: [
                // RiceDivider(),
                //     Expanded(
                //     child:
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: RiceSpacings.m),
                  itemCount: diseaseProvider.diseases.length,
                  itemBuilder: (context, index) {
                    final disease = diseaseProvider.diseases[index];

                    return DiseaseCard(
                      disease: disease,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailDiseaseCard(disease: disease,),
                          ),
                        );
                      },
                    );
                  },
                );
                //    ),
                //   ],
                //    ),
                //     );
              },
            ),
          ),
        ],
      ),
    );
  }

 
}
