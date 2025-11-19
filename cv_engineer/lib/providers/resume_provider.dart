import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/resume.dart';
import '../models/experience.dart';
import '../models/education.dart';
import '../models/skill.dart';
import '../models/language.dart' as lang;
import '../models/custom_section.dart';
import '../models/personal_info.dart';
import '../services/storage_service.dart';
import '../utils/demo_data.dart';

/// Provider for managing current resume state
class ResumeProvider extends ChangeNotifier {
  final StorageService _storageService;
  Resume? _currentResume;
  List<Resume> _savedResumes = [];
  bool _isLoading = false;

  ResumeProvider(this._storageService);

  Resume? get currentResume => _currentResume;
  List<Resume> get savedResumes => _savedResumes;
  bool get isLoading => _isLoading;
  bool get hasCurrentResume => _currentResume != null;

  final _uuid = const Uuid();

  // Initialize - load resumes from storage
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _savedResumes = await _storageService.loadResumes();
      if (_savedResumes.isNotEmpty) {
        _currentResume = _savedResumes.first;
      }
    } catch (e) {
      debugPrint('Error loading resumes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create new resume
  Future<void> createNewResume({String templateId = 'professional'}) async {
    final now = DateTime.now();
    _currentResume = Resume(
      id: _uuid.v4(),
      templateId: templateId,
      personalInfo: PersonalInfo.empty(),
      createdAt: now,
      updatedAt: now,
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Load existing resume
  Future<void> loadResume(String resumeId) async {
    final resume = _savedResumes.firstWhere((r) => r.id == resumeId);
    _currentResume = resume;
    notifyListeners();
  }

  // Load demo resume
  Future<void> loadDemoResume(int demoIndex) async {
    final demos = DemoData.getAllDemoResumes();
    if (demoIndex < 0 || demoIndex >= demos.length) return;

    _currentResume = demos[demoIndex];
    await _saveCurrentResume();
    notifyListeners();
  }

  // Update personal info
  Future<void> updatePersonalInfo(PersonalInfo personalInfo) async {
    if (_currentResume == null) return;
    _currentResume = _currentResume!.copyWith(
      personalInfo: personalInfo,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Add experience
  Future<void> addExperience(Experience experience) async {
    if (_currentResume == null) return;
    final experiences = List<Experience>.from(_currentResume!.experiences);
    experiences.add(experience);
    _currentResume = _currentResume!.copyWith(
      experiences: experiences,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Update experience
  Future<void> updateExperience(Experience experience) async {
    if (_currentResume == null) return;
    final experiences = _currentResume!.experiences
        .map((e) => e.id == experience.id ? experience : e)
        .toList();
    _currentResume = _currentResume!.copyWith(
      experiences: experiences,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Delete experience
  Future<void> deleteExperience(String experienceId) async {
    if (_currentResume == null) return;
    final experiences = _currentResume!.experiences
        .where((e) => e.id != experienceId)
        .toList();
    _currentResume = _currentResume!.copyWith(
      experiences: experiences,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Reorder experiences
  Future<void> reorderExperiences(int oldIndex, int newIndex) async {
    if (_currentResume == null) return;
    final experiences = List<Experience>.from(_currentResume!.experiences);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = experiences.removeAt(oldIndex);
    experiences.insert(newIndex, item);

    _currentResume = _currentResume!.copyWith(
      experiences: experiences,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Add education
  Future<void> addEducation(Education education) async {
    if (_currentResume == null) return;
    final educations = List<Education>.from(_currentResume!.educations);
    educations.add(education);
    _currentResume = _currentResume!.copyWith(
      educations: educations,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Update education
  Future<void> updateEducation(Education education) async {
    if (_currentResume == null) return;
    final educations = _currentResume!.educations
        .map((e) => e.id == education.id ? education : e)
        .toList();
    _currentResume = _currentResume!.copyWith(
      educations: educations,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Delete education
  Future<void> deleteEducation(String educationId) async {
    if (_currentResume == null) return;
    final educations = _currentResume!.educations
        .where((e) => e.id != educationId)
        .toList();
    _currentResume = _currentResume!.copyWith(
      educations: educations,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Add skill
  Future<void> addSkill(Skill skill) async {
    if (_currentResume == null) return;
    final skills = List<Skill>.from(_currentResume!.skills);
    skills.add(skill);
    _currentResume = _currentResume!.copyWith(
      skills: skills,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Update skill
  Future<void> updateSkill(Skill skill) async {
    if (_currentResume == null) return;
    final skills = _currentResume!.skills
        .map((s) => s.id == skill.id ? skill : s)
        .toList();
    _currentResume = _currentResume!.copyWith(
      skills: skills,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Delete skill
  Future<void> deleteSkill(String skillId) async {
    if (_currentResume == null) return;
    final skills = _currentResume!.skills
        .where((s) => s.id != skillId)
        .toList();
    _currentResume = _currentResume!.copyWith(
      skills: skills,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Add language
  Future<void> addLanguage(lang.Language language) async {
    if (_currentResume == null) return;
    final languages = List<lang.Language>.from(_currentResume!.languages);
    languages.add(language);
    _currentResume = _currentResume!.copyWith(
      languages: languages,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Update language
  Future<void> updateLanguage(lang.Language language) async {
    if (_currentResume == null) return;
    final languages = _currentResume!.languages
        .map((l) => l.id == language.id ? language : l)
        .toList();
    _currentResume = _currentResume!.copyWith(
      languages: languages,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Delete language
  Future<void> deleteLanguage(String languageId) async {
    if (_currentResume == null) return;
    final languages = _currentResume!.languages
        .where((l) => l.id != languageId)
        .toList();
    _currentResume = _currentResume!.copyWith(
      languages: languages,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Add custom section
  Future<void> addCustomSection(CustomSection section) async {
    if (_currentResume == null) return;
    final sections = List<CustomSection>.from(_currentResume!.customSections);
    sections.add(section);
    _currentResume = _currentResume!.copyWith(
      customSections: sections,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Update custom section
  Future<void> updateCustomSection(CustomSection section) async {
    if (_currentResume == null) return;
    final sections = _currentResume!.customSections
        .map((s) => s.id == section.id ? section : s)
        .toList();
    _currentResume = _currentResume!.copyWith(
      customSections: sections,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Delete custom section
  Future<void> deleteCustomSection(String sectionId) async {
    if (_currentResume == null) return;
    final sections = _currentResume!.customSections
        .where((s) => s.id != sectionId)
        .toList();
    _currentResume = _currentResume!.copyWith(
      customSections: sections,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Reorder custom sections
  Future<void> reorderCustomSections(int oldIndex, int newIndex) async {
    if (_currentResume == null) return;
    final sections = List<CustomSection>.from(_currentResume!.customSections);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = sections.removeAt(oldIndex);
    sections.insert(newIndex, item);

    _currentResume = _currentResume!.copyWith(
      customSections: sections,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Update template
  Future<void> updateTemplate(String templateId) async {
    if (_currentResume == null) return;
    _currentResume = _currentResume!.copyWith(
      templateId: templateId,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Update custom title
  Future<void> updateCustomTitle(String? customTitle) async {
    if (_currentResume == null) return;
    _currentResume = _currentResume!.copyWith(
      customTitle: customTitle,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Update formatting
  Future<void> updateFormatting({
    double? fontSize,
    double? marginSize,
    String? fontFamily,
  }) async {
    if (_currentResume == null) return;
    _currentResume = _currentResume!.copyWith(
      fontSize: fontSize ?? _currentResume!.fontSize,
      marginSize: marginSize ?? _currentResume!.marginSize,
      fontFamily: fontFamily ?? _currentResume!.fontFamily,
      updatedAt: DateTime.now(),
    );
    await _saveCurrentResume();
    notifyListeners();
  }

  // Delete resume
  Future<void> deleteResume(String resumeId) async {
    await _storageService.deleteResume(resumeId);
    _savedResumes.removeWhere((r) => r.id == resumeId);
    if (_currentResume?.id == resumeId) {
      _currentResume = _savedResumes.isNotEmpty ? _savedResumes.first : null;
    }
    notifyListeners();
  }

  // Save current resume
  Future<void> _saveCurrentResume() async {
    if (_currentResume == null) return;
    await _storageService.saveResume(_currentResume!);

    // Update saved resumes list
    final index = _savedResumes.indexWhere((r) => r.id == _currentResume!.id);
    if (index >= 0) {
      _savedResumes[index] = _currentResume!;
    } else {
      _savedResumes.add(_currentResume!);
    }
  }
}
