import '../screens/home/widgets/news_slider.dart';

// Dummy slider content with keys matching JSON
final List<SlideContent> sliderContent = [
  SlideContent(
    image: 'assets/images/SCAN.png',
    title: "crop_destruction_query",
    subtitle: "scan_prompt",
  ),
  SlideContent(
    image: 'assets/images/disease_thumbnail.jpg',
    title: "protect_yield",
    subtitle: "diagnosis_prompt",
  ),
  SlideContent(
    image: 'assets/images/FAO.png',
    title: "app_name",
    subtitle: "app_description",
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