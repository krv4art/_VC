import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw';
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/analysis_result.dart';

/// Сервис для экспорта коллекции в различные форматы
class ExportService {
  /// Экспорт коллекции в PDF
  Future<void> exportToPDF(List<AnalysisResult> coins,
      {bool includeImages = false}) async {
    try {
      final pdf = pw.Document();

      // Title page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text('Coin Collection Report',
                      style: pw.TextStyle(
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                      )),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Generated: ${DateTime.now().toString()}',
                    style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text('Total Coins: ${coins.length}',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.Divider(),
                pw.SizedBox(height: 20),
              ],
            );
          },
        ),
      );

      // Coin details pages
      for (var coin in coins) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    coin.name,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                  _buildPdfField('Country', coin.country),
                  _buildPdfField('Year', coin.yearOfIssue),
                  _buildPdfField('Denomination', coin.denomination),
                  _buildPdfField('Mint Mark', coin.mintMark),
                  pw.SizedBox(height: 10),
                  pw.Text('Description:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(coin.description),
                  pw.SizedBox(height: 10),
                  _buildPdfField('Rarity',
                      '${coin.rarityLevel} (${coin.rarityScore}/10)'),
                  if (coin.marketValue != null)
                    _buildPdfField('Market Value',
                        coin.marketValue!.getFormattedRange()),
                  if (coin.weight != null)
                    _buildPdfField('Weight', '${coin.weight}g'),
                  if (coin.diameter != null)
                    _buildPdfField('Diameter', '${coin.diameter}mm'),
                  if (coin.edge != null) _buildPdfField('Edge', coin.edge),
                  if (coin.materials.isNotEmpty) ...[
                    pw.SizedBox(height: 10),
                    pw.Text('Materials:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ...coin.materials.map((m) => pw.Text(
                        '  • ${m.name}: ${m.percentage}%',
                        style: const pw.TextStyle(fontSize: 12))),
                  ],
                  if (coin.historicalContext.isNotEmpty) ...[
                    pw.SizedBox(height: 10),
                    pw.Text('Historical Context:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(coin.historicalContext,
                        style: const pw.TextStyle(fontSize: 12)),
                  ],
                  if (coin.userNotes != null) ...[
                    pw.SizedBox(height: 10),
                    pw.Text('Notes:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(coin.userNotes!,
                        style: const pw.TextStyle(fontSize: 12)),
                  ],
                ],
              );
            },
          ),
        );
      }

      // Save and share
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'coin_collection_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      debugPrint('✓ PDF export successful');
    } catch (e) {
      debugPrint('Error exporting to PDF: $e');
      rethrow;
    }
  }

  pw.Widget _buildPdfField(String label, String? value) {
    if (value == null || value.isEmpty) return pw.SizedBox();

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Text('$label: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(value),
        ],
      ),
    );
  }

  /// Экспорт коллекции в CSV
  Future<void> exportToCSV(List<AnalysisResult> coins) async {
    try {
      // Prepare CSV data
      List<List<dynamic>> rows = [];

      // Header
      rows.add([
        'Name',
        'Country',
        'Year',
        'Denomination',
        'Mint Mark',
        'Rarity Level',
        'Rarity Score',
        'Min Price',
        'Max Price',
        'Currency',
        'Weight (g)',
        'Diameter (mm)',
        'Edge',
        'Materials',
        'Is Wishlist',
        'Is Favorite',
        'Tags',
        'User Notes',
        'Added Date',
        'Purchase Price',
        'Purchase Date',
        'Location',
      ]);

      // Data rows
      for (var coin in coins) {
        rows.add([
          coin.name,
          coin.country ?? '',
          coin.yearOfIssue ?? '',
          coin.denomination ?? '',
          coin.mintMark ?? '',
          coin.rarityLevel,
          coin.rarityScore,
          coin.marketValue?.minPrice ?? '',
          coin.marketValue?.maxPrice ?? '',
          coin.marketValue?.currency ?? '',
          coin.weight ?? '',
          coin.diameter ?? '',
          coin.edge ?? '',
          coin.materials.map((m) => '${m.name} ${m.percentage}%').join('; '),
          coin.isInWishlist ? 'Yes' : 'No',
          coin.isFavorite ? 'Yes' : 'No',
          coin.tags.join('; '),
          coin.userNotes ?? '',
          coin.addedAt?.toIso8601String() ?? '',
          coin.purchasePrice ?? '',
          coin.purchaseDate?.toIso8601String() ?? '',
          coin.location ?? '',
        ]);
      }

      // Convert to CSV string
      String csv = const ListToCsvConverter().convert(rows);

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/coin_collection_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csv);

      // Share file
      await Share.shareXFiles([XFile(file.path)],
          text: 'My Coin Collection');

      debugPrint('✓ CSV export successful: ${file.path}');
    } catch (e) {
      debugPrint('Error exporting to CSV: $e');
      rethrow;
    }
  }

  /// Экспорт статистики в PDF
  Future<void> exportStatisticsToPDF(Map<String, dynamic> stats) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text('Collection Statistics',
                      style: pw.TextStyle(
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                      )),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Generated: ${DateTime.now().toString()}',
                    style: const pw.TextStyle(fontSize: 14)),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text('Overview',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.SizedBox(height: 10),
                _buildPdfField(
                    'Total Coins in Collection', '${stats['total_count']}'),
                _buildPdfField(
                    'Coins in Wishlist', '${stats['wishlist_count']}'),
                _buildPdfField(
                    'Total Value', '\$${stats['total_value']?.toStringAsFixed(2) ?? '0.00'}'),
                pw.SizedBox(height: 20),
                if (stats['countries'] != null) ...[
                  pw.Text('Countries',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.SizedBox(height: 10),
                  ...(stats['countries'] as List).map((item) => pw.Text(
                      '  • ${item['country']}: ${item['count']} coins',
                      style: const pw.TextStyle(fontSize: 12))),
                ],
                pw.SizedBox(height: 20),
                if (stats['rarity_distribution'] != null) ...[
                  pw.Text('Rarity Distribution',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.SizedBox(height: 10),
                  ...(stats['rarity_distribution'] as List).map((item) =>
                      pw.Text('  • ${item['rarity_level']}: ${item['count']} coins',
                          style: const pw.TextStyle(fontSize: 12))),
                ],
              ],
            );
          },
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'collection_stats_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      debugPrint('✓ Statistics PDF export successful');
    } catch (e) {
      debugPrint('Error exporting statistics to PDF: $e');
      rethrow;
    }
  }
}
