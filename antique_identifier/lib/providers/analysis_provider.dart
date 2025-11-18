import 'package:flutter/foundation.dart';
import '../models/analysis_result.dart';
import '../models/dialogue.dart';

/// Provider для управления состоянием анализа антиквариата
class AnalysisProvider extends ChangeNotifier {
  AnalysisResult? _currentAnalysis;
  Dialogue? _currentDialogue;
  bool _isLoading = false;
  String? _error;
  List<AnalysisResult> _history = [];

  // Getters
  AnalysisResult? get currentAnalysis => _currentAnalysis;
  Dialogue? get currentDialogue => _currentDialogue;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<AnalysisResult> get history => _history;

  /// Устанавливает текущий результат анализа
  void setCurrentAnalysis(AnalysisResult? analysis) {
    _currentAnalysis = analysis;
    if (analysis != null && !_history.contains(analysis)) {
      _history.insert(0, analysis);
    }
    _error = null;
    notifyListeners();
  }

  /// Устанавливает текущий диалог
  void setCurrentDialogue(Dialogue? dialogue) {
    _currentDialogue = dialogue;
    notifyListeners();
  }

  /// Устанавливает состояние загрузки
  void setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _error = null;
    }
    notifyListeners();
  }

  /// Устанавливает ошибку
  void setError(String? error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  /// Очищает ошибку
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Очищает текущий анализ
  void clearCurrentAnalysis() {
    _currentAnalysis = null;
    _currentDialogue = null;
    notifyListeners();
  }

  /// Добавляет анализ в историю
  void addToHistory(AnalysisResult analysis) {
    if (!_history.any((a) => a.itemName == analysis.itemName)) {
      _history.insert(0, analysis);
      notifyListeners();
    }
  }

  /// Очищает историю
  void clearHistory() {
    _history.clear();
    notifyListeners();
  }

  /// Удаляет анализ из истории
  void removeFromHistory(AnalysisResult analysis) {
    _history.remove(analysis);
    notifyListeners();
  }
}
