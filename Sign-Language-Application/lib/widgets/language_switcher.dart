import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signrecognizer/providers/locale_provider.dart';
import 'package:signrecognizer/l10n/app_localizations.dart';

class LanguageSwitcher extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;

  const LanguageSwitcher({
    Key? key,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale.languageCode;
    final textDirection = currentLocale == 'ar' ? TextDirection.rtl : TextDirection.ltr;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: PopupMenuButton<String>(
        onSelected: (String languageCode) {
          if (languageCode == 'ar') {
            print('Switching to Arabic');
            localeProvider.switchToArabic(); // Switch to Arabic
          } else if (languageCode == 'fr') {
            print('Switching to French');
            localeProvider.setLocale(const Locale('fr')); // Switch to French
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'fr',
            child: Directionality(
              textDirection: textDirection,
              child: Row(
                children: [
                  const Text(
                    '🇫🇷',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.french,
                    style: TextStyle(
                      fontWeight: currentLocale == 'fr' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (currentLocale == 'fr')
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: const Icon(Icons.check, size: 16),
                    ),
                ],
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'ar',
            child: Directionality(
              textDirection: textDirection,
              child: Row(
                children: [
                  const Text(
                    '🇩🇿',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.arabic,
                    style: TextStyle(
                      fontWeight: currentLocale == 'ar' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (currentLocale == 'ar')
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: const Icon(Icons.check, size: 16),
                    ),
                ],
              ),
            ),
          ),
        ],
        child: Directionality(
          textDirection: textDirection,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.language, color: textColor),
              const SizedBox(width: 5),
              Text(
                currentLocale == 'fr' ? 'FR' : 'عر',
                style: TextStyle(color: textColor),
              ),
              Icon(Icons.arrow_drop_down, color: textColor),
            ],
          ),
        ),
      ),
    );
  }
}