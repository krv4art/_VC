import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/resume.dart';
import '../models/cover_letter.dart';

/// Service for local storage of resumes and cover letters
class StorageService {
  static const String _resumesKey = 'saved_resumes';
  static const String _coverLettersKey = 'saved_cover_letters';

  // Save resume
  Future<void> saveResume(Resume resume) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resumes = await loadResumes();

      // Update or add resume
      final index = resumes.indexWhere((r) => r.id == resume.id);
      if (index >= 0) {
        resumes[index] = resume;
      } else {
        resumes.add(resume);
      }

      // Save to storage
      final resumesJson = resumes.map((r) => r.toJson()).toList();
      await prefs.setString(_resumesKey, jsonEncode(resumesJson));
    } catch (e) {
      debugPrint('Error saving resume: $e');
      rethrow;
    }
  }

  // Load all resumes
  Future<List<Resume>> loadResumes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resumesString = prefs.getString(_resumesKey);

      if (resumesString == null || resumesString.isEmpty) {
        return [];
      }

      final List<dynamic> resumesJson = jsonDecode(resumesString);
      return resumesJson.map((json) => Resume.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading resumes: $e');
      return [];
    }
  }

  // Load resume by ID
  Future<Resume?> loadResume(String id) async {
    try {
      final resumes = await loadResumes();
      return resumes.firstWhere(
        (r) => r.id == id,
        orElse: () => throw Exception('Resume not found'),
      );
    } catch (e) {
      debugPrint('Error loading resume: $e');
      return null;
    }
  }

  // Delete resume
  Future<void> deleteResume(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resumes = await loadResumes();

      resumes.removeWhere((r) => r.id == id);

      final resumesJson = resumes.map((r) => r.toJson()).toList();
      await prefs.setString(_resumesKey, jsonEncode(resumesJson));
    } catch (e) {
      debugPrint('Error deleting resume: $e');
      rethrow;
    }
  }

  // Clear all resumes
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_resumesKey);
  }

  // === Cover Letter Methods ===

  // Save cover letter
  Future<void> saveCoverLetter(CoverLetter coverLetter) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final coverLetters = await loadCoverLetters();

      // Update or add cover letter
      final index = coverLetters.indexWhere((cl) => cl.id == coverLetter.id);
      if (index >= 0) {
        coverLetters[index] = coverLetter;
      } else {
        coverLetters.add(coverLetter);
      }

      // Save to storage
      final coverLettersJson = coverLetters.map((cl) => cl.toJson()).toList();
      await prefs.setString(_coverLettersKey, jsonEncode(coverLettersJson));
    } catch (e) {
      debugPrint('Error saving cover letter: $e');
      rethrow;
    }
  }

  // Load all cover letters
  Future<List<CoverLetter>> loadCoverLetters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final coverLettersString = prefs.getString(_coverLettersKey);

      if (coverLettersString == null || coverLettersString.isEmpty) {
        return [];
      }

      final List<dynamic> coverLettersJson = jsonDecode(coverLettersString);
      return coverLettersJson.map((json) => CoverLetter.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading cover letters: $e');
      return [];
    }
  }

  // Load cover letter by ID
  Future<CoverLetter?> loadCoverLetter(String id) async {
    try {
      final coverLetters = await loadCoverLetters();
      return coverLetters.firstWhere(
        (cl) => cl.id == id,
        orElse: () => throw Exception('Cover letter not found'),
      );
    } catch (e) {
      debugPrint('Error loading cover letter: $e');
      return null;
    }
  }

  // Delete cover letter
  Future<void> deleteCoverLetter(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final coverLetters = await loadCoverLetters();

      coverLetters.removeWhere((cl) => cl.id == id);

      final coverLettersJson = coverLetters.map((cl) => cl.toJson()).toList();
      await prefs.setString(_coverLettersKey, jsonEncode(coverLettersJson));
    } catch (e) {
      debugPrint('Error deleting cover letter: $e');
      rethrow;
    }
  }

  // Clear all cover letters
  Future<void> clearAllCoverLetters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_coverLettersKey);
  }
}
