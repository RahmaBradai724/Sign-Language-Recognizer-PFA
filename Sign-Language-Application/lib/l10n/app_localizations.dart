import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('fr')
  ];

  /// The title of the application
  ///
  /// In fr, this message translates to:
  /// **'Reconnaissance de Signes'**
  String get appTitle;

  /// Welcome text on welcome page
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get welcome;

  /// App description on welcome page
  ///
  /// In fr, this message translates to:
  /// **'Cette application traduit la langue des signes en texte et voix'**
  String get appDescription;

  /// Login button text
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get login;

  /// Register button text
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get register;

  /// Email field label
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// Full name field label
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get name;

  /// Remember me checkbox text
  ///
  /// In fr, this message translates to:
  /// **'Se souvenir de moi'**
  String get rememberMe;

  /// Forgot password link text
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié?'**
  String get forgotPassword;

  /// Login with text
  ///
  /// In fr, this message translates to:
  /// **'Ou connectez-vous avec'**
  String get loginWith;

  /// No account text
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte?'**
  String get noAccount;

  /// Have account text
  ///
  /// In fr, this message translates to:
  /// **'Vous avez déjà un compte?'**
  String get haveAccount;

  /// Create account button text
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// Register with text
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire avec'**
  String get registerWith;

  /// Accept terms text
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte le traitement des données personnelles'**
  String get acceptTerms;

  /// Personal data text
  ///
  /// In fr, this message translates to:
  /// **'données personnelles'**
  String get personalData;

  /// I accept text
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte le traitement des'**
  String get iAccept;

  /// Please accept terms error message
  ///
  /// In fr, this message translates to:
  /// **'Veuillez accepter le traitement des données personnelles'**
  String get pleaseAcceptTerms;

  /// Please enter email validation message
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre email'**
  String get pleaseEnterEmail;

  /// Please enter password validation message
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre mot de passe'**
  String get pleaseEnterPassword;

  /// Please enter name validation message
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre nom complet'**
  String get pleaseEnterName;

  /// Email field example
  ///
  /// In fr, this message translates to:
  /// **'Ex : marie.dupont@example.com'**
  String get emailExample;

  /// Password field example
  ///
  /// In fr, this message translates to:
  /// **'Ex : ••••••••'**
  String get passwordExample;

  /// Name field example
  ///
  /// In fr, this message translates to:
  /// **'Ex : Marie Dupont'**
  String get nameExample;

  /// Sign recognition title
  ///
  /// In fr, this message translates to:
  /// **'Reconnaissance des Signes'**
  String get signRecognition;

  /// Activate camera button text
  ///
  /// In fr, this message translates to:
  /// **'Activer la caméra'**
  String get activateCamera;

  /// No camera detected text
  ///
  /// In fr, this message translates to:
  /// **'Aucun appareil photo détecté'**
  String get noCameraDetected;

  /// Read text button
  ///
  /// In fr, this message translates to:
  /// **'Lire le texte'**
  String get readText;

  /// Change language button text
  ///
  /// In fr, this message translates to:
  /// **'Changer de langue'**
  String get changeLanguage;

  /// Arabic language option
  ///
  /// In fr, this message translates to:
  /// **'Arabe'**
  String get arabic;

  /// French language option
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// Instructions for sign recognition
  ///
  /// In fr, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// Best recognition tips title
  ///
  /// In fr, this message translates to:
  /// **'Pour une meilleure reconnaissance :'**
  String get bestRecognition;

  /// Record video length instruction
  ///
  /// In fr, this message translates to:
  /// **'Enregistrez des vidéos de 3 à 5 secondes'**
  String get recordVideoLength;

  /// Keep hands visible instruction
  ///
  /// In fr, this message translates to:
  /// **'Gardez vos mains bien visibles'**
  String get keepHandsVisible;

  /// Uniform lighting instruction
  ///
  /// In fr, this message translates to:
  /// **'Utilisez un éclairage uniforme et suffisant'**
  String get uniformLighting;

  /// Avoid sudden movements instruction
  ///
  /// In fr, this message translates to:
  /// **'Évitez les mouvements brusques'**
  String get avoidSuddenMovements;

  /// Center sign instruction
  ///
  /// In fr, this message translates to:
  /// **'Centrez le signe à l\'écran'**
  String get centerSign;

  /// Model analysis information
  ///
  /// In fr, this message translates to:
  /// **'Le modèle analyse 16 images de votre vidéo pour comprendre le mouvement du signe.'**
  String get modelAnalysisInfo;

  /// Understood button text
  ///
  /// In fr, this message translates to:
  /// **'Compris'**
  String get understood;

  /// Stop recording button text
  ///
  /// In fr, this message translates to:
  /// **'Arrêter'**
  String get stop;

  /// Record button text
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get record;

  /// Select video button text
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner'**
  String get select;

  /// Analyze video button text
  ///
  /// In fr, this message translates to:
  /// **'Analyser'**
  String get analyze;

  /// Record or select video instruction
  ///
  /// In fr, this message translates to:
  /// **'Enregistrez une vidéo de 3 à 5 secondes ou sélectionnez un fichier vidéo'**
  String get recordOrSelectVideo;

  /// Recognized sign label
  ///
  /// In fr, this message translates to:
  /// **'Signe reconnu (séquence)'**
  String get recognizedSign;

  /// Confidence label
  ///
  /// In fr, this message translates to:
  /// **'Confiance'**
  String get confidence;

  /// Frames label
  ///
  /// In fr, this message translates to:
  /// **'Images'**
  String get frames;

  /// Other possibilities label
  ///
  /// In fr, this message translates to:
  /// **'Autres possibilités'**
  String get otherPossibilities;

  /// Inference time label
  ///
  /// In fr, this message translates to:
  /// **'Temps d\'inférence'**
  String get inferenceTime;

  /// Sequence label
  ///
  /// In fr, this message translates to:
  /// **'Séquence'**
  String get sequence;

  /// Loading model or analyzing text
  ///
  /// In fr, this message translates to:
  /// **'Chargement du modèle ou analyse en cours...'**
  String get loadingModelOrAnalyzing;

  /// Error message for model loading failure
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement du modèle'**
  String get modelLoadError;

  /// Error message for camera initialization failure
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'initialisation de la caméra'**
  String get cameraError;

  /// Error message for starting recording failure
  ///
  /// In fr, this message translates to:
  /// **'Erreur au démarrage de l\'enregistrement'**
  String get recordingError;

  /// Error message for stopping recording failure
  ///
  /// In fr, this message translates to:
  /// **'Erreur à l\'arrêt de l\'enregistrement'**
  String get recordingStopError;

  /// Error message for file selection failure
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la sélection du fichier'**
  String get filePickError;

  /// Error message for video loading failure
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du chargement de la vidéo'**
  String get videoLoadError;

  /// Error message for no video selected
  ///
  /// In fr, this message translates to:
  /// **'Aucune vidéo sélectionnée'**
  String get noVideoSelected;

  /// Error message for video analysis failure
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'analyse de la vidéo'**
  String get analysisError;

  /// Retry button text
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
