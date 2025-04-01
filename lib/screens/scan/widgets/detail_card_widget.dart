// import 'package:capstone_dr_rice/provider/language_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:capstone_dr_rice/models/disease.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:provider/provider.dart';

// class DetailCardWidget extends StatelessWidget {
//   const DetailCardWidget({
//     super.key,
//     required TabController tabController,
//     required this.flutterTts,
//     required this.disease,
//   }) : _tabController = tabController;

//   final TabController _tabController;
//   final FlutterTts flutterTts;
//   final Disease disease;

//   @override
//   Widget build(BuildContext context) {
//     final languageProvider = Provider.of<LanguageProvider>(context);

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: Colors.grey.shade200, width: 1),
//       ),
//       child: ExpansionTile(
//         title: Text(
//           languageProvider.translate('Details'),
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: Text(
//                   languageProvider.translate(disease.name), // Translate disease name
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               TabBar(
//                 controller: _tabController,
//                 labelStyle: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//                 unselectedLabelStyle: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//                 labelColor: Colors.black87,
//                 unselectedLabelColor: Colors.grey,
//                 indicatorColor: Colors.black87,
//                 tabs: [
//                   Tab(text: languageProvider.translate('Symptoms')),
//                   Tab(text: languageProvider.translate('Management')),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.25,
//                 ),
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               languageProvider.translate('Symptoms'),
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.volume_up),
//                               onPressed: () async {
//                                 await flutterTts.speak(disease.symptoms);
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Expanded(
//                           child: SingleChildScrollView(
//                             child: Text(
//                               languageProvider.translate(disease.symptoms),
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey.shade700,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               languageProvider.translate('Management'),
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.volume_up),
//                               onPressed: () async {
//                                 await flutterTts.speak(disease.management);
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Expanded(
//                           child: SingleChildScrollView(
//                             child: Text(
//                               languageProvider.translate(disease.management),
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey.shade700,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:capstone_dr_rice/models/disease.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class DetailCardWidget extends StatelessWidget {
  const DetailCardWidget({
    super.key,
    required TabController tabController,
    required this.flutterTts,
    required this.disease,
  }) : _tabController = tabController;

  final TabController _tabController;
  final FlutterTts flutterTts;
  final Disease disease;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    // Set TTS language dynamically
    String ttsLanguage = languageProvider.languageCode == 'kh' ? 'km-KH' : 'en-US';
    flutterTts.setLanguage(ttsLanguage);

    // Translation keys
    String nameKey = disease.name;
    String symptomsKey = "${disease.name.replaceAll(' ', '')}Symptoms";
    String managementKey = "${disease.name.replaceAll(' ', '')}Management";
    String translatedName = languageProvider.translate(nameKey);
    String translatedSymptoms = languageProvider.translate(symptomsKey);
    String translatedManagement = languageProvider.translate(managementKey);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: ExpansionTile(
        title: Text(
          languageProvider.translate('Details'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  translatedName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                labelColor: Colors.black87,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black87,
                tabs: [
                  Tab(text: languageProvider.translate('Symptoms')),
                  Tab(text: languageProvider.translate('Management')),
                ],
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.25,
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              languageProvider.translate('Symptoms'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () async {
                                await flutterTts.speak(
                                  translatedSymptoms == symptomsKey ? disease.symptoms : translatedSymptoms,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              translatedSymptoms == symptomsKey ? disease.symptoms : translatedSymptoms,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              languageProvider.translate('Management'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () async {
                                await flutterTts.speak(
                                  translatedManagement == managementKey ? disease.management : translatedManagement,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              translatedManagement == managementKey ? disease.management : translatedManagement,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}