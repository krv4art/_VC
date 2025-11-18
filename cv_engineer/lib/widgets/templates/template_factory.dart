import 'package:flutter/material.dart';
import '../../models/resume.dart';
import 'resume_template.dart';
import 'professional_template.dart';
import 'creative_template.dart';
import 'modern_template.dart';

/// Factory class for creating resume templates
class TemplateFactory {
  /// Get all available templates
  static List<TemplateInfo> getAllTemplates() {
    return [
      TemplateInfo(
        id: 'professional',
        name: 'Professional',
        description: 'Clean and traditional layout perfect for corporate roles',
        primaryColor: const Color(0xFF1976D2),
        thumbnailPath: 'assets/templates/professional.png',
      ),
      TemplateInfo(
        id: 'creative',
        name: 'Creative',
        description: 'Bold and modern design for creative professionals',
        primaryColor: const Color(0xFF9C27B0),
        thumbnailPath: 'assets/templates/creative.png',
      ),
      TemplateInfo(
        id: 'modern',
        name: 'Modern',
        description: 'Clean and minimal design perfect for tech professionals',
        primaryColor: const Color(0xFF009688),
        thumbnailPath: 'assets/templates/modern.png',
      ),
    ];
  }

  /// Create a template widget based on template ID
  static ResumeTemplate createTemplate(String templateId, Resume resume) {
    switch (templateId) {
      case 'professional':
        return ProfessionalTemplate(resume: resume);
      case 'creative':
        return CreativeTemplate(resume: resume);
      case 'modern':
        return ModernTemplate(resume: resume);
      default:
        return ProfessionalTemplate(resume: resume);
    }
  }

  /// Get template info by ID
  static TemplateInfo? getTemplateInfo(String templateId) {
    try {
      return getAllTemplates().firstWhere((t) => t.id == templateId);
    } catch (e) {
      return null;
    }
  }
}

/// Template information for display
class TemplateInfo {
  final String id;
  final String name;
  final String description;
  final Color primaryColor;
  final String thumbnailPath;

  const TemplateInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.thumbnailPath,
  });
}
