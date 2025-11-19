import 'package:flutter/foundation.dart';
import '../models/pdf_document.dart';
import '../models/annotation.dart';
import '../services/pdf/pdf_editor_service.dart';
import '../exceptions/pdf_exception.dart';

/// Provider for managing PDF editing state
class EditorProvider with ChangeNotifier {
  final PDFEditorService _editorService = PDFEditorService();

  // Current document being edited
  PDFDocument? _currentDocument;
  PDFDocument? get currentDocument => _currentDocument;

  // Current page number
  int _currentPage = 1;
  int get currentPage => _currentPage;

  // Total pages
  int _totalPages = 1;
  int get totalPages => _totalPages;

  // Annotations for current document
  List<Annotation> _annotations = [];
  List<Annotation> get annotations => _annotations;

  // Current annotation being created/edited
  Annotation? _currentAnnotation;
  Annotation? get currentAnnotation => _currentAnnotation;

  // Editing mode (view, highlight, note, draw, etc.)
  EditorMode _mode = EditorMode.view;
  EditorMode get mode => _mode;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Saving state
  bool _isSaving = false;
  bool get isSaving => _isSaving;

  // Has unsaved changes
  bool _hasUnsavedChanges = false;
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  // Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Load document for editing
  Future<void> loadDocument(PDFDocument document) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentDocument = document;
      _currentPage = 1;
      _totalPages = document.pageCount;
      _annotations = []; // TODO: Load from database
      _hasUnsavedChanges = false;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load document';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Change current page
  void setCurrentPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  /// Go to next page
  void nextPage() {
    if (_currentPage < _totalPages) {
      _currentPage++;
      notifyListeners();
    }
  }

  /// Go to previous page
  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  /// Set editor mode
  void setMode(EditorMode newMode) {
    _mode = newMode;
    notifyListeners();
  }

  /// Add annotation
  void addAnnotation(Annotation annotation) {
    _annotations.add(annotation);
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  /// Update annotation
  void updateAnnotation(String annotationId, Annotation updatedAnnotation) {
    final index = _annotations.indexWhere((a) => a.id == annotationId);
    if (index != -1) {
      _annotations[index] = updatedAnnotation;
      _hasUnsavedChanges = true;
      notifyListeners();
    }
  }

  /// Remove annotation
  void removeAnnotation(String annotationId) {
    _annotations.removeWhere((a) => a.id == annotationId);
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  /// Get annotations for current page
  List<Annotation> getAnnotationsForCurrentPage() {
    return _annotations
        .where((a) => a.pageNumber == _currentPage)
        .toList();
  }

  /// Save changes
  Future<void> saveChanges() async {
    if (_currentDocument == null) return;

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Save annotations to database
      // TODO: Update PDF file if needed

      _hasUnsavedChanges = false;
      _isSaving = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to save changes';
      _isSaving = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Add text to PDF
  Future<void> addText({
    required String text,
    required double x,
    required double y,
    String? fontFamily,
    double? fontSize,
    int? color,
  }) async {
    if (_currentDocument == null) return;

    try {
      await _editorService.addText(
        pdfPath: _currentDocument!.filePath,
        text: text,
        x: x,
        y: y,
        pageNumber: _currentPage,
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: color,
      );

      _hasUnsavedChanges = true;
      notifyListeners();
    } catch (e) {
      throw PDFEditException(
        'Failed to add text',
        operation: 'addText',
        originalError: e,
      );
    }
  }

  /// Add image to PDF
  Future<void> addImage({
    required String imagePath,
    required double x,
    required double y,
    double? width,
    double? height,
  }) async {
    if (_currentDocument == null) return;

    try {
      await _editorService.addImage(
        pdfPath: _currentDocument!.filePath,
        imagePath: imagePath,
        x: x,
        y: y,
        pageNumber: _currentPage,
        width: width,
        height: height,
      );

      _hasUnsavedChanges = true;
      notifyListeners();
    } catch (e) {
      throw PDFEditException(
        'Failed to add image',
        operation: 'addImage',
        originalError: e,
      );
    }
  }

  /// Rotate page
  Future<void> rotatePage(int degrees) async {
    if (_currentDocument == null) return;

    try {
      await _editorService.rotatePage(
        pdfPath: _currentDocument!.filePath,
        pageNumber: _currentPage,
        degrees: degrees,
      );

      _hasUnsavedChanges = true;
      notifyListeners();
    } catch (e) {
      throw PDFEditException(
        'Failed to rotate page',
        operation: 'rotatePage',
        originalError: e,
      );
    }
  }

  /// Delete current page
  Future<void> deleteCurrentPage() async {
    if (_currentDocument == null || _totalPages <= 1) return;

    try {
      await _editorService.deletePage(
        pdfPath: _currentDocument!.filePath,
        pageNumber: _currentPage,
      );

      _totalPages--;
      if (_currentPage > _totalPages) {
        _currentPage = _totalPages;
      }

      _hasUnsavedChanges = true;
      notifyListeners();
    } catch (e) {
      throw PDFEditException(
        'Failed to delete page',
        operation: 'deletePage',
        originalError: e,
      );
    }
  }

  /// Reset provider state
  void reset() {
    _currentDocument = null;
    _currentPage = 1;
    _totalPages = 1;
    _annotations = [];
    _currentAnnotation = null;
    _mode = EditorMode.view;
    _isLoading = false;
    _isSaving = false;
    _hasUnsavedChanges = false;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}

/// Editor modes
enum EditorMode {
  view,
  highlight,
  note,
  draw,
  text,
  image,
  signature,
}
