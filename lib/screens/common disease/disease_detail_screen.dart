import 'package:audioplayers/audioplayers.dart';
import 'package:capstone_dr_rice/models/disease.dart';
import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiseaseDetailScreen extends StatefulWidget {
  final Disease disease;
  final String? imageUrl;

  const DiseaseDetailScreen({super.key, required this.disease, this.imageUrl});

  @override
  _DiseaseDetailScreenState createState() => _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
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
    String descKey = "${widget.disease.name.replaceAll(' ', '')}Description";
    String symptomsKey = "${widget.disease.name.replaceAll(' ', '')}Symptoms";
    String managementKey = "${widget.disease.name.replaceAll(' ', '')}Management";
    String translatedName = languageProvider.translate(nameKey);
    String translatedDesc = languageProvider.translate(descKey);
    String translatedSymptoms = languageProvider.translate(symptomsKey);
    String translatedManagement = languageProvider.translate(managementKey);

    String languageCode = languageProvider.languageCode; // 'en' or 'kh'
    String symptomsAudioPath = _getAudioPath(languageCode, 'Symptoms');
    String managementAudioPath = _getAudioPath(languageCode, 'Management');

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
                                  icon: Icon(_isSymptomsPlaying ? Icons.stop : Icons.volume_up),
                                  onPressed: () => _toggleAudio(
                                    symptomsAudioPath,
                                    _isSymptomsPlaying,
                                    (value) => setState(() => _isSymptomsPlaying = value),
                                  ),
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
                                  icon: Icon(_isManagementPlaying ? Icons.stop : Icons.volume_up),
                                  onPressed: () => _toggleAudio(
                                    managementAudioPath,
                                    _isManagementPlaying,
                                    (value) => setState(() => _isManagementPlaying = value),
                                  ),
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