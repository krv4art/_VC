// providers/cover_letter_provider.dart
// State management for cover letters

import 'package:flutter/foundation.dart';
import 'package:cv_engineer/models/cover_letter.dart';
import 'package:cv_engineer/models/resume.dart';
import 'package:cv_engineer/services/cover_letter_service.dart';

class CoverLetterProvider extends ChangeNotifier {
  List<CoverLetter> _coverLetters = [];
  bool _isLoading = false;
  bool _isGenerating = false;
  String? _error;

  List<CoverLetter> get coverLetters => _coverLetters;
  bool get isLoading => _isLoading;
  bool get isGenerating => _isGenerating;
  String? get error => _error;

  // Get cover letters for a specific resume
  List<CoverLetter> getCoverLettersForResume(String resumeId) {
    return _coverLetters.where((cl) => cl.resumeId == resumeId).toList();
  }

  // Get cover letter by ID
  CoverLetter? getCoverLetterById(String id) {
    try {
      return _coverLetters.firstWhere((cl) => cl.id == id);
    } catch (e) {
      return null;
    }
  }

  // Generate new cover letter
  Future<CoverLetter?> generateCoverLetter({
    required Resume resume,
    required String companyName,
    required String position,
    String hiringManagerName = '',
    String jobDescription = '',
    CoverLetterTemplate template = CoverLetterTemplate.professional,
  }) async {
    _isGenerating = true;
    _error = null;
    notifyListeners();

    try {
      final coverLetter = await CoverLetterService.generateCoverLetter(
        resume: resume,
        companyName: companyName,
        position: position,
        hiringManagerName: hiringManagerName,
        jobDescription: jobDescription,
        template: template,
      );

      _coverLetters.add(coverLetter);
      _isGenerating = false;
      notifyListeners();

      // TODO: Save to database
      await _saveToDatabase();

      return coverLetter;
    } catch (e) {
      _error = e.toString();
      _isGenerating = false;
      notifyListeners();
      return null;
    }
  }

  // Add cover letter
  Future<void> addCoverLetter(CoverLetter coverLetter) async {
    try {
      _coverLetters.add(coverLetter);
      notifyListeners();

      // TODO: Save to database
      await _saveToDatabase();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Update cover letter
  Future<void> updateCoverLetter(CoverLetter coverLetter) async {
    try {
      final index = _coverLetters.indexWhere((cl) => cl.id == coverLetter.id);
      if (index != -1) {
        _coverLetters[index] = coverLetter;
        notifyListeners();

        // TODO: Save to database
        await _saveToDatabase();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Delete cover letter
  Future<void> deleteCoverLetter(String id) async {
    try {
      _coverLetters.removeWhere((cl) => cl.id == id);
      notifyListeners();

      // TODO: Save to database
      await _saveToDatabase();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load cover letters from database
  Future<void> loadCoverLetters() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Load from database
      // _coverLetters = await database.getCoverLetters();
      _coverLetters = []; // Temporary

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save to database
  Future<void> _saveToDatabase() async {
    // TODO: Implement database save
    // await database.saveCoverLetters(_coverLetters);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
