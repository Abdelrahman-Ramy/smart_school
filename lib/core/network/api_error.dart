class ApiError {
  String message;
  String? statusCode;

  ApiError({required this.message,this.statusCode});

  @override
  String toString() {
    return message;
  }
}
