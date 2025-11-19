import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// Service for AI-powered outfit/clothing changes on photos
class AIOutfitChangeService {
  final SupabaseClient supabaseClient;

  AIOutfitChangeService({required this.supabaseClient});

  /// Change outfit/clothing in photo
  Future<String> changeOutfit({
    required String imagePath,
    required OutfitType outfitType,
    String? customPrompt,
  }) async {
    try {
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final response = await supabaseClient.functions.invoke(
        'outfit-change',
        body: {
          'action': 'change_outfit',
          'image': base64Image,
          'outfit_type': outfitType.toString().split('.').last,
          'custom_prompt': customPrompt,
        },
      );

      if (response.status != 200) {
        throw Exception('Outfit change failed: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;

      if (data.containsKey('url')) {
        return data['url'] as String;
      } else if (data.containsKey('job_id')) {
        return await _pollOutfitChangeJob(data['job_id'] as String);
      }

      throw Exception('Unexpected response from outfit change service');
    } catch (e) {
      debugPrint('Error changing outfit: $e');
      rethrow;
    }
  }

  /// Apply business suit
  Future<String> applyBusinessSuit(String imagePath, {Gender? gender}) async {
    return await changeOutfit(
      imagePath: imagePath,
      outfitType: gender == Gender.female
          ? OutfitType.businessSuitFemale
          : OutfitType.businessSuitMale,
    );
  }

  /// Apply medical scrubs
  Future<String> applyMedicalScrubs(String imagePath) async {
    return await changeOutfit(
      imagePath: imagePath,
      outfitType: OutfitType.medicalScrubs,
    );
  }

  /// Apply casual outfit
  Future<String> applyCasualOutfit(String imagePath) async {
    return await changeOutfit(
      imagePath: imagePath,
      outfitType: OutfitType.casualShirt,
    );
  }

  /// Apply formal dress
  Future<String> applyFormalDress(String imagePath) async {
    return await changeOutfit(
      imagePath: imagePath,
      outfitType: OutfitType.formalDress,
    );
  }

  /// Apply custom outfit with prompt
  Future<String> applyCustomOutfit(
    String imagePath,
    String prompt,
  ) async {
    return await changeOutfit(
      imagePath: imagePath,
      outfitType: OutfitType.custom,
      customPrompt: prompt,
    );
  }

  /// Poll for outfit change job completion
  Future<String> _pollOutfitChangeJob(String jobId) async {
    const maxAttempts = 60;
    const pollInterval = Duration(seconds: 5);

    for (int i = 0; i < maxAttempts; i++) {
      await Future.delayed(pollInterval);

      final response = await supabaseClient.functions.invoke(
        'outfit-change',
        body: {
          'action': 'check_status',
          'job_id': jobId,
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to check job status');
      }

      final data = response.data as Map<String, dynamic>;
      final status = data['status'] as String;

      if (status == 'completed') {
        return data['url'] as String;
      } else if (status == 'failed') {
        throw Exception('Outfit change job failed: ${data['error']}');
      }
    }

    throw Exception('Outfit change job timed out');
  }

  /// Get available outfit types
  static List<OutfitOption> getAvailableOutfits() {
    return [
      OutfitOption(
        type: OutfitType.businessSuitMale,
        name: 'Business Suit (Male)',
        description: 'Professional business suit for men',
        profession: 'Corporate, Business',
      ),
      OutfitOption(
        type: OutfitType.businessSuitFemale,
        name: 'Business Suit (Female)',
        description: 'Professional business suit for women',
        profession: 'Corporate, Business',
      ),
      OutfitOption(
        type: OutfitType.medicalScrubs,
        name: 'Medical Scrubs',
        description: 'Healthcare professional attire',
        profession: 'Doctor, Nurse, Healthcare',
      ),
      OutfitOption(
        type: OutfitType.labCoat,
        name: 'Lab Coat',
        description: 'White lab coat for medical/science professionals',
        profession: 'Doctor, Scientist',
      ),
      OutfitOption(
        type: OutfitType.casualShirt,
        name: 'Casual Shirt',
        description: 'Smart casual shirt',
        profession: 'Tech, Creative',
      ),
      OutfitOption(
        type: OutfitType.polo,
        name: 'Polo Shirt',
        description: 'Business casual polo',
        profession: 'Sales, Service',
      ),
      OutfitOption(
        type: OutfitType.sweater,
        name: 'Sweater',
        description: 'Professional sweater',
        profession: 'Creative, Academic',
      ),
      OutfitOption(
        type: OutfitType.blazer,
        name: 'Blazer',
        description: 'Smart blazer jacket',
        profession: 'Business, Professional',
      ),
      OutfitOption(
        type: OutfitType.formalDress,
        name: 'Formal Dress',
        description: 'Formal professional dress',
        profession: 'Executive, Professional',
      ),
      OutfitOption(
        type: OutfitType.turtleneck,
        name: 'Turtleneck',
        description: 'Elegant turtleneck',
        profession: 'Creative, Fashion',
      ),
    ];
  }
}

enum OutfitType {
  businessSuitMale,
  businessSuitFemale,
  medicalScrubs,
  labCoat,
  casualShirt,
  polo,
  sweater,
  blazer,
  formalDress,
  turtleneck,
  custom,
}

enum Gender {
  male,
  female,
  unspecified,
}

class OutfitOption {
  final OutfitType type;
  final String name;
  final String description;
  final String profession;

  OutfitOption({
    required this.type,
    required this.name,
    required this.description,
    required this.profession,
  });

  @override
  String toString() => '$name - $description';
}
