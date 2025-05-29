import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:signrecognizer/l10n/app_localizations.dart';

class StaticHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const StaticHomePage({super.key, required this.cameras});

  @override
  State<StaticHomePage> createState() => _StaticHomePageState();
}

class _StaticHomePageState extends State<StaticHomePage> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  final String mockTranslatedText = "Bonjour, comment ça va ?";
  bool isCameraInitialized = false;
  int _selectedCameraIndex = 0;

  Future<void> initializeCamera() async {
    if (widget.cameras.isEmpty) return;

    final camera = widget.cameras[_selectedCameraIndex];

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _initializeControllerFuture = _cameraController!.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  void switchCamera() async {
    if (widget.cameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
    await _cameraController?.dispose();
    initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: Image.asset('assets/bg2.png', fit: BoxFit.cover),
          ),
          SizedBox(
            width: size.width,
            height: size.height,
            child: Container(color: Colors.deepPurple.withOpacity(0.4)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.signRecognition,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.switch_camera, color: Colors.white),
                            onPressed: switchCamera,
                          ),

                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: !isCameraInitialized
                          ? Center(
                        child: ElevatedButton.icon(
                          onPressed: initializeCamera,
                          icon: const Icon(Icons.camera),
                          label: Text(AppLocalizations.of(context)!.activateCamera),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple,
                          ),
                        ),
                      )
                          : FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (widget.cameras.isEmpty) {
                            return Center(
                              child: Text(
                                AppLocalizations.of(context)!.noCameraDetected,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            );
                          }
                          if (snapshot.connectionState == ConnectionState.done) {
                            return CameraPreview(_cameraController!);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.white70),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Text(
                      mockTranslatedText,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.volume_up),
                    label: Text(AppLocalizations.of(context)!.readText),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
