import '../usage_tracking_service.dart';

/// Service for validating scan usage limits
class ScanUsageValidator {
  const ScanUsageValidator();

  /// Checks if user can perform a scan based on subscription status
  Future<bool> canUserScan(bool isPremium) async {
    // Premium users have unlimited scans
    if (isPremium) {
      return true;
    }

    // Check free user limits
    final usageService = UsageTrackingService();
    return await usageService.canUserScan();
  }

  /// Checks if user is premium and can scan
  bool get canPremiumUserScan => true;

  /// Checks if free user needs limit validation
  bool get needsLimitValidation => true;
}
