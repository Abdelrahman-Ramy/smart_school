class MaterialUploadResponse {
  final bool success;
  final String message;

  MaterialUploadResponse({
    required this.success,
    required this.message,
  });

  factory MaterialUploadResponse.fromJson(dynamic json) {
    if (json == null) {
      return MaterialUploadResponse(
        success: true, 
        message: 'Uploaded successfully',
      );
    }
    
    if (json is Map<String, dynamic>) {
      return MaterialUploadResponse(
        success: json['success'] as bool? ?? true,
        message: json['message']?.toString() ?? 'Uploaded successfully',
      );
    }

    return MaterialUploadResponse(
      success: true,
      message: json.toString(),
    );
  }
}