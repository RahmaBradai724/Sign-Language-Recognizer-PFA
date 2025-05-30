/*import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';
class VideoSignLanguageRecognizer {
  static const String MODEL_PATH =
      'assets/models/tunisian_sign_sequence_model.tflite';
  static const String LABELS_PATH = 'assets/labels/sequence_labels.json';
  Interpreter? _interpreter;
  List<String>? _labels;
  final VideoFrameExtractor _frameExtractor = VideoFrameExtractor();
// Dimensions du modèle séquence
  static const int SEQUENCE_LENGTH = 16;
  static const int FRAME_SIZE = 112;
  static const int NUM_CHANNELS = 3;
  bool get isModelLoaded => _interpreter != null && _labels != null;
  /// Initialiser le modèle
  Future<bool> loadModel() async {
    try {
// Options pour supporter les opérations LSTM
      final options = InterpreterOptions();
      options.useNnapi = false; // Désactiver NNAPI pour LSTM
      _interpreter = await Interpreter.fromAsset(MODEL_PATH, options: options);
// Charger les labels
      final labelsData = await rootBundle.loadString(LABELS_PATH);

      final labelsJson = json.decode(labelsData);
      _labels = List<String>.from(labelsJson['labels']);
      print('� Modèle séquence chargé: ${_labels!.length} classes');
      print('� Input shape: ${_interpreter!.getInputTensor(0).shape}');
      print('� Output shape: ${_interpreter!.getOutputTensor(0).shape}');
      return true;
    } catch (e) {
      print('� Erreur chargement modèle: $e');
      return false;
    }
  }
  /// Reconnaissance d'une vidéo
  Future<VideoRecognitionResult?> recognizeVideo(String videoPath) async {
    if (!isModelLoaded) {
      print('� Modèle non chargé');
      return null;
    }
    List<String> framePaths = [];
    try {
// 1. Extraire les frames de la vidéo
      print('� Extraction des frames...');
      framePaths = await _frameExtractor.extractFrames(videoPath);
      if (framePaths.length != SEQUENCE_LENGTH) {
        throw Exception('Nombre de frames incorrect: ${framePaths.length}');
      }
// 2. Préprocesser la séquence
      print ' Preprocessing de la séquence...');
    final input = await _preprocessVideoSequence(framePaths);
// 3. Préparer la sortie
    final output = List.filled(_labels!.length, 0.0).reshape([1,
    _labels!.length]);
// 4. Inférence
    print('� Inférence...');
    final stopwatch = Stopwatch()..start();
    _interpreter!.run(input, output);
    stopwatch.stop();
// 5. Post-traitement
    final result = _postprocessOutput(
    output[0],
    stopwatch.elapsedMilliseconds,
    framePaths.length
    );
    return result;
    } catch (e) {
    print('� Erreur reconnaissance vidéo: $e');
    return null;
    } finally {
// Nettoyer les frames temporaires
    if (framePaths.isNotEmpty) {
    await _frameExtractor.cleanupFrames(framePaths);
    }
    }
  }
  /// Préprocessing d'une séquence de frames
  Future<List<List<List<List<List<double>>>>>>
  _preprocessVideoSequence(List<String> framePaths) async {
// Format: [batch_size, sequence_length, height, width, channels]

    final sequence = <List<List<List<double>>>>[];
    for (int i = 0; i < SEQUENCE_LENGTH; i++) {
      final framePath = i < framePaths.length ? framePaths[i] : framePaths.last;
// Charger et préprocesser la frame
      final frameData = await _preprocessFrame(framePath);
      sequence.add(frameData);
    }
    return [sequence]; // Batch size = 1
  }
  /// Préprocessing d'une frame individuelle
  Future<List<List<List<double>>>> _preprocessFrame(String framePath) async {
    final imageFile = File(framePath);
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Impossible de décoder la frame: $framePath');
    }
// Redimensionner si nécessaire
    if (image.width != FRAME_SIZE || image.height != FRAME_SIZE) {
      image = img.copyResize(
          image,
          width: FRAME_SIZE,
          height: FRAME_SIZE,
          interpolation: img.Interpolation.linear
      );
    }
// Convertir en tensor [height, width, channels]
    final frameData = List.generate(
      FRAME_SIZE,
          (y) => List.generate(
        FRAME_SIZE,
            (x) => List.generate(NUM_CHANNELS, (c) {
          final pixel = image.getPixel(x, y);
          switch (c) {
            case 0: return pixel.r / 255.0;
            case 1: return pixel.g / 255.0;
            case 2: return pixel.b / 255.0;
            default: return 0.0;
          }
        }),
      ),
    );
    return frameData;
  }
  /// Post-traitement des résultats
  VideoRecognitionResult _postprocessOutput(
      List<double> output,
      int inferenceTime,
      int framesProcessed
      ) {
// Trouver la classe avec la plus haute probabilité
    double maxScore = 0.0;
    int maxIndex = 0;
    for (int i = 0; i < output.length; i++) {
      if (output[i] > maxScore) {
        maxScore = output[i];
        maxIndex = i;
      }
    }
// Créer la liste des prédictions

    List<VideoPrediction> predictions = [];
    for (int i = 0; i < output.length; i++) {
      predictions.add(VideoPrediction(
        label: _labels![i],
        confidence: output[i],
      ));
    }
// Trier par confiance décroissante
    predictions.sort((a, b) => b.confidence.compareTo(a.confidence));
    return VideoRecognitionResult(
      topPrediction: predictions.first,
      allPredictions: predictions.take(5).toList(),
      inferenceTime: inferenceTime,
      framesProcessed: framesProcessed,
      sequenceLength: SEQUENCE_LENGTH,
    );
  }
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _labels = null;
  }
}
// Classes de données pour vidéos
class VideoRecognitionResult {
  final VideoPrediction topPrediction;
  final List<VideoPrediction> allPredictions;
  final int inferenceTime;
  final int framesProcessed;
  final int sequenceLength;
  VideoRecognitionResult({
    required this.topPrediction,
    required this.allPredictions,
    required this.inferenceTime,
    required this.framesProcessed,
    required this.sequenceLength,
  });
}
class VideoPrediction {
  final String label;
  final double confidence;
  VideoPrediction({
    required this.label,
    required this.confidence,
  });
  @override
  String toString() => '$label (${(confidence * 100).toStringAsFixed(1)}%)';
} */