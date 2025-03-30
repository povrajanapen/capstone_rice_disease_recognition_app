import 'package:capstone_dr_rice/firebase_options.dart';
import 'package:capstone_dr_rice/provider/diseases_provider.dart';
import 'package:capstone_dr_rice/repository/disease/disease_repository_impl.dart';
import 'package:capstone_dr_rice/widgets/navigation/bottom_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'provider/saved_diagnosis_provider.dart';
import 'theme/theme.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
      //ChangeNotifierProvider(create: (context) => DiagnosisProvider()),
      ChangeNotifierProvider(create: (_) => DiseaseProvider(DiseaseRepositoryImpl())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: riceTheme,
      home: Scaffold(body: BottomNavBar()),
    );
  }
}
