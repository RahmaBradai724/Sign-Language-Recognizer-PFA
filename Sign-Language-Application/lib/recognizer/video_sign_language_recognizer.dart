import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:signrecognizer/recognizer/video_frame_extractor.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class VideoSignLanguageRecognizer {
  static const String MODEL_PATH = 'assets/models/tunisian_sign_single_frame_model.tflite';
  static const String LABELS_PATH = 'assets/labels/dataset_structure.json';

  Interpreter? _interpreter;
  List<String>? _labels;
  final VideoFrameExtractor _frameExtractor = VideoFrameExtractor();

  bool get isModelLoaded => _interpreter != null && _labels != null;

  Future<bool> loadModel() async {
    try {
      print('📥 Chargement du modèle...');
      final options = InterpreterOptions();
      /* if (Platform.isAndroid) {
        options.addDelegate(XNNPackDelegate());
      } */
      _interpreter = await Interpreter.fromAsset(MODEL_PATH, options: options);
      print('📄 Modèle .tflite chargé avec succès');

      final labelsData = await rootBundle.loadString(LABELS_PATH);
      print('📋 Labels bruts: $labelsData');
      final labelsJson = json.decode(labelsData);

      // Extract labels from "combined_mapping" keys
      final combinedMapping = labelsJson['combined_mapping'] as Map<String, dynamic>;
      // Create a list of labels by sorting the keys by their indices
      _labels = List.filled(combinedMapping.length, '');
      combinedMapping.forEach((label, index) {
        _labels![index] = label; // e.g., "كلمات/يقرا" at index 230
      });

      print('✅ Modèle chargé: ${_labels!.length} classes');
      return true;
    } catch (e, stackTrace) {
      print('❌ Erreur chargement modèle: $e');
      print('StackTrace: $stackTrace');
      return false;
    }
  }

  Future<VideoRecognitionResult?> recognizeVideo(String videoPath) async {
    if (!isModelLoaded) {
      print('❌ Modèle non chargé');
      return null;
    }

    final totalStopwatch = Stopwatch()..start();
    FrameExtractionResult? extractionResult;

    try {
      print('🎬 Début reconnaissance vidéo: $videoPath');
      extractionResult = await _frameExtractor.extractFrames(videoPath);
      if (!extractionResult.success) {
        throw Exception('Échec extraction frames: ${extractionResult.error}');
      }

      print('📸 ${extractionResult.frameCount} frames extraites en ${extractionResult.extractionTimeMs}ms');

      final preprocessStopwatch = Stopwatch()..start();
      final framePredictions = <List<double>>[];

      // Process each frame individually
      for (final framePath in extractionResult.framePaths) {
        final frameData = await _preprocessFrame(framePath);
        // Allocate output tensor with shape [1, num_classes]
        final output = List.generate(1, (_) => List.filled(_labels!.length, 0.0));
        _interpreter!.run(frameData, output);
        framePredictions.add(output[0]);
      }

      preprocessStopwatch.stop();
      print('🔧 Preprocessing terminé en ${preprocessStopwatch.elapsedMilliseconds}ms');

      // Aggregate predictions (e.g., average them)
      final inferenceStopwatch = Stopwatch()..start();
      final aggregatedOutput = <double>[];
      for (int i = 0; i < _labels!.length; i++) {
        double sum = 0;
        for (final prediction in framePredictions) {
          sum += prediction[i];
        }
        aggregatedOutput.add(sum / framePredictions.length);
      }
      inferenceStopwatch.stop();
      print('🧠 Inférence terminée en ${inferenceStopwatch.elapsedMilliseconds}ms');

      final result = _createResult(
        aggregatedOutput,
        extractionResult,
        preprocessStopwatch.elapsedMilliseconds,
        inferenceStopwatch.elapsedMilliseconds,
        totalStopwatch.elapsedMilliseconds,
      );

      return result;
    } catch (e) {
      print('❌ Erreur reconnaissance: $e');
      return null;
    } finally {
      if (extractionResult?.framePaths.isNotEmpty == true) {
        await _frameExtractor.cleanupFrames(extractionResult!.framePaths);
      }
      totalStopwatch.stop();
    }
  }

  Future<List<List<List<List<double>>>>> _preprocessFrame(String framePath) async {
    final imageFile = File(framePath);
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Impossible de décoder la frame: $framePath');
    }

    if (image.width != 112 || image.height != 112) {
      image = img.copyResize(image, width: 112, height: 112);
    }

    // Create a 4D tensor: [1, 112, 112, 3]
    final input = [
      List.generate(112, (y) => List.generate(112, (x) {
        final pixel = image!.getPixel(x, y);
        return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
      }))
    ];

    return input;
  }

  VideoRecognitionResult _createResult(
      List<double> output,
      FrameExtractionResult extractionResult,
      int preprocessTimeMs,
      int inferenceTimeMs,
      int totalTimeMs,
      ) {
    final predictions = <VideoPrediction>[];
    for (int i = 0; i < output.length; i++) {
      predictions.add(VideoPrediction(label: _labels![i], confidence: output[i]));
    }
    predictions.sort((a, b) => b.confidence.compareTo(a.confidence));
    return VideoRecognitionResult(
      topPrediction: predictions.first,
      allPredictions: predictions.take(5).toList(),
      extractionTimeMs: extractionResult.extractionTimeMs,
      preprocessTimeMs: preprocessTimeMs,
      inferenceTime: inferenceTimeMs,
      totalTimeMs: totalTimeMs,
      framesProcessed: extractionResult.frameCount,
      sequenceLength: extractionResult.frameCount, // Use frameCount as sequenceLength
      originalDuration: extractionResult.originalDuration,
    );
  }

  void dispose() {
    _interpreter?.close();
  }
}

class VideoRecognitionResult {
  final VideoPrediction topPrediction;
  final List<VideoPrediction> allPredictions;
  final int extractionTimeMs;
  final int preprocessTimeMs;
  final int inferenceTime; // Renamed from inferenceTimeMs
  final int totalTimeMs;
  final int framesProcessed;
  final int sequenceLength; // Added for sequence length
  final double originalDuration;

  VideoRecognitionResult({
    required this.topPrediction,
    required this.allPredictions,
    required this.extractionTimeMs,
    required this.preprocessTimeMs,
    required this.inferenceTime,
    required this.totalTimeMs,
    required this.framesProcessed,
    required this.sequenceLength,
    required this.originalDuration,
  });

  String get performanceReport => '''
🚀 Performance:
• Extraction: ${extractionTimeMs}ms
• Preprocessing: ${preprocessTimeMs}ms
• Inférence: ${inferenceTime}ms
• Total: ${totalTimeMs}ms
• Frames: $framesProcessed
• Durée vidéo: ${originalDuration.toStringAsFixed(1)}s
''';
}

class VideoPrediction {
  final String label;
  final double confidence;

  VideoPrediction({required this.label, required this.confidence});

  @override
  String toString() => '$label (${(confidence * 100).toStringAsFixed(1)}%)';
}