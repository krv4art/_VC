import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/fish_collection.dart';
import '../models/fish_identification.dart';
import '../models/fishing_statistics.dart';
import 'database_service.dart';

/// Service for exporting data to PDF and Excel
class ExportService {
  static final ExportService instance = ExportService._internal();

  factory ExportService() => instance;

  ExportService._internal();

  /// Export collection to PDF
  Future<File> exportCollectionToPdf({
    DateTime? startDate,
    DateTime? endDate,
    bool includePhotos = true,
  }) async {
    final pdf = pw.Document();
    final collection = await DatabaseService.instance.getAllCollection();

    // Filter by date range if provided
    final filtered = collection.where((fish) {
      final catchDate = DateTime.parse(fish.catchDate);
      if (startDate != null && catchDate.isBefore(startDate)) return false;
      if (endDate != null && catchDate.isAfter(endDate)) return false;
      return true;
    }).toList();

    // Add cover page
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Fish Identifier',
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Catch Collection Report',
                  style: const pw.TextStyle(fontSize: 24),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Generated: ${DateTime.now().toString().substring(0, 10)}',
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.Text(
                  'Total Catches: ${filtered.length}',
                  style: const pw.TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Add collection pages
    for (final fish in filtered) {
      final fishData = await DatabaseService.instance
          .getFishIdentificationById(fish.fishIdentificationId);

      if (fishData == null) continue;

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  fishData.fishName,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  fishData.scientificName,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
                pw.Divider(),
                pw.SizedBox(height: 20),
                _buildDetailRow('Caught on', fish.catchDate.substring(0, 10)),
                if (fish.location != null)
                  _buildDetailRow('Location', fish.location!),
                if (fish.length != null)
                  _buildDetailRow('Length', '${fish.length} cm'),
                if (fish.weight != null)
                  _buildDetailRow('Weight', '${fish.weight} kg'),
                if (fish.weatherConditions != null)
                  _buildDetailRow('Weather', fish.weatherConditions!),
                if (fish.baitUsed != null)
                  _buildDetailRow('Bait', fish.baitUsed!),
                if (fish.notes != null) ...[
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Notes:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(fish.notes!),
                ],
              ],
            );
          },
        ),
      );
    }

    // Save PDF to temp directory
    final output = await _getTempFilePath('fish_collection.pdf');
    final file = File(output);
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Export collection to Excel
  Future<File> exportCollectionToExcel({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Catch Collection'];

    // Add headers
    sheet.appendRow([
      const TextCellValue('Fish Name'),
      const TextCellValue('Scientific Name'),
      const TextCellValue('Catch Date'),
      const TextCellValue('Location'),
      const TextCellValue('Latitude'),
      const TextCellValue('Longitude'),
      const TextCellValue('Length (cm)'),
      const TextCellValue('Weight (kg)'),
      const TextCellValue('Weather'),
      const TextCellValue('Bait'),
      const TextCellValue('Notes'),
    ]);

    // Get data
    final collection = await DatabaseService.instance.getAllCollection();

    // Filter and add rows
    for (final fish in collection) {
      final catchDate = DateTime.parse(fish.catchDate);
      if (startDate != null && catchDate.isBefore(startDate)) continue;
      if (endDate != null && catchDate.isAfter(endDate)) continue;

      final fishData = await DatabaseService.instance
          .getFishIdentificationById(fish.fishIdentificationId);

      if (fishData == null) continue;

      sheet.appendRow([
        TextCellValue(fishData.fishName),
        TextCellValue(fishData.scientificName),
        TextCellValue(fish.catchDate.substring(0, 10)),
        TextCellValue(fish.location ?? ''),
        fish.latitude != null ? DoubleCellValue(fish.latitude!) : const TextCellValue(''),
        fish.longitude != null ? DoubleCellValue(fish.longitude!) : const TextCellValue(''),
        fish.length != null ? DoubleCellValue(fish.length!) : const TextCellValue(''),
        fish.weight != null ? DoubleCellValue(fish.weight!) : const TextCellValue(''),
        TextCellValue(fish.weatherConditions ?? ''),
        TextCellValue(fish.baitUsed ?? ''),
        TextCellValue(fish.notes ?? ''),
      ]);
    }

    // Save Excel file
    final output = await _getTempFilePath('fish_collection.xlsx');
    final file = File(output);
    await file.writeAsBytes(excel.encode()!);

    return file;
  }

  /// Export statistics to PDF
  Future<File> exportStatisticsToPdf(FishingStatistics stats) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Fishing Statistics Report'),
            ),
            pw.Paragraph(
              text: 'Period: ${stats.periodStart.toString().substring(0, 10)} - ${stats.periodEnd.toString().substring(0, 10)}',
            ),
            pw.SizedBox(height: 20),
            pw.Header(level: 1, child: pw.Text('Overview')),
            _buildStatRow('Total Catches', stats.overall.totalCatches.toString()),
            _buildStatRow('Unique Species', stats.overall.uniqueSpecies.toString()),
            _buildStatRow('Unique Locations', stats.overall.uniqueLocations.toString()),
            _buildStatRow('Average Length', '${stats.overall.averageLength.toStringAsFixed(1)} cm'),
            _buildStatRow('Average Weight', '${stats.overall.averageWeight.toStringAsFixed(2)} kg'),
            _buildStatRow('Days Active', stats.overall.daysActive.toString()),
            pw.SizedBox(height: 20),
            pw.Header(level: 1, child: pw.Text('Personal Records')),
            if (stats.records.longestFish != null) ...[
              _buildStatRow(
                'Longest Fish',
                '${stats.records.longestFish!.speciesName} - ${stats.records.longestFish!.length.toStringAsFixed(1)} cm',
              ),
            ],
            if (stats.records.heaviestFish != null) ...[
              _buildStatRow(
                'Heaviest Fish',
                '${stats.records.heaviestFish!.speciesName} - ${stats.records.heaviestFish!.weight.toStringAsFixed(2)} kg',
              ),
            ],
            _buildStatRow('Current Streak', '${stats.records.currentStreak} days'),
            _buildStatRow('Longest Streak', '${stats.records.longestStreak} days'),
          ];
        },
      ),
    );

    final output = await _getTempFilePath('fishing_statistics.pdf');
    final file = File(output);
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Share exported file
  Future<void> shareFile(File file, {String? subject}) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject ?? 'Fish Identifier Export',
    );
  }

  /// Helper: Build detail row for PDF
  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label + ':',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  /// Helper: Build stat row for PDF
  pw.Widget _buildStatRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label),
          pw.Text(
            value,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Helper: Get temp file path
  Future<String> _getTempFilePath(String filename) async {
    final tempDir = await getTemporaryDirectory();
    return '${tempDir.path}/$filename';
  }
}
