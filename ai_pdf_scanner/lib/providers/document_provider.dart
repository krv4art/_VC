import 'package:flutter/foundation.dart';
import '../models/pdf_document.dart';
import '../services/storage/database_service.dart';

/// Provider for managing PDF documents
/// Handles CRUD operations and state management for documents
class DocumentProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<PdfDocument> _documents = [];
  List<PdfDocument> _favorites = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<PdfDocument> get documents => _documents;
  List<PdfDocument> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all documents from database
  Future<void> loadDocuments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _documents = await _databaseService.getAllDocuments();
      _favorites = await _databaseService.getFavoriteDocuments();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load documents: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new document
  Future<void> addDocument(PdfDocument document) async {
    try {
      await _databaseService.insertDocument(document);
      _documents.insert(0, document); // Add to beginning of list
      if (document.isFavorite) {
        _favorites.insert(0, document);
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add document: $e';
      notifyListeners();
    }
  }

  /// Update a document
  Future<void> updateDocument(PdfDocument document) async {
    try {
      await _databaseService.updateDocument(document);
      final index = _documents.indexWhere((d) => d.id == document.id);
      if (index != -1) {
        _documents[index] = document;
      }
      // Update favorites list
      final favIndex = _favorites.indexWhere((d) => d.id == document.id);
      if (document.isFavorite) {
        if (favIndex == -1) {
          _favorites.insert(0, document);
        } else {
          _favorites[favIndex] = document;
        }
      } else {
        if (favIndex != -1) {
          _favorites.removeAt(favIndex);
        }
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update document: $e';
      notifyListeners();
    }
  }

  /// Delete a document
  Future<void> deleteDocument(String id) async {
    try {
      await _databaseService.deleteDocument(id);
      _documents.removeWhere((d) => d.id == id);
      _favorites.removeWhere((d) => d.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete document: $e';
      notifyListeners();
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String id) async {
    try {
      await _databaseService.toggleFavorite(id);
      final doc = _documents.firstWhere((d) => d.id == id);
      final updatedDoc = doc.copyWith(
        isFavorite: !doc.isFavorite,
        updatedAt: DateTime.now(),
      );
      await updateDocument(updatedDoc);
    } catch (e) {
      _error = 'Failed to toggle favorite: $e';
      notifyListeners();
    }
  }

  /// Search documents
  Future<List<PdfDocument>> searchDocuments(String query) async {
    try {
      return await _databaseService.searchDocuments(query);
    } catch (e) {
      _error = 'Failed to search documents: $e';
      notifyListeners();
      return [];
    }
  }

  /// Get documents by type
  Future<List<PdfDocument>> getDocumentsByType(DocumentType type) async {
    try {
      return await _databaseService.getDocumentsByType(type);
    } catch (e) {
      _error = 'Failed to get documents by type: $e';
      notifyListeners();
      return [];
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
