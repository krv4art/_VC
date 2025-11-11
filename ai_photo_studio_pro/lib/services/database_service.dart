import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DatabaseService {
  // Generated Photos
  Future<int> insertGeneratedPhoto(dynamic photo);
  Future<void> updateGeneratedPhoto(dynamic photo);
  Future<void> deleteGeneratedPhoto(int id);
  Future<List<dynamic>> getAllGeneratedPhotos();

  // Generation Jobs
  Future<void> insertGenerationJob(dynamic job);
  Future<void> updateGenerationJob(dynamic job);
}
