import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/cover_letter.dart';
import '../services/storage_service.dart';

/// Provider for managing cover letters
class CoverLetterProvider extends ChangeNotifier {
  final StorageService _storageService;
  CoverLetter? _currentCoverLetter;
  List<CoverLetter> _savedCoverLetters = [];
  bool _isLoading = false;

  CoverLetterProvider(this._storageService);

  CoverLetter? get currentCoverLetter => _currentCoverLetter;
  List<CoverLetter> get savedCoverLetters => _savedCoverLetters;
  bool get isLoading => _isLoading;
  bool get hasCurrentCoverLetter => _currentCoverLetter != null;

  final _uuid = const Uuid();

  /// Initialize - load cover letters from storage
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _savedCoverLetters = await _storageService.loadCoverLetters();
      if (_savedCoverLetters.isNotEmpty) {
        _currentCoverLetter = _savedCoverLetters.first;
      }
    } catch (e) {
      debugPrint('Error loading cover letters: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Create new cover letter
  Future<void> createNewCoverLetter({
    String? senderName,
    String? senderEmail,
    String? resumeId,
  }) async {
    final now = DateTime.now();
    _currentCoverLetter = CoverLetter(
      id: _uuid.v4(),
      senderName: senderName ?? '',
      senderEmail: senderEmail ?? '',
      recipientName: '',
      companyName: '',
      date: now,
      body: '',
      associatedResumeId: resumeId,
      createdAt: now,
      updatedAt: now,
    );
    await _saveCurrentCoverLetter();
    notifyListeners();
  }

  /// Load existing cover letter
  Future<void> loadCoverLetter(String coverLetterId) async {
    final coverLetter = _savedCoverLetters.firstWhere(
      (cl) => cl.id == coverLetterId,
    );
    _currentCoverLetter = coverLetter;
    notifyListeners();
  }

  /// Update cover letter content
  Future<void> updateCoverLetter({
    String? title,
    String? senderName,
    String? senderEmail,
    String? senderPhone,
    String? senderAddress,
    String? recipientName,
    String? recipientTitle,
    String? companyName,
    String? companyAddress,
    DateTime? date,
    String? salutation,
    String? body,
    String? closing,
    String? associatedResumeId,
  }) async {
    if (_currentCoverLetter == null) return;

    _currentCoverLetter = _currentCoverLetter!.copyWith(
      title: title,
      senderName: senderName,
      senderEmail: senderEmail,
      senderPhone: senderPhone,
      senderAddress: senderAddress,
      recipientName: recipientName,
      recipientTitle: recipientTitle,
      companyName: companyName,
      companyAddress: companyAddress,
      date: date,
      salutation: salutation,
      body: body,
      closing: closing,
      associatedResumeId: associatedResumeId,
      updatedAt: DateTime.now(),
    );

    await _saveCurrentCoverLetter();
    notifyListeners();
  }

  /// Update title only
  Future<void> updateTitle(String title) async {
    if (_currentCoverLetter == null) return;
    _currentCoverLetter = _currentCoverLetter!.copyWith(
      title: title,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentCoverLetter();
    notifyListeners();
  }

  /// Update body only
  Future<void> updateBody(String body) async {
    if (_currentCoverLetter == null) return;
    _currentCoverLetter = _currentCoverLetter!.copyWith(
      body: body,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentCoverLetter();
    notifyListeners();
  }

  /// Duplicate cover letter
  Future<CoverLetter> duplicateCoverLetter(String coverLetterId) async {
    final original = _savedCoverLetters.firstWhere(
      (cl) => cl.id == coverLetterId,
    );

    final now = DateTime.now();
    final duplicated = CoverLetter(
      id: _uuid.v4(),
      title: original.title != null ? '${original.title} (Copy)' : null,
      senderName: original.senderName,
      senderEmail: original.senderEmail,
      senderPhone: original.senderPhone,
      senderAddress: original.senderAddress,
      recipientName: original.recipientName,
      recipientTitle: original.recipientTitle,
      companyName: original.companyName,
      companyAddress: original.companyAddress,
      date: now,
      salutation: original.salutation,
      body: original.body,
      closing: original.closing,
      associatedResumeId: original.associatedResumeId,
      createdAt: now,
      updatedAt: now,
    );

    await _storageService.saveCoverLetter(duplicated);
    _savedCoverLetters.add(duplicated);
    _currentCoverLetter = duplicated;
    notifyListeners();

    return duplicated;
  }

  /// Delete cover letter
  Future<void> deleteCoverLetter(String coverLetterId) async {
    await _storageService.deleteCoverLetter(coverLetterId);
    _savedCoverLetters.removeWhere((cl) => cl.id == coverLetterId);

    if (_currentCoverLetter?.id == coverLetterId) {
      _currentCoverLetter = _savedCoverLetters.isNotEmpty
        ? _savedCoverLetters.first
        : null;
    }
    notifyListeners();
  }

  /// Save current cover letter
  Future<void> _saveCurrentCoverLetter() async {
    if (_currentCoverLetter == null) return;
    await _storageService.saveCoverLetter(_currentCoverLetter!);

    // Update saved cover letters list
    final index = _savedCoverLetters.indexWhere(
      (cl) => cl.id == _currentCoverLetter!.id,
    );
    if (index >= 0) {
      _savedCoverLetters[index] = _currentCoverLetter!;
    } else {
      _savedCoverLetters.add(_currentCoverLetter!);
    }
  }

  /// Get cover letters for a specific resume
  List<CoverLetter> getCoverLettersForResume(String resumeId) {
    return _savedCoverLetters
        .where((cl) => cl.associatedResumeId == resumeId)
        .toList();
  }
}
