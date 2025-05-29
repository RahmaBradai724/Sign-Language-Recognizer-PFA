import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:signrecognizer/pages/welcome_page.dart';
import 'firebase_options.dart';
import 'package:camera/camera.dart';
import 'providers/locale_provider.dart';
import 'package:signrecognizer/l10n/app_localizations.dart';
import 'widgets/language_switcher.dart'; // Import the LanguageSwitcher

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Get available cameras
  cameras = await availableCameras();

  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: SignRecognizerApp(),
    ),
  );
}

class SignRecognizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          title: 'Reconnaissance de Signes',
          debugShowCheckedModeBanner: false,
          // Add AppBar with LanguageSwitcher
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple.withOpacity(0.8),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LanguageSwitcher(textColor: Colors.white),
                ),
              ],
            ),
            body: WelcomePage(cameras: cameras),
          ),
          // Localization settings
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fr'), // French
            Locale('ar'), // Arabic
          ],
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: Colors.grey[100],
          ),
        );
      },
    );
  }
}