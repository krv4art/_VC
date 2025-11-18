/// Route names for the application
/// All routes are defined here for easy reference and type safety
class RouteNames {
  // Private constructor to prevent instantiation
  RouteNames._();

  // ==================== MAIN ROUTES ====================
  static const String home = '/';
  static const String library = '/library';
  static const String settings = '/settings';

  // ==================== SCANNER ROUTES ====================
  static const String scanner = '/scanner';
  static const String scanPreview = '/scanner/preview';
  static const String scanEdit = '/scanner/edit';

  // ==================== EDITOR ROUTES ====================
  static const String pdfViewer = '/pdf-viewer';
  static const String pdfEditor = '/pdf-editor';
  static const String annotations = '/pdf-editor/annotations';

  // ==================== CONVERTER ROUTES ====================
  static const String converter = '/converter';
  static const String imageToPdf = '/converter/image-to-pdf';
  static const String pdfToImage = '/converter/pdf-to-image';
  static const String officeToPdf = '/converter/office-to-pdf';

  // ==================== TOOLS ROUTES ====================
  static const String tools = '/tools';
  static const String compress = '/tools/compress';
  static const String merge = '/tools/merge';
  static const String split = '/tools/split';
  static const String rotate = '/tools/rotate';
  static const String watermark = '/tools/watermark';
  static const String protect = '/tools/protect';

  // ==================== HELPER METHODS ====================

  /// Get PDF viewer route with document ID
  static String pdfViewerWithId(String documentId) => '$pdfViewer?id=$documentId';

  /// Get PDF editor route with document ID
  static String pdfEditorWithId(String documentId) => '$pdfEditor?id=$documentId';
}
