import 'dart:developer' as developer;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/analysis_result.dart';
import 'auth_service.dart';

/// Сервис синхронизации данных с облаком
class SyncService {
  final SupabaseClient _client = Supabase.instance.client;
  final AuthService _authService = AuthService();

  /// Синхронизирует локальную коллекцию с облаком
  Future<bool> syncCollection(List<AnalysisResult> localCollection) async {
    if (!_authService.isAuthenticated) {
      developer.log('User not authenticated, skipping sync', name: 'SyncService');
      return false;
    }

    try {
      developer.log('Starting collection sync', name: 'SyncService');

      final userId = _authService.userId!;

      // Загружаем существующую коллекцию из облака
      final cloudCollection = await getCloudCollection();

      // Объединяем коллекции (приоритет у локальных данных)
      final mergedCollection = _mergeCollections(localCollection, cloudCollection);

      // Сохраняем объединенную коллекцию в облако
      await _saveCollectionToCloud(userId, mergedCollection);

      developer.log('Collection synced successfully', name: 'SyncService');
      return true;
    } catch (e, stackTrace) {
      developer.log(
        'Sync error: $e',
        name: 'SyncService',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Получает коллекцию из облака
  Future<List<AnalysisResult>> getCloudCollection() async {
    if (!_authService.isAuthenticated) {
      return [];
    }

    try {
      final userId = _authService.userId!;

      final response = await _client
          .from('user_collections')
          .select('collection_data')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        developer.log('No cloud collection found', name: 'SyncService');
        return [];
      }

      final List<dynamic> collectionJson = response['collection_data'] as List<dynamic>;
      final collection = collectionJson
          .map((json) => AnalysisResult.fromJson(json as Map<String, dynamic>))
          .toList();

      developer.log('Loaded ${collection.length} items from cloud', name: 'SyncService');
      return collection;
    } catch (e) {
      developer.log('Error loading cloud collection: $e', name: 'SyncService');
      return [];
    }
  }

  /// Сохраняет коллекцию в облако
  Future<bool> _saveCollectionToCloud(String userId, List<AnalysisResult> collection) async {
    try {
      final collectionJson = collection.map((item) => item.toJson()).toList();

      await _client.from('user_collections').upsert({
        'user_id': userId,
        'collection_data': collectionJson,
        'updated_at': DateTime.now().toIso8601String(),
      });

      developer.log('Saved ${collection.length} items to cloud', name: 'SyncService');
      return true;
    } catch (e) {
      developer.log('Error saving to cloud: $e', name: 'SyncService');
      return false;
    }
  }

  /// Объединяет локальную и облачную коллекции
  List<AnalysisResult> _mergeCollections(
    List<AnalysisResult> local,
    List<AnalysisResult> cloud,
  ) {
    final Map<String, AnalysisResult> merged = {};

    // Добавляем облачные предметы
    for (final item in cloud) {
      merged[item.itemName] = item;
    }

    // Перезаписываем локальными (они имеют приоритет)
    for (final item in local) {
      merged[item.itemName] = item;
    }

    return merged.values.toList();
  }

  /// Загружает изображение в облачное хранилище
  Future<String?> uploadImage(String localPath, String fileName) async {
    if (!_authService.isAuthenticated) {
      return null;
    }

    try {
      final userId = _authService.userId!;
      final storagePath = '$userId/$fileName';

      await _client.storage.from('antique_photos').upload(
            storagePath,
            localPath,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = _client.storage.from('antique_photos').getPublicUrl(storagePath);

      developer.log('Image uploaded: $publicUrl', name: 'SyncService');
      return publicUrl;
    } catch (e) {
      developer.log('Error uploading image: $e', name: 'SyncService');
      return null;
    }
  }

  /// Удаляет коллекцию из облака
  Future<bool> deleteCloudCollection() async {
    if (!_authService.isAuthenticated) {
      return false;
    }

    try {
      final userId = _authService.userId!;

      await _client.from('user_collections').delete().eq('user_id', userId);

      developer.log('Cloud collection deleted', name: 'SyncService');
      return true;
    } catch (e) {
      developer.log('Error deleting cloud collection: $e', name: 'SyncService');
      return false;
    }
  }

  /// Получает последнее время синхронизации
  Future<DateTime?> getLastSyncTime() async {
    if (!_authService.isAuthenticated) {
      return null;
    }

    try {
      final userId = _authService.userId!;

      final response = await _client
          .from('user_collections')
          .select('updated_at')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return DateTime.parse(response['updated_at'] as String);
    } catch (e) {
      developer.log('Error getting last sync time: $e', name: 'SyncService');
      return null;
    }
  }

  /// Проверяет, нужна ли синхронизация
  Future<bool> needsSync(DateTime? lastLocalUpdate) async {
    final lastSyncTime = await getLastSyncTime();

    if (lastSyncTime == null) {
      return true; // Нет данных в облаке, нужна синхронизация
    }

    if (lastLocalUpdate == null) {
      return true; // Нет локальных данных, нужна загрузка из облака
    }

    // Нужна синхронизация, если локальные данные новее
    return lastLocalUpdate.isAfter(lastSyncTime);
  }

  /// Автоматическая синхронизация при изменениях
  Future<void> autoSync(List<AnalysisResult> collection) async {
    if (_authService.isAuthenticated) {
      await syncCollection(collection);
    }
  }
}
