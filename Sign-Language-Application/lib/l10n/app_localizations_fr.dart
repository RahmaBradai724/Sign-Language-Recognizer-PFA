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
  String get signRecognition => 'Reconnaissance des Signes';

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

  @override
  String get instructions => 'Instructions';

  @override
  String get bestRecognition => 'Pour une meilleure reconnaissance :';

  @override
  String get recordVideoLength => 'Enregistrez des vidéos de 3 à 5 secondes';

  @override
  String get keepHandsVisible => 'Gardez vos mains bien visibles';

  @override
  String get uniformLighting => 'Utilisez un éclairage uniforme et suffisant';

  @override
  String get avoidSuddenMovements => 'Évitez les mouvements brusques';

  @override
  String get centerSign => 'Centrez le signe à l\'écran';

  @override
  String get modelAnalysisInfo =>
      'Le modèle analyse 16 images de votre vidéo pour comprendre le mouvement du signe.';

  @override
  String get understood => 'Compris';

  @override
  String get stop => 'Arrêter';

  @override
  String get record => 'Enregistrer';

  @override
  String get select => 'Sélectionner';

  @override
  String get analyze => 'Analyser';

  @override
  String get recordOrSelectVideo =>
      'Enregistrez une vidéo de 3 à 5 secondes ou sélectionnez un fichier vidéo';

  @override
  String get recognizedSign => 'Signe reconnu (séquence)';

  @override
  String get confidence => 'Confiance';

  @override
  String get frames => 'Images';

  @override
  String get otherPossibilities => 'Autres possibilités';

  @override
  String get inferenceTime => 'Temps d\'inférence';

  @override
  String get sequence => 'Séquence';

  @override
  String get loadingModelOrAnalyzing =>
      'Chargement du modèle ou analyse en cours...';

  @override
  String get modelLoadError => 'Erreur de chargement du modèle';

  @override
  String get cameraError => 'Échec de l\'initialisation de la caméra';

  @override
  String get recordingError => 'Erreur au démarrage de l\'enregistrement';

  @override
  String get recordingStopError => 'Erreur à l\'arrêt de l\'enregistrement';

  @override
  String get filePickError => 'Erreur lors de la sélection du fichier';

  @override
  String get videoLoadError => 'Erreur lors du chargement de la vidéo';

  @override
  String get noVideoSelected => 'Aucune vidéo sélectionnée';

  @override
  String get analysisError => 'Échec de l\'analyse de la vidéo';

  @override
  String get retry => 'Réessayer';
}
