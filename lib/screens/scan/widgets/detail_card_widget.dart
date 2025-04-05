import 'package:audioplayers/audioplayers.dart';
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:capstone_dr_rice/models/disease.dart';
import 'package:provider/provider.dart';

class DetailCardWidget extends StatefulWidget {
  const DetailCardWidget({
    super.key,
    required this.tabController,
    required this.disease,
  });

  final TabController tabController;
  final Disease disease;

  @override
  State<DetailCardWidget> createState() => _DetailCardWidgetState();
}

class _DetailCardWidgetState extends State<DetailCardWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSymptomsPlaying = false;
  bool _isManagementPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio(String audioPath, bool isPlaying, Function(bool) setPlaying) async {
    try {
      if (isPlaying) {
        await _audioPlayer.stop();
        await _audioPlayer.seek(Duration.zero); // Reset to start
        setPlaying(false);
        print('Stopped audio: $audioPath');
      } else {
        await _audioPlayer.stop(); // Stop any other playing audio
        await _audioPlayer.play(AssetSource(audioPath));
        setPlaying(true);
        _audioPlayer.onPlayerComplete.listen((event) {
          if (mounted) {
            setState(() => setPlaying(false));
          }
        });
        print('Playing audio: $audioPath');
      }
    } catch (e) {
      print('Error toggling audio: $e');
    }
  }

  String _getAudioPath(String languageCode, String key) {
    final diseaseKey = widget.disease.name.replaceAll(' ', '');
    return 'audio/$languageCode/${diseaseKey}$key.mp3';
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    String nameKey = widget.disease.name;
    String symptomsKey = "${widget.disease.name.replaceAll(' ', '')}Symptoms";
    String managementKey = "${widget.disease.name.replaceAll(' ', '')}Management";
    String translatedName = languageProvider.translate(nameKey);
    String translatedSymptoms = languageProvider.translate(symptomsKey);
    String translatedManagement = languageProvider.translate(managementKey);

    String languageCode = languageProvider.languageCode; // 'en' or 'kh'
    String symptomsAudioPath = _getAudioPath(languageCode, 'Symptoms');
    String managementAudioPath = _getAudioPath(languageCode, 'Management');

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
                controller: widget.tabController,
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
                  controller: widget.tabController,
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
                              icon: Icon(_isSymptomsPlaying ? Icons.stop : Icons.volume_up),
                              onPressed: () => _toggleAudio(
                                symptomsAudioPath,
                                _isSymptomsPlaying,
                                (value) => setState(() => _isSymptomsPlaying = value),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              translatedSymptoms == symptomsKey ? widget.disease.symptoms : translatedSymptoms,
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
                              icon: Icon(_isManagementPlaying ? Icons.stop : Icons.volume_up),
                              onPressed: () => _toggleAudio(
                                managementAudioPath,
                                _isManagementPlaying,
                                (value) => setState(() => _isManagementPlaying = value),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              translatedManagement == managementKey ? widget.disease.management : translatedManagement,
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

