import 'dart:convert';

class ScanResult {
  final int? id;
  final String imagePath;
  final Map<String, dynamic> analysisResult;
  final DateTime scanDate;

  ScanResult({
    this.id,
    required this.imagePath,
    required this.analysisResult,
    required this.scanDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'analysisResult': jsonEncode(analysisResult),
      'scanDate': scanDate.toIso8601String(),
    };
  }

  factory ScanResult.fromMap(Map<String, dynamic> map) {
    return ScanResult(
      id: map['id'] as int?,
      imagePath: map['imagePath'] as String,
      analysisResult: jsonDecode(map['analysisResult'] as String) as Map<String, dynamic>,
      scanDate: DateTime.parse(map['scanDate'] as String),
    );
  }
}
