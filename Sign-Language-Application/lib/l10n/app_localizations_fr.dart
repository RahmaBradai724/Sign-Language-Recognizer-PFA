// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Reconnaissance de Signes';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get appDescription =>
      'Cette application traduit la langue des signes en texte et voix';

  @override
  String get login => 'Se connecter';

  @override
  String get register => 'S\'inscrire';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get name => 'Nom complet';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get loginWith => 'Ou connectez-vous avec';

  @override
  String get noAccount => 'Pas encore de compte?';

  @override
  String get haveAccount => 'Vous avez déjà un compte?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get registerWith => 'S\'inscrire avec';

  @override
  String get acceptTerms => 'J\'accepte le traitement des données personnelles';

  @override
  String get personalData => 'données personnelles';

  @override
  String get iAccept => 'J\'accepte le traitement des';

  @override
  String get pleaseAcceptTerms =>
      'Veuillez accepter le traitement des données personnelles';

  @override
  String get pleaseEnterEmail => 'Veuillez entrer votre email';

  @override
  String get pleaseEnterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String get pleaseEnterName => 'Veuillez entrer votre nom complet';

  @override
  String get emailExample => 'Ex : marie.dupont@example.com';

  @override
  String get passwordExample => 'Ex : ••••••••';

  @override
  String get nameExample => 'Ex : Marie Dupont';

  @override
  String get signRecognition => 'Reconnaissance de Signes';

  @override
  String get activateCamera => 'Activer la caméra';

  @override
  String get noCameraDetected => 'Aucun appareil photo détecté';

  @override
  String get readText => 'Lire le texte';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get arabic => 'Arabe';

  @override
  String get french => 'Français';
}
