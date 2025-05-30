class VideoPrediction {
  final String label;
  final double confidence;
  VideoPrediction({required this.label, required this.confidence});
  @override
  String toString() => '$label (${(confidence * 100).toStringAsFixed(1)}%)';
}