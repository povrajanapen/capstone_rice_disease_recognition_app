// // disease_detail_screen.dart
// import 'package:capstone_dr_rice/models/disease.dart';
// import 'package:capstone_dr_rice/provider/language_provider.dart';
// import 'package:capstone_dr_rice/theme/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:provider/provider.dart';

// class DiseaseDetailScreen extends StatefulWidget {
//   final Disease disease;
//   final String? imageUrl;

//   const DiseaseDetailScreen({super.key, required this.disease, this.imageUrl});

//   @override
//   _DiseaseDetailScreenState createState() => _DiseaseDetailScreenState();
// }

// class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
//   final FlutterTts flutterTts = FlutterTts();

//   @override
//   void initState() {
//     super.initState();
//     flutterTts.setLanguage("en-US");
//     flutterTts.setPitch(1.0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     LanguageProvider languageProvider =
//         Provider.of<LanguageProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           languageProvider.translate(widget.disease.name),
//           style: RiceTextStyles.body.copyWith(color: RiceColors.neutralDark),
//         ),
//         backgroundColor: RiceColors.backgroundAccent,
//         elevation: 0,
//         iconTheme: IconThemeData(color: RiceColors.neutralDark),
//       ),
//       body: DefaultTabController(
//         length: 2,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(RiceSpacings.m),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Disease Image
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(RiceSpacings.radiusLarge),
//                   child: Image.asset(
//                     widget.imageUrl ?? 'assets/images/disease_thumbnail.jpg',
//                     width: double.infinity,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(height: RiceSpacings.s),

//                 // Disease Name
//                 Text(
//                   languageProvider.translate(widget.disease.name),
//                   style: RiceTextStyles.heading.copyWith(
//                     color: RiceColors.neutralDark,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: RiceSpacings.s),

//                 // Affected Part
//                 if (widget.disease.affectedPart != null)
//                   Row(
//                     children: [
//                       Text(
//                         languageProvider.translate('Affected Part: '),
//                         style: RiceTextStyles.body.copyWith(
//                           color: RiceColors.neutral,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         languageProvider.translate(widget.disease.affectedPart!.name),
//                         style: RiceTextStyles.body.copyWith(
//                           color: RiceColors.neutral,
//                         ),
//                       ),
//                     ],
//                   ),
//                 SizedBox(height: RiceSpacings.m),

//                 // TabBar
//                 TabBar(
//                   labelStyle: RiceTextStyles.subheadline.copyWith(
//                     color: RiceColors.neutralDark,
//                     fontWeight: FontWeight.bold,
//                     fontSize: RiceTextStyles.subheadline.fontSize! - 2,
//                   ),
//                   unselectedLabelStyle: RiceTextStyles.subheadline.copyWith(
//                     color: RiceColors.neutral,
//                   ),
//                   labelColor: RiceColors.neutralDark,
//                   unselectedLabelColor: RiceColors.neutral,
//                   indicatorColor: RiceColors.neutralDark,
//                   tabs: [Tab(text: languageProvider.translate('Symptoms')), Tab(text: languageProvider.translate('Manage'))],
//                 ),

//                 // TabBarView
//                 SizedBox(
//                   height:
//                       MediaQuery.of(context).size.height *
//                       0.4, // Adjust height as needed
//                   child: TabBarView(
//                     children: [
//                       // Symptoms Tab
//                       Padding(
//                         padding: EdgeInsets.only(top: RiceSpacings.s),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   languageProvider.translate('Symptoms'),
//                                   style: RiceTextStyles.subheadline.copyWith(
//                                     color: RiceColors.neutralDark,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.volume_up),
//                                   onPressed: () async {
//                                     await flutterTts.speak(
//                                       widget.disease.symptoms,
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: RiceSpacings.s),
//                             Expanded(
//                               child: SingleChildScrollView(
//                                 child: Text(
//                                   widget.disease.symptoms,
//                                   style: RiceTextStyles.body.copyWith(
//                                     color: RiceColors.grey,
//                                     fontSize: RiceTextStyles.body.fontSize! - 4,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Management Tab
//                       Padding(
//                         padding: EdgeInsets.only(top: RiceSpacings.s),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   languageProvider.translate('Management'),
//                                   style: RiceTextStyles.subheadline.copyWith(
//                                     color: RiceColors.neutralDark,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.volume_up),
//                                   onPressed: () async {
//                                     await flutterTts.speak(
//                                       widget.disease.management,
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: RiceSpacings.s),
//                             Expanded(
//                               child: SingleChildScrollView(
//                                 child: Text(
//                                  widget.disease.management,
//                                   style: RiceTextStyles.body.copyWith(
//                                     color: RiceColors.grey,
//                                     fontSize: RiceTextStyles.body.fontSize! - 4,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:capstone_dr_rice/models/disease.dart';
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class DiseaseDetailScreen extends StatefulWidget {
  final Disease disease;
  final String? imageUrl;

  const DiseaseDetailScreen({super.key, required this.disease, this.imageUrl});

  @override
  _DiseaseDetailScreenState createState() => _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage('en-US');
    flutterTts.setPitch(1.0);
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    String ttsLanguage = languageProvider.languageCode == 'kh' ? 'km-KH' : 'en-US';
    flutterTts.setLanguage(ttsLanguage);

    String nameKey = widget.disease.name;
    String descKey = "${widget.disease.name.replaceAll(' ', '')}Description";
    String symptomsKey = "${widget.disease.name.replaceAll(' ', '')}Symptoms";
    String managementKey = "${widget.disease.name.replaceAll(' ', '')}Management";
    String translatedName = languageProvider.translate(nameKey);
    String translatedDesc = languageProvider.translate(descKey);
    String translatedSymptoms = languageProvider.translate(symptomsKey);
    String translatedManagement = languageProvider.translate(managementKey);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          translatedName,
          style: RiceTextStyles.body.copyWith(color: RiceColors.neutralDark),
        ),
        backgroundColor: RiceColors.backgroundAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: RiceColors.neutralDark),
      ),
      body: DefaultTabController(
        length: 2,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(RiceSpacings.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(RiceSpacings.radiusLarge),
                  child: Image.asset(
                    widget.imageUrl ?? 'assets/images/disease_thumbnail.jpg',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: RiceSpacings.s),
                Text(
                  translatedName,
                  style: RiceTextStyles.heading.copyWith(
                    color: RiceColors.neutralDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: RiceSpacings.s),
                // Text(
                //   // translatedDesc == descKey ? widget.disease.description : translatedDesc,
                //   style: RiceTextStyles.body.copyWith(color: RiceColors.neutral),
                // ),
                SizedBox(height: RiceSpacings.s),
                if (widget.disease.affectedPart != null)
                  Row(
                    children: [
                      Text(
                        languageProvider.translate('Affected Part: '),
                        style: RiceTextStyles.body.copyWith(
                          color: RiceColors.neutral,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        languageProvider.translate(widget.disease.affectedPart!.name),
                        style: RiceTextStyles.body.copyWith(color: RiceColors.neutral),
                      ),
                    ],
                  ),
                SizedBox(height: RiceSpacings.m),
                TabBar(
                  labelStyle: RiceTextStyles.subheadline.copyWith(
                    color: RiceColors.neutralDark,
                    fontWeight: FontWeight.bold,
                    fontSize: RiceTextStyles.subheadline.fontSize! - 2,
                  ),
                  unselectedLabelStyle: RiceTextStyles.subheadline.copyWith(
                    color: RiceColors.neutral,
                  ),
                  labelColor: RiceColors.neutralDark,
                  unselectedLabelColor: RiceColors.neutral,
                  indicatorColor: RiceColors.neutralDark,
                  tabs: [
                    Tab(text: languageProvider.translate('Symptoms')),
                    Tab(text: languageProvider.translate('Manage')),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: RiceSpacings.s),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  languageProvider.translate('Symptoms'),
                                  style: RiceTextStyles.subheadline.copyWith(
                                    color: RiceColors.neutralDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.volume_up),
                                  onPressed: () async {
                                    await flutterTts.speak(translatedSymptoms);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: RiceSpacings.s),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  translatedSymptoms == symptomsKey ? widget.disease.symptoms : translatedSymptoms,
                                  style: RiceTextStyles.body.copyWith(
                                    color: RiceColors.grey,
                                    fontSize: RiceTextStyles.body.fontSize! - 4,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: RiceSpacings.s),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  languageProvider.translate('Management'),
                                  style: RiceTextStyles.subheadline.copyWith(
                                    color: RiceColors.neutralDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.volume_up),
                                  onPressed: () async {
                                    await flutterTts.speak(translatedManagement);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: RiceSpacings.s),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  translatedManagement == managementKey ? widget.disease.management : translatedManagement,
                                  style: RiceTextStyles.body.copyWith(
                                    color: RiceColors.grey,
                                    fontSize: RiceTextStyles.body.fontSize! - 4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}