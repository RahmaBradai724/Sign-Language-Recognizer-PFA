import 'package:flutter/material.dart';
import 'package:signrecognizer/l10n/app_localizations.dart';
import 'package:signrecognizer/pages/login_page.dart';
import 'package:signrecognizer/pages/register_page.dart';
import 'package:camera/camera.dart';
import 'package:signrecognizer/widgets/welcome_button.dart';

class WelcomePage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const WelcomePage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            'assets/bg2.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcome,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      AppLocalizations.of(context)!.appDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 60,
                      child: WelcomeButton(
                        text: AppLocalizations.of(context)!.login,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(cameras: cameras),
                            ),
                          );
                        },
                        backgroundColor: const Color(0xFFB39DDB),
                        textColor: Colors.deepPurple[900]!,
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 140,
                      height: 60,
                      child: WelcomeButton(
                        text: AppLocalizations.of(context)!.register,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(cameras: cameras),
                            ),
                          );
                        },
                        backgroundColor: const Color(0xFFE1BEE7),
                        textColor: Colors.deepPurple[900]!,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
