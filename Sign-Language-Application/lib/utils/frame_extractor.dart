import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class VideoFrameExtractor {
  static const int TARGET_FRAMES = 16;
  static const int FRAME_SIZE = 112;

  final GlobalKey repaintKey;
  final VideoPlayerController videoController;

  VideoFrameExtractor({
    required this.repaintKey,
    required this.videoController,
  });

  Future<List<String>> extractFrames() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final outputDir = Directory(
          '${tempDir.path}/frames_${DateTime.now().millisecondsSinceEpoch}');
      await outputDir.create();

      final duration = videoController.value.duration.inMilliseconds;
      if (duration <= 0) {
        throw Exception('Impossible d\'obtenir la dur\u00e9e de la vid\u00e9o');
      }

      final interval = duration ~/ TARGET_FRAMES;
      List<String> framePaths = [];

      for (int i = 0; i < TARGET_FRAMES; i++) {
        await videoController.seekTo(Duration(milliseconds: i * interval));
        await Future.delayed(Duration(milliseconds: 200)); // Wait for frame settle

        final imageBytes = await _captureFrame();
        if (imageBytes != null) {
          final img.Image? decoded = img.decodeImage(imageBytes);
          if (decoded != null) {
            final resized = img.copyResize(decoded,
                width: FRAME_SIZE, height: FRAME_SIZE);
            final framePath =
                '${outputDir.path}/frame_${i.toString().padLeft(3, '0')}.jpg';
            await File(framePath).writeAsBytes(img.encodeJpg(resized));
            framePaths.add(framePath);
          }
        }
      }

      if (framePaths.length < TARGET_FRAMES) {
        final lastFrame = framePaths.isNotEmpty ? framePaths.last : null;
        while (framePaths.length < TARGET_FRAMES && lastFrame != null) {
          framePaths.add(lastFrame);
        }
      }

      return framePaths.take(TARGET_FRAMES).toList();
    } catch (e) {
      print('Erreur extraction frames: $e');
      return [];
    }
  }

  Future<Uint8List?> _captureFrame() async {
    try {
      final boundary = repaintKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;
      if (boundary != null) {
        final ui.Image image = await boundary.toImage(pixelRatio: 1.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        return byteData?.buffer.asUint8List();
      }
    } catch (e) {
      print('Erreur capture frame: $e');
    }
    return null;
  }

  Future<void> cleanupFrames(List<String> framePaths) async {
    for (final framePath in framePaths) {
      try {
        final file = File(framePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Erreur nettoyage frame: $e');
      }
    }
  }
}
