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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  /// **'Reconnaissance de Signes'**
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
