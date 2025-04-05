// lib/data/dummy_data.dart

import '../screens/home/widgets/news_slider.dart';

// Dummy slider content
final List<SlideContent> sliderContent = [
  SlideContent(
    image: 'assets/images/SCAN.png',
    title: 'Tell me phone, what\'s destroying my crops?',
    subtitle: 'Scan your rice plants to detect diseases early',
  ),
  SlideContent(
    image: 'assets/images/disease_thumbnail.jpg',
    title: 'Protect your rice yield',
    subtitle: 'Get instant diagnosis and treatment recommendations',
  ),
  SlideContent(
    image: 'assets/images/e_rice.png',
    title: 'E-Rice Detector',
    subtitle: 'Rice Disease Detector Application Created by UMM Students',
  ),
];

// Feature buttons data with translation keys
final List<Map<String, String>> featureButtons = [
  {
    'titleKey': 'Common Disease', // Key for translation
    'icon': 'assets/icons/wheat_icon.png',
    'route': '/diseases',
  },
  {
    'titleKey': 'Rice Scan',
    'icon': 'assets/icons/scan_icon.png',
    'route': '/scan',
  },
  {
    'titleKey': 'Report Disease',
    'icon': 'assets/icons/report.png',
    'route': '/report',
  },
];