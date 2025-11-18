import 'package:flutter/material.dart';

/// Simplified localization delegate
/// In production, use flutter_gen for proper i18n
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Common strings
  String get appName => 'CV Engineer';
  String get home => 'Home';
  String get editor => 'Editor';
  String get preview => 'Preview';
  String get settings => 'Settings';
  String get save => 'Save';
  String get cancel => 'Cancel';
  String get delete => 'Delete';
  String get edit => 'Edit';
  String get add => 'Add';
  String get done => 'Done';
  String get next => 'Next';
  String get back => 'Back';
  String get skip => 'Skip';
  String get getStarted => 'Get Started';

  // Resume sections
  String get personalInfo => 'Personal Information';
  String get experience => 'Experience';
  String get education => 'Education';
  String get skills => 'Skills';
  String get languages => 'Languages';
  String get customSections => 'Custom Sections';

  // Personal info fields
  String get fullName => 'Full Name';
  String get email => 'Email';
  String get phone => 'Phone';
  String get address => 'Address';
  String get city => 'City';
  String get country => 'Country';
  String get website => 'Website';
  String get linkedin => 'LinkedIn';
  String get github => 'GitHub';
  String get profileSummary => 'Profile Summary';

  // Templates
  String get selectTemplate => 'Select Template';
  String get changeTemplate => 'Change Template';
  String get professional => 'Professional';
  String get creative => 'Creative';
  String get modern => 'Modern';

  // Settings
  String get darkMode => 'Dark Mode';
  String get language => 'Language';
  String get fontSize => 'Font Size';
  String get margins => 'Margins';

  // Actions
  String get exportPDF => 'Export PDF';
  String get share => 'Share';
  String get createNewResume => 'Create New Resume';
  String get interviewQuestions => 'Interview Questions';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'de', 'fr', 'it', 'pl', 'pt', 'tr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
