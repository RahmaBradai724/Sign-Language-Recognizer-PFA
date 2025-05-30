import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:signrecognizer/l10n/app_localizations.dart';
import 'package:signrecognizer/recognizer/video_sign_language_recognizer.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class SignRecognitionScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SignRecognitionScreen({super.key, required this.cameras});

  @override
  State<SignRecognitionScreen> createState() => _SignRecognitionScreenState();
}

class _SignRecognitionScreenState extends State<SignRecognitionScreen> {
  final VideoSignLanguageRecognizer _recognizer = VideoSignLanguageRecognizer();
  CameraController? _cameraController;
  VideoPlayerController? _videoController;
  Future<void>? _initializeControllerFuture;
  VideoRecognitionResult? _lastResult;
  bool _isLoading = false;
  bool _isModelLoaded = false;
  bool _isRecording = false;
  String? _currentVideoPath;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    setState(() => _isLoading = true);
    final success = await _loadModel();
    if (!success) {
      _showSnackBar(AppLocalizations.of(context).modelLoadError ?? 'Erreur de chargement du modèle', isError: true);
    }
    await _initializeCamera();
    setState(() => _isLoading = false);
  }

  Future<bool> _loadModel() async {
    final success = await _recognizer.loadModel();
    setState(() => _isModelLoaded = success);
    return success;
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isEmpty) return;

    try {
      final camera = widget.cameras[_selectedCameraIndex];
      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      _initializeControllerFuture = _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print('Erreur caméra: $e');
      _showSnackBar(AppLocalizations.of(context).cameraError ?? 'Erreur d\'initialisation de la caméra', isError: true);
    }
  }

  void switchCamera() async {
    if (widget.cameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
    await _cameraController?.dispose();
    await _initializeCamera();
  }

  Future<void> _startRecording() async {
    if (_cameraController?.value.isInitialized != true) return;

    try {
      setState(() => _isRecording = true);
      await _cameraController!.startVideoRecording();

      // Stop recording after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (_isRecording) {
          _stopRecording();
        }
      });
    } catch (e) {
      print('Erreur démarrage enregistrement: $e');
      setState(() => _isRecording = false);
      _showSnackBar(AppLocalizations.of(context).recordingError ?? 'Erreur lors de l\'enregistrement', isError: true);
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _currentVideoPath = videoFile.path;
      });
      await _loadVideo(videoFile.path);
    } catch (e) {
      print('Erreur arrêt enregistrement: $e');
      setState(() => _isRecording = false);
      _showSnackBar(AppLocalizations.of(context).recordingStopError ?? 'Erreur lors de l\'arrêt de l\'enregistrement', isError: true);
    }
  }

  Future<void> _pickVideoFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final filePath = result.files.first.path!;
        setState(() => _currentVideoPath = filePath);
        await _loadVideo(filePath);
      }
    } catch (e) {
      print('Erreur sélection fichier: $e');
      _showSnackBar(AppLocalizations.of(context).filePickError ?? 'Erreur lors de la sélection du fichier', isError: true);
    }
  }

  Future<void> _loadVideo(String videoPath) async {
    try {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(File(videoPath));
      await _videoController!.initialize();
      setState(() {});
    } catch (e) {
      print('Erreur chargement vidéo: $e');
      _showSnackBar(AppLocalizations.of(context).videoLoadError ?? 'Erreur lors du chargement de la vidéo', isError: true);
    }
  }

  Future<void> _playVideo() async {
    if (_videoController != null) {
      if (_videoController!.value.isPlaying) {
        await _videoController!.pause();
      } else {
        await _videoController!.play();
      }
      setState(() {});
    }
  }

  Future<void> _analyzeVideo() async {
    if (_currentVideoPath == null) {
      _showSnackBar(AppLocalizations.of(context).noVideoSelected ?? 'Aucune vidéo sélectionnée', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _recognizer.recognizeVideo(_currentVideoPath!);
      setState(() {
        _lastResult = result;
      });

      if (result == null) {
        _showSnackBar(AppLocalizations.of(context).analysisError ?? 'Impossible d\'analyser la vidéo', isError: true);
      }
    } catch (e) {
      _showSnackBar('${AppLocalizations.of(context).analysisError ?? 'Erreur analyse'}: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).instructions ?? 'Instructions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).bestRecognition ?? 'For Best Recognition:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('• ${AppLocalizations.of(context).recordVideoLength ?? 'Record videos of 3-5 seconds'}'),
            Text('• ${AppLocalizations.of(context).keepHandsVisible ?? 'Keep your hands clearly visible'}'),
            Text('• ${AppLocalizations.of(context).uniformLighting ?? 'Use uniform and sufficient lighting'}'),
            Text('• ${AppLocalizations.of(context).avoidSuddenMovements ?? 'Avoid sudden movements'}'),
            Text('• ${AppLocalizations.of(context).centerSign ?? 'Center the sign on the screen'}'),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context).modelAnalysisInfo ??
                'The model analyzes 16 frames of your video to understand the sign movement.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).understood ?? 'Understood'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _videoController?.dispose();
    _recognizer.dispose();
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
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Text(
                          AppLocalizations.of(context).signRecognition ?? 'Sign Recognition',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.info_outline, color: Colors.white),
                            onPressed: _showInstructions,
                          ),
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
                      child: _buildVideoArea(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!_isLoading) _buildRecordingControls(),
                  const SizedBox(height: 24),
                  if (!_isModelLoaded)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context).modelLoadError ?? 'Erreur de chargement du modèle',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _initializeApp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(AppLocalizations.of(context).retry ?? 'Réessayer'),
                          ),
                        ],
                      ),
                    )
                  else
                    _buildResults(),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)?.loadingModelOrAnalyzing ?? 'Loading model or analyzing...',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _currentVideoPath != null
          ? FloatingActionButton(
        heroTag: "play",
        onPressed: _playVideo,
        backgroundColor: Colors.blue,
        child: Icon(
          _videoController?.value.isPlaying == true ? Icons.pause : Icons.play_arrow,
        ),
      )
          : null,
    );
  }

  Widget _buildVideoArea() {
    if (_currentVideoPath != null && _videoController != null) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else if (_cameraController?.value.isInitialized == true) {
      return FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (widget.cameras.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)?.noCameraDetected ?? 'No Camera Detected',
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
      );
    } else {
      return Center(
        child: ElevatedButton.icon(
          onPressed: _initializeCamera,
          icon: const Icon(Icons.camera),
          label: Text(AppLocalizations.of(context)?.activateCamera ?? 'Activate Camera'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple,
          ),
        ),
      );
    }
  }

  Widget _buildRecordingControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: _isRecording ? _stopRecording : _startRecording,
            icon: Icon(_isRecording ? Icons.stop : Icons.videocam),
            label: Text(_isRecording
                ? AppLocalizations.of(context)?.stop ?? 'Stop'
                : AppLocalizations.of(context)?.record ?? 'Record'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isRecording ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _pickVideoFile,
            icon: const Icon(Icons.video_library),
            label: Text(AppLocalizations.of(context)?.select ?? 'Select'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _currentVideoPath != null ? _analyzeVideo : null,
            icon: const Icon(Icons.analytics),
            label: Text(AppLocalizations.of(context)?.analyze ?? 'Analyze'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_lastResult == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.video_camera_back, size: 48, color: Colors.deepPurple),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.recordOrSelectVideo ??
                  'Record a 3-5 second video or select a video file',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
            ),
          ],
        ),
      );
    }

    final result = _lastResult!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.recognizedSign ?? 'Recognized Sign (Sequence)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.deepPurple.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  result.topPrediction.label,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade900,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: result.topPrediction.confidence,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    result.topPrediction.confidence > 0.7
                        ? Colors.green
                        : result.topPrediction.confidence > 0.5
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${AppLocalizations.of(context)?.confidence ?? 'Confidence'}: ${(result.topPrediction.confidence * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const Spacer(),
                    const Icon(Icons.video_file, size: 16, color: Colors.grey),
                    Text(
                      ' ${result.framesProcessed} ${AppLocalizations.of(context)?.frames ?? 'Frames'}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)?.otherPossibilities ?? 'Other Possibilities',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LimitedBox(
            maxHeight: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: result.allPredictions.length > 3 ? 3 : result.allPredictions.length - 1,
              itemBuilder: (context, index) {
                final prediction = result.allPredictions[index + 1];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      '${(prediction.confidence * 100).round()}%',
                      style: TextStyle(fontSize: 10, color: Colors.blue[800]),
                    ),
                  ),
                  title: Text(prediction.label),
                  trailing: Text(
                    '${(prediction.confidence * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: prediction.confidence > 0.3 ? Colors.orange : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  dense: true,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)?.inferenceTime ?? 'Inference Time'}: ${result.inferenceTime}ms',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${AppLocalizations.of(context)?.sequence ?? 'Sequence'}: ${result.sequenceLength} ${AppLocalizations.of(context)?.frames ?? 'Frames'}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}