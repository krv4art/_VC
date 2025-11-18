import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/resume.dart';

/// Service for local storage of resumes
class StorageService {
  static const String _resumesKey = 'saved_resumes';

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
}
