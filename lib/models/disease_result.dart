class DiseaseResult {
  /// Translation key for crop type (e.g., 'crop_maize'.tr)
  final String crop;

  /// Translation key for diagnosis label (e.g., 'diagnosis_gray_leaf_spot'.tr)
  final String label;

  /// Raw label from the model (e.g., 'Maize_Gray_Leaf_Spot')
  final String rawLabel;

  /// Confidence score from the model (0.0 to 1.0)
  final double confidence;

  /// Translation key for symptoms (e.g., 'mgls_symptoms'.tr)
  final String symptoms;

  /// Translation key for treatment (e.g., 'mgls_treatment'.tr)
  final String treatment;

  /// Translation key for recommendation message (e.g., 'maize_gray_leaf_spot_msg'.tr)
  final String message;

  /// Translation key for crop status (e.g., 'status_diseased'.tr)
  final String status;

  const DiseaseResult({
    required this.crop,
    required this.label,
    this.rawLabel = '',
    required this.confidence,
    required this.symptoms,
    required this.treatment,
    required this.message,
    required this.status,
  });
}