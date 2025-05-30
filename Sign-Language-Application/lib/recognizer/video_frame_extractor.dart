import 'dart:io';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

class VideoFrameExtractor {
  static const int TARGET_FRAMES = 16;
  static const int FRAME_SIZE = 112;
  static const int QUALITY = 85;

  Future<FrameExtractionResult> extractFrames(String videoPath) async {
    final stopwatch = Stopwatch()..start();
    try {
      print('🚀 Début extraction frames: $videoPath');
      final videoFile = File(videoPath);
      if (!await videoFile.exists()) {
        throw Exception('Fichier vidéo introuvable: $videoPath');
      }

      final videoInfo = await _getVideoInfo(videoPath);
      print('ℹ️ Durée: ${videoInfo.duration}s, Taille: ${videoInfo.fileSize} bytes');

      final tempDir = await _createTempDirectory();
      final timestamps = _calculateTimestamps(videoInfo.duration);
      print('⏱️ Timestamps: ${timestamps.map((t) => t.toStringAsFixed(2)).join(', ')}');

      final framePaths = await _extractFramesAtTimestamps(videoPath, tempDir, timestamps);
      final validFrames = await _validateFrames(framePaths);

      stopwatch.stop();
      final result = FrameExtractionResult(
        framePaths: validFrames,
        extractionTimeMs: stopwatch.elapsedMilliseconds,
        originalDuration: videoInfo.duration,
        success: validFrames.length >= TARGET_FRAMES * 0.75,
      );
      print('✅ Extraction terminée: ${validFrames.length} frames en ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      print('❌ Erreur extraction: $e');
      print('StackTrace: $stackTrace');
      return FrameExtractionResult(
        framePaths: [],
        extractionTimeMs: stopwatch.elapsedMilliseconds,
        originalDuration: 0.0,
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<VideoInfo> _getVideoInfo(String videoPath) async {
    VideoPlayerController? controller;
    try {
      controller = VideoPlayerController.file(File(videoPath));
      await controller.initialize();
      final duration = controller.value.duration.inMilliseconds / 1000.0;
      final size = controller.value.size;
      final fileSize = await File(videoPath).length();
      return VideoInfo(
        duration: duration,
        width: size.width.toInt(),
        height: size.height.toInt(),
        fileSize: fileSize,
      );
    } finally {
      await controller?.dispose();
    }
  }

  Future<String> _createTempDirectory() async {
    final tempDir = await getTemporaryDirectory();
    final extractionDir = Directory('${tempDir.path}/frames_${DateTime.now().millisecondsSinceEpoch}');
    await extractionDir.create(recursive: true);
    return extractionDir.path;
  }

  List<double> _calculateTimestamps(double videoDuration) {
    final timestamps = <double>[];
    if (videoDuration <= 0) {
      throw Exception('Durée vidéo invalide: $videoDuration');
    }

    final startOffset = videoDuration * 0.05;
    final endOffset = videoDuration * 0.95;
    final usableDuration = endOffset - startOffset;

    if (usableDuration <= 0) {
      for (int i = 0; i < TARGET_FRAMES; i++) {
        timestamps.add((i * videoDuration) / TARGET_FRAMES);
      }
    } else {
      for (int i = 0; i < TARGET_FRAMES; i++) {
        final position = startOffset + (i * usableDuration) / (TARGET_FRAMES - 1);
        timestamps.add(position);
      }
    }
    return timestamps;
  }

  Future<List<String>> _extractFramesAtTimestamps(
      String videoPath,
      String outputDir,
      List<double> timestamps,
      ) async {
    final framePaths = <String>[];
    for (int i = 0; i < timestamps.length; i++) {
      try {
        final timestamp = timestamps[i];
        final framePath = path.join(outputDir, 'frame_${i.toString().padLeft(3, '0')}.jpg');
        print('🖼️ Extraction frame $i à ${timestamp.toStringAsFixed(2)}s, path: $framePath');

        // Extract thumbnail using video_compress
        final thumbnail = await VideoCompress.getFileThumbnail(
          videoPath,
          quality: QUALITY,
          position: (timestamp * 1000).toInt(), // Convert seconds to milliseconds
        );

        // Resize to 112x112
        final image = img.decodeImage(await thumbnail.readAsBytes());
        if (image != null) {
          final resized = img.copyResize(image, width: FRAME_SIZE, height: FRAME_SIZE);
          final resizedFile = File(framePath);
          await resizedFile.writeAsBytes(img.encodeJpg(resized, quality: QUALITY));

          if (resizedFile.existsSync()) {
            framePaths.add(framePath);
            print('✅ Frame $i extraite: ${path.basename(framePath)}');
          } else {
            print('⚠️ Échec sauvegarde frame $i: fichier non créé');
          }
        } else {
          print('⚠️ Échec décodage frame $i: image nulle');
        }

        // Clean up temporary thumbnail
        await thumbnail.delete();

        // Throttle to reduce main-thread load
        await Future.delayed(Duration(milliseconds: 50));
      } catch (e, stackTrace) {
        print('❌ Erreur frame $i: $e');
        print('StackTrace: $stackTrace');
      }
    }
    return framePaths;
  }

  Future<List<String>> _validateFrames(List<String> framePaths) async {
    final validFrames = <String>[];
    for (final framePath in framePaths) {
      try {
        final file = File(framePath);
        if (await file.exists()) {
          final size = await file.length();
          if (size > 1000) {
            validFrames.add(framePath);
          } else {
            print('⚠️ Frame trop petite: ${path.basename(framePath)} (${size} bytes)');
          }
        }
      } catch (e) {
        print('❌ Erreur validation frame: $e');
      }
    }

    if (validFrames.isNotEmpty && validFrames.length < TARGET_FRAMES) {
      final lastFrame = validFrames.last;
      while (validFrames.length < TARGET_FRAMES) {
        validFrames.add(lastFrame);
      }
      print('🔁 Frames dupliquées pour atteindre $TARGET_FRAMES');
    }

    return validFrames.take(TARGET_FRAMES).toList();
  }

  Future<void> cleanupFrames(List<String> framePaths) async {
    for (final framePath in framePaths) {
      try {
        final file = File(framePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Erreur nettoyage $framePath: $e');
      }
    }

    if (framePaths.isNotEmpty) {
      try {
        final dir = Directory(path.dirname(framePaths.first));
        if (await dir.exists()) {
          final contents = await dir.list().toList();
          if (contents.isEmpty) {
            await dir.delete();
          }
        }
      } catch (e) {
        print('Erreur nettoyage dossier: $e');
      }
    }
  }
}

class FrameExtractionResult {
  final List<String> framePaths;
  final int extractionTimeMs;
  final double originalDuration;
  final bool success;
  final String? error;

  FrameExtractionResult({
    required this.framePaths,
    required this.extractionTimeMs,
    required this.originalDuration,
    required this.success,
    this.error,
  });

  int get frameCount => framePaths.length;
  double get framesPerSecond => originalDuration > 0 ? frameCount / originalDuration : 0;
}

class VideoInfo {
  final double duration;
  final int width;
  final int height;
  final int fileSize;

  VideoInfo({
    required this.duration,
    required this.width,
    required this.height,
    required this.fileSize,
  });
}