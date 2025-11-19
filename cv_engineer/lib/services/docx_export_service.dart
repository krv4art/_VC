// services/docx_export_service.dart
// Service for exporting resume to DOCX format

import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:cv_engineer/models/resume.dart';
import 'package:path_provider/path_provider.dart';

class DocxExportService {
  /// Export resume to DOCX format
  static Future<File> exportToDocx(Resume resume, {String? fileName}) async {
    fileName ??= '${resume.personalInfo.fullName.replaceAll(' ', '_')}_Resume';

    // Create DOCX content
    final docxBytes = await _createDocx(resume);

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/${fileName}_$timestamp.docx');

    await file.writeAsBytes(docxBytes);
    return file;
  }

  /// Create DOCX file bytes
  static Future<Uint8List> _createDocx(Resume resume) async {
    // Create a ZIP archive (DOCX is a ZIP file)
    final archive = Archive();

    // Add required DOCX files
    archive.addFile(_createContentTypes());
    archive.addFile(_createRels());
    archive.addFile(_createDocumentRels());
    archive.addFile(_createDocument(resume));

    // Encode to ZIP
    final zipEncoder = ZipEncoder();
    final bytes = zipEncoder.encode(archive);

    return Uint8List.fromList(bytes!);
  }

  /// Create [Content_Types].xml
  static ArchiveFile _createContentTypes() {
    const content = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>''';

    return ArchiveFile('[Content_Types].xml', content.length, content.codeUnits);
  }

  /// Create _rels/.rels
  static ArchiveFile _createRels() {
    const content = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>''';

    return ArchiveFile('_rels/.rels', content.length, content.codeUnits);
  }

  /// Create word/_rels/document.xml.rels
  static ArchiveFile _createDocumentRels() {
    const content = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
</Relationships>''';

    return ArchiveFile('word/_rels/document.xml.rels', content.length, content.codeUnits);
  }

  /// Create word/document.xml with resume content
  static ArchiveFile _createDocument(Resume resume) {
    final buffer = StringBuffer();

    // Document header
    buffer.write('''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>''');

    // Personal Info
    _addHeading(buffer, resume.personalInfo.fullName, 28);
    if (resume.personalInfo.email.isNotEmpty || resume.personalInfo.phone.isNotEmpty) {
      _addParagraph(buffer, '${resume.personalInfo.email} | ${resume.personalInfo.phone}');
    }

    if (resume.personalInfo.summary.isNotEmpty) {
      _addEmptyLine(buffer);
      _addParagraph(buffer, resume.personalInfo.summary);
    }

    // Experience
    if (resume.experience.isNotEmpty) {
      _addEmptyLine(buffer);
      _addHeading(buffer, 'PROFESSIONAL EXPERIENCE', 18);

      for (final exp in resume.experience) {
        _addEmptyLine(buffer);
        _addBoldParagraph(buffer, exp.jobTitle);
        _addParagraph(buffer, '${exp.company}${exp.location.isNotEmpty ? ' | ${exp.location}' : ''}');
        if (exp.startDate != null) {
          final endDateStr = exp.isCurrentPosition ? 'Present' : exp.endDate?.toString().substring(0, 10) ?? '';
          _addParagraph(buffer, '${exp.startDate.toString().substring(0, 10)} - $endDateStr');
        }

        if (exp.description.isNotEmpty) {
          _addParagraph(buffer, exp.description);
        }

        for (final resp in exp.responsibilities) {
          _addBulletPoint(buffer, resp);
        }
      }
    }

    // Education
    if (resume.education.isNotEmpty) {
      _addEmptyLine(buffer);
      _addHeading(buffer, 'EDUCATION', 18);

      for (final edu in resume.education) {
        _addEmptyLine(buffer);
        _addBoldParagraph(buffer, edu.degree);
        _addParagraph(buffer, '${edu.institution}${edu.location.isNotEmpty ? ' | ${edu.location}' : ''}');
        if (edu.startDate != null) {
          final endDateStr = edu.isCurrentlyStudying ? 'Present' : edu.endDate?.toString().substring(0, 10) ?? '';
          _addParagraph(buffer, '${edu.startDate.toString().substring(0, 10)} - $endDateStr');
        }

        if (edu.gpa.isNotEmpty) {
          _addParagraph(buffer, 'GPA: ${edu.gpa}');
        }

        for (final achievement in edu.achievements) {
          _addBulletPoint(buffer, achievement);
        }
      }
    }

    // Skills
    if (resume.skills.isNotEmpty) {
      _addEmptyLine(buffer);
      _addHeading(buffer, 'SKILLS', 18);
      _addEmptyLine(buffer);

      final skillsByCategory = <String, List<String>>{};
      for (final skill in resume.skills) {
        skillsByCategory.putIfAbsent(skill.category, () => []).add(skill.name);
      }

      for (final category in skillsByCategory.keys) {
        final skills = skillsByCategory[category]!;
        _addBoldParagraph(buffer, '$category:');
        _addParagraph(buffer, skills.join(', '));
      }
    }

    // Languages
    if (resume.languages.isNotEmpty) {
      _addEmptyLine(buffer);
      _addHeading(buffer, 'LANGUAGES', 18);
      _addEmptyLine(buffer);

      final languageList = resume.languages.map((lang) => '${lang.name} (${lang.proficiency})').join(', ');
      _addParagraph(buffer, languageList);
    }

    // Custom Sections
    for (final section in resume.customSections) {
      _addEmptyLine(buffer);
      _addHeading(buffer, section.title.toUpperCase(), 18);

      for (final entry in section.entries) {
        _addEmptyLine(buffer);
        _addBoldParagraph(buffer, entry.title);
        if (entry.subtitle.isNotEmpty) {
          _addParagraph(buffer, entry.subtitle);
        }
        if (entry.description.isNotEmpty) {
          _addParagraph(buffer, entry.description);
        }
      }
    }

    // Document footer
    buffer.write('''
  </w:body>
</w:document>''');

    final content = buffer.toString();
    return ArchiveFile('word/document.xml', content.length, content.codeUnits);
  }

  /// Helper methods for formatting

  static void _addHeading(StringBuffer buffer, String text, int fontSize) {
    buffer.write('''
    <w:p>
      <w:pPr>
        <w:spacing w:before="240" w:after="120"/>
      </w:pPr>
      <w:r>
        <w:rPr>
          <w:b/>
          <w:sz w:val="$fontSize"/>
        </w:rPr>
        <w:t>${_escapeXml(text)}</w:t>
      </w:r>
    </w:p>''');
  }

  static void _addParagraph(StringBuffer buffer, String text) {
    if (text.isEmpty) return;

    buffer.write('''
    <w:p>
      <w:r>
        <w:t>${_escapeXml(text)}</w:t>
      </w:r>
    </w:p>''');
  }

  static void _addBoldParagraph(StringBuffer buffer, String text) {
    if (text.isEmpty) return;

    buffer.write('''
    <w:p>
      <w:r>
        <w:rPr>
          <w:b/>
        </w:rPr>
        <w:t>${_escapeXml(text)}</w:t>
      </w:r>
    </w:p>''');
  }

  static void _addBulletPoint(StringBuffer buffer, String text) {
    if (text.isEmpty) return;

    buffer.write('''
    <w:p>
      <w:pPr>
        <w:pStyle w:val="ListParagraph"/>
        <w:numPr>
          <w:ilvl w:val="0"/>
          <w:numId w:val="1"/>
        </w:numPr>
      </w:pPr>
      <w:r>
        <w:t>${_escapeXml(text)}</w:t>
      </w:r>
    </w:p>''');
  }

  static void _addEmptyLine(StringBuffer buffer) {
    buffer.write('''
    <w:p>
      <w:r>
        <w:t></w:t>
      </w:r>
    </w:p>''');
  }

  static String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}
